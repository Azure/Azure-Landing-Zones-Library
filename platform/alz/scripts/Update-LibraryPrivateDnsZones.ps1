[CmdletBinding()]
param (
  [Parameter()][String]$TargetPath = (Split-Path $PSScriptRoot -Parent)
)

$ErrorActionPreference = "Stop"

function Read-Artifact([String]$Path) {
  Get-Content -LiteralPath (Join-Path $TargetPath $Path) -Raw | ConvertFrom-Json -AsHashtable -Depth 100
}

function Write-Artifact([String]$Path, $Artifact) {
  $json = (ConvertTo-StableObject $Artifact) | ConvertTo-Json -Depth 100
  [System.IO.File]::WriteAllText((Join-Path $TargetPath $Path), ($json.Replace("`r`n", "`n") + "`n"))
}

function ConvertTo-StableObject($Value) {
  if ($Value -is [System.Collections.IDictionary]) {
    $result = [ordered]@{}
    $keys = if ($Value.GetType() -eq [hashtable]) { @($Value.Keys | Sort-Object) } else { @($Value.Keys) }
    foreach ($key in $keys) {
      $result[$key] = ConvertTo-StableObject $Value[$key]
    }
    return $result
  }
  if ($Value -is [array]) {
    return ,@($Value | ForEach-Object { ConvertTo-StableObject $_ })
  }
  return $Value
}

function Add-ZoneValues($Values, $Additional) {
  $result = [System.Collections.Generic.List[string]]::new()
  $result.AddRange([string[]]$Values)
  foreach ($value in ($Additional | Sort-Object -Unique)) {
    if ($result.Contains($value)) {
      continue
    }
    $index = 0
    while ($index -lt $result.Count -and [StringComparer]::OrdinalIgnoreCase.Compare($result[$index], $value) -lt 0) {
      $index++
    }
    $result.Insert($index, $value)
  }
  return ,$result.ToArray()
}

function Copy-Object($Value) {
  $Value | ConvertTo-Json -Depth 100 | ConvertFrom-Json -AsHashtable -Depth 100
}

function New-ZoneParameter([String]$Name) {
  [ordered]@{
    metadata = [ordered]@{
      assignPermissions = $true
      description       = "Resource ID of the existing private DNS zone."
      displayName       = $Name
      strongType        = "Microsoft.Network/privateDnsZones"
    }
    type     = "String"
  }
}

function New-ZoneConfig([String]$Name, [String]$Parameter) {
  [ordered]@{
    name       = $Name
    properties = @{ privateDnsZoneId = "[parameters('$Parameter')]" }
  }
}

function Set-Target($Policy, [String]$ResourceType, [String]$GroupId) {
  $Policy.properties.parameters.Remove("resourceType")
  $Policy.properties.parameters.Remove("groupId")
  foreach ($connection in $Policy.properties.policyRule.if.allOf[1].anyOf) {
    $connection.count.where.allOf[0].contains = $ResourceType
    $connection.count.where.allOf[1].equals = $GroupId
  }
}

function Add-ServiceReference($Policy) {
  $deployment = $Policy.properties.policyRule.then.details.deployment.properties
  $deployment.template.parameters.privateLinkServiceId = @{ type = "string" }
  $deployment.parameters.privateLinkServiceId = @{
    value = "[first(union(field('Microsoft.Network/privateEndpoints/privateLinkServiceConnections[*].privateLinkServiceId'), field('Microsoft.Network/privateEndpoints/manualPrivateLinkServiceConnections[*].privateLinkServiceId')))]"
  }
  $Policy.properties.policyRule.then.details.roleDefinitionIds += "/providers/Microsoft.Authorization/roleDefinitions/acdd72a7-3385-48ef-bd42-f606fba81ae7"
}

$generic = Read-Artifact "policy_definitions\Deploy-Private-DNS-Generic.alz_policy_definition.json"
$generic.name = "Deploy-Private-DNS-ZoneGroup"
$generic.properties.displayName = "Configure private endpoints to use a private DNS zone"
$generic.properties.description = "Configure a private DNS zone group for the specified private endpoint resource type and subresource, in any region."
$generic.properties.metadata.version = "1.0.0"
$generic.properties.metadata.source = "https://github.com/Azure/Azure-Landing-Zones-Library/"
$generic.properties.metadata.alzCloudEnvironments = @("AzureCloud")
$generic.properties.parameters.Remove("location")
$generic.properties.parameters.evaluationDelay.defaultValue = "AfterProvisioningSuccess"
$generic.properties.policyRule.if.allOf = @($generic.properties.policyRule.if.allOf[1], $generic.properties.policyRule.if.allOf[2])
$generic.properties.policyRule.then.details.Remove("existenceCondition")
Write-Artifact "policy_definitions\$($generic.name).alz_policy_definition.json" $generic

$cognitive = Copy-Object $generic
$cognitive.name = "Deploy-Private-DNS-CognitiveServices"
$cognitive.properties.displayName = "Configure Cognitive Services, OpenAI and AI Services private DNS zones"
$cognitive.properties.description = "Select the private DNS zones by Cognitive Services account kind. OpenAI uses its OpenAI zone, AIServices uses all three zones, and other kinds retain the Cognitive Services zone."
Set-Target $cognitive "Microsoft.CognitiveServices/accounts" "account"
Add-ServiceReference $cognitive
$cognitive.properties.parameters.openaiPrivateDnsZoneId = New-ZoneParameter "OpenAI private DNS zone ID"
$cognitive.properties.parameters.aiServicesPrivateDnsZoneId = New-ZoneParameter "AI Services private DNS zone ID"
$deployment = $cognitive.properties.policyRule.then.details.deployment.properties
foreach ($parameter in @("openaiPrivateDnsZoneId", "aiServicesPrivateDnsZoneId")) {
  $deployment.template.parameters[$parameter] = @{ type = "string" }
  $deployment.parameters[$parameter] = @{ value = "[parameters('$parameter')]" }
}
$deployment.template.variables = [ordered]@{
  cognitiveServicesZoneConfigs = @((New-ZoneConfig "cognitiveservices" "privateDnsZoneId"))
  openaiZoneConfigs            = @((New-ZoneConfig "openai" "openaiPrivateDnsZoneId"))
  aiServicesZoneConfigs        = @(
    (New-ZoneConfig "aiservices-cognitive" "privateDnsZoneId"),
    (New-ZoneConfig "aiservices-openai" "openaiPrivateDnsZoneId"),
    (New-ZoneConfig "aiservices" "aiServicesPrivateDnsZoneId")
  )
}
$deployment.template.resources[0].properties.privateDnsZoneConfigs = "[if(equals(reference(parameters('privateLinkServiceId'), '2022-12-01', 'Full').kind, 'OpenAI'), variables('openaiZoneConfigs'), if(equals(reference(parameters('privateLinkServiceId'), '2022-12-01', 'Full').kind, 'AIServices'), variables('aiServicesZoneConfigs'), variables('cognitiveServicesZoneConfigs')))]"
Write-Artifact "policy_definitions\$($cognitive.name).alz_policy_definition.json" $cognitive

$staticWebApps = Copy-Object $generic
$staticWebApps.name = "Deploy-Private-DNS-StaticWebApps"
$staticWebApps.properties.displayName = "Configure Static Web Apps private DNS zones"
$staticWebApps.properties.description = "Configure the private DNS zone group using the Static Web App default hostname, selecting the unpartitioned or partition-specific zone in the supplied zone's resource group."
Set-Target $staticWebApps "Microsoft.Web/staticSites" "staticSites"
Add-ServiceReference $staticWebApps
$deployment = $staticWebApps.properties.policyRule.then.details.deployment.properties
$deployment.template.resources[0].properties.privateDnsZoneConfigs[0].name = "static-web-apps"
$deployment.template.resources[0].properties.privateDnsZoneConfigs[0].properties.privateDnsZoneId = "[concat(substring(parameters('privateDnsZoneId'), 0, lastIndexOf(parameters('privateDnsZoneId'), '/')), '/privatelink.', join(skip(split(reference(parameters('privateLinkServiceId'), '2023-12-01').defaultHostname, '.'), 1), '.'))]"
Write-Artifact "policy_definitions\$($staticWebApps.name).alz_policy_definition.json" $staticWebApps

$zones = [ordered]@{
  azureApiManagementPrivateDnsZoneId = "privatelink.azure-api.net"
  azureStaticWebAppsPrivateDnsZoneId = "privatelink.azurestaticapps.net"
  azureOpenAIPrivateDnsZoneId        = "privatelink.openai.azure.com"
  azureAIServicesPrivateDnsZoneId    = "privatelink.services.ai.azure.com"
  azureSQLPrivateDnsZoneId           = "privatelink.database.windows.net"
  azureMySQLPrivateDnsZoneId         = "privatelink.mysql.database.azure.com"
}

function Get-ZoneExpression([String]$Parameter) {
  "[if(equals(parameters('dnsZoneSubscriptionId'), ''), parameters('$Parameter'), format('/subscriptions/{0}/resourceGroups/{1}/providers/{2}/{3}', parameters('dnsZoneSubscriptionId'), toLower(parameters('dnsZoneResourceGroupName')), parameters('dnsZoneResourceType'), parameters('dnsZoneNames').$Parameter))]"
}

function New-Reference([String]$Name, [String]$PolicyName, [String]$ZoneParameter) {
  [ordered]@{
    groupNames                  = @()
    parameters                  = [ordered]@{
      effect           = @{ value = "[parameters('effect')]" }
      privateDnsZoneId = @{ value = (Get-ZoneExpression $ZoneParameter) }
    }
    policyDefinitionId          = "/providers/Microsoft.Management/managementGroups/placeholder/providers/Microsoft.Authorization/policyDefinitions/$PolicyName"
    policyDefinitionReferenceId = $Name
  }
}

$initiativePath = "policy_set_definitions\Deploy-Private-DNS-Zones.alz_policy_set_definition.json"
$initiative = Read-Artifact $initiativePath
if ([version]$initiative.properties.metadata.version -lt [version]"2.6.0") {
  $initiative.properties.metadata.version = "2.6.0"
}
foreach ($parameter in $zones.Keys) {
  $definition = New-ZoneParameter $parameter
  $definition.defaultValue = ""
  $initiative.properties.parameters[$parameter] = $definition
  $initiative.properties.parameters.dnsZoneNames.defaultValue[$parameter] = $zones[$parameter]
}

$references = @(
  (New-Reference "DINE-Private-DNS-Azure-ApiManagement" $generic.name "azureApiManagementPrivateDnsZoneId"),
  (New-Reference "DINE-Private-DNS-Azure-SQL" $generic.name "azureSQLPrivateDnsZoneId"),
  (New-Reference "DINE-Private-DNS-Azure-MySQL" $generic.name "azureMySQLPrivateDnsZoneId"),
  (New-Reference "DINE-Private-DNS-Azure-StaticWebApps" $staticWebApps.name "azureStaticWebAppsPrivateDnsZoneId"),
  (New-Reference "DINE-Private-DNS-Azure-CognitiveServices" $cognitive.name "azureCognitiveServicesPrivateDnsZoneId")
)
$targets = @(
  @("Microsoft.ApiManagement/service", "Gateway"),
  @("Microsoft.Sql/servers", "sqlServer"),
  @("Microsoft.DBforMySQL/", "mysqlServer")
)
for ($index = 0; $index -lt $targets.Count; $index++) {
  $references[$index].parameters.resourceType = @{ value = $targets[$index][0] }
  $references[$index].parameters.groupId = @{ value = $targets[$index][1] }
}
$references[4].parameters.openaiPrivateDnsZoneId = @{ value = (Get-ZoneExpression "azureOpenAIPrivateDnsZoneId") }
$references[4].parameters.aiServicesPrivateDnsZoneId = @{ value = (Get-ZoneExpression "azureAIServicesPrivateDnsZoneId") }
foreach ($reference in $references) {
  $existing = @($initiative.properties.policyDefinitions | Where-Object { $_.policyDefinitionReferenceId -eq $reference.policyDefinitionReferenceId })
  if ($existing.Count -gt 1) {
    throw "Duplicate DNS policy reference: $($reference.policyDefinitionReferenceId)."
  }
  if ($existing.Count -eq 1) {
    $index = [array]::IndexOf($initiative.properties.policyDefinitions, $existing[0])
    $initiative.properties.policyDefinitions[$index] = $reference
  }
  else {
    $initiative.properties.policyDefinitions += $reference
  }
}
Write-Artifact $initiativePath $initiative

$assignmentPath = "policy_assignments\Deploy-Private-DNS-Zones.alz_policy_assignment.json"
$assignment = Read-Artifact $assignmentPath
foreach ($parameter in $zones.Keys) {
  $assignment.properties.parameters[$parameter] = @{
    value = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/placeholder/providers/Microsoft.Network/privateDnsZones/$($zones[$parameter])"
  }
}
Write-Artifact $assignmentPath $assignment

$auditZones = @($zones.Values) + @(1..5 | ForEach-Object { "privatelink.$_.azurestaticapps.net" })
$auditPath = "policy_definitions\Audit-PrivateLinkDnsZones.alz_policy_definition.json"
$audit = Read-Artifact $auditPath
if ([version]$audit.properties.metadata.version -lt [version]"1.1.0") {
  $audit.properties.metadata.version = "1.1.0"
}
$audit.properties.parameters.privateLinkDnsZones.defaultValue = Add-ZoneValues $audit.properties.parameters.privateLinkDnsZones.defaultValue $auditZones
Write-Artifact $auditPath $audit
$auditAssignmentPath = "policy_assignments\Audit-PeDnsZones.alz_policy_assignment.json"
$auditAssignment = Read-Artifact $auditAssignmentPath
$auditAssignment.properties.parameters.privateLinkDnsZones.value = Add-ZoneValues $auditAssignment.properties.parameters.privateLinkDnsZones.value $auditZones
Write-Artifact $auditAssignmentPath $auditAssignment

$rootPath = "archetype_definitions\root.alz_archetype_definition.json"
$root = Read-Artifact $rootPath
$root.policy_definitions = Add-ZoneValues $root.policy_definitions @($generic.name, $cognitive.name, $staticWebApps.name)
Write-Artifact $rootPath $root
