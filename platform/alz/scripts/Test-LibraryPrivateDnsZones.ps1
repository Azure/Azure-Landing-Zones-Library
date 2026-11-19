[CmdletBinding()]
param (
  [Parameter()][String]$TargetPath = (Split-Path $PSScriptRoot -Parent),
  [Parameter(Mandatory)][String]$ParserPath
)

$ErrorActionPreference = "Stop"
$TargetPath = (Resolve-Path -LiteralPath $TargetPath).Path
$ParserPath = (Resolve-Path -LiteralPath $ParserPath).Path
$testPath = Join-Path ([System.IO.Path]::GetTempPath()) "alz-private-dns-$([guid]::NewGuid())"
New-Item -ItemType Directory -Path $testPath | Out-Null

function Read-Artifact([String]$Path) {
  Get-Content -LiteralPath (Join-Path $TargetPath $Path) -Raw | ConvertFrom-Json -AsHashtable -Depth 100
}

function Assert-Equal($Actual, $Expected, [String]$Message) {
  if (($Actual | ConvertTo-Json -Depth 100 -Compress) -cne ($Expected | ConvertTo-Json -Depth 100 -Compress)) {
    throw $Message
  }
}

function Invoke-Template($Template, $Parameters) {
  $path = Join-Path $testPath "template.json"
  $Template | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath $path
  $arguments = @("-s $path", "-a")
  foreach ($parameter in $Parameters.Keys) {
    $arguments += "-p $parameter=$($Parameters[$parameter])"
  }
  $output = & $ParserPath @arguments | Out-String
  if ($LASTEXITCODE -ne 0) {
    throw "ARM template evaluation failed: $output"
  }
  $resources = @($output | ConvertFrom-Json -AsHashtable -Depth 100)
  if ($resources.Count -ne 1) {
    throw "Expected one DNS zone group, got $($resources.Count)."
  }
  return $resources[0]
}

try {
  $prefix = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/dns/providers/Microsoft.Network/privateDnsZones/"
  $cognitive = Read-Artifact "policy_definitions\Deploy-Private-DNS-CognitiveServices.alz_policy_definition.json"
  $static = Read-Artifact "policy_definitions\Deploy-Private-DNS-StaticWebApps.alz_policy_definition.json"
  $initiative = Read-Artifact "policy_set_definitions\Deploy-Private-DNS-Zones.alz_policy_set_definition.json"
  $root = Read-Artifact "archetype_definitions\root.alz_archetype_definition.json"

  $cognitiveReferences = @($initiative.properties.policyDefinitions | Where-Object { $_.policyDefinitionReferenceId -eq "DINE-Private-DNS-Azure-CognitiveServices" })
  if ($cognitiveReferences.Count -ne 1 -or $cognitiveReferences[0].policyDefinitionId -notlike "*/Deploy-Private-DNS-CognitiveServices") {
    throw "Cognitive Services, OpenAI and AI Services must share one custom policy, without the competing built-in reference."
  }
  foreach ($name in @("Deploy-Private-DNS-ZoneGroup", $cognitive.name, $static.name)) {
    if ($name -notin $root.policy_definitions) {
      throw "The root archetype must include $name."
    }
    $policy = Read-Artifact "policy_definitions\$name.alz_policy_definition.json"
    $connections = $policy.properties.policyRule.if.allOf[1].anyOf
    Assert-Equal @($connections | ForEach-Object { $_["count"].field }) @(
      "Microsoft.Network/privateEndpoints/privateLinkServiceConnections[*]",
      "Microsoft.Network/privateEndpoints/manualPrivateLinkServiceConnections[*]"
    ) "$name must evaluate automatic and manual connections independently."
    foreach ($connection in $connections) {
      if ($connection.count.where.allOf.Count -ne 2) {
        throw "$name must match both resource type and subresource within each connection."
      }
      foreach ($policy in @($cognitive, $static)) {
        if ($policy.properties.policyRule.then.details.Contains("existenceCondition")) {
          throw "$($policy.name) must preserve existing zone groups without guessing the target kind or partition."
        }
      }
    }
  }

  $parameters = @{
    location                   = "westus2"
    privateEndpointName        = "endpoint"
    privateLinkServiceId       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/app/providers/Microsoft.CognitiveServices/accounts/account"
    privateDnsZoneId           = "${prefix}privatelink.cognitiveservices.azure.com"
    openaiPrivateDnsZoneId     = "${prefix}privatelink.openai.azure.com"
    aiServicesPrivateDnsZoneId = "${prefix}privatelink.services.ai.azure.com"
  }
  $templateJson = $cognitive.properties.policyRule.then.details.deployment.properties.template | ConvertTo-Json -Depth 100
  $template = $templateJson.Replace("reference(parameters('privateLinkServiceId'), '2022-12-01', 'Full').kind", "parameters('testAccountKind')") | ConvertFrom-Json -AsHashtable -Depth 100
  $template.parameters.testAccountKind = @{ type = "string" }
  foreach ($kind in @("CognitiveServices", "SpeechServices", "OpenAI", "AIServices")) {
    $parameters.testAccountKind = $kind
    $resource = Invoke-Template $template $parameters
    $actual = @($resource.properties.privateDnsZoneConfigs | ForEach-Object { $_.properties.privateDnsZoneId } | Sort-Object)
    $expected = switch ($kind) {
      "OpenAI" { @($parameters.openaiPrivateDnsZoneId) }
      "AIServices" { @($parameters.privateDnsZoneId, $parameters.openaiPrivateDnsZoneId, $parameters.aiServicesPrivateDnsZoneId) }
      default { @($parameters.privateDnsZoneId) }
    }
    Assert-Equal $actual @($expected | Sort-Object) "Incorrect zone selection for Cognitive Services kind $kind."
  }
  Write-Output "PASS: ARM evaluation selects the correct zones for OpenAI, AI Services and existing Cognitive Services kinds."

  $templateJson = $static.properties.policyRule.then.details.deployment.properties.template | ConvertTo-Json -Depth 100
  $template = $templateJson.Replace("reference(parameters('privateLinkServiceId'), '2023-12-01').defaultHostname", "parameters('testDefaultHostname')") | ConvertFrom-Json -AsHashtable -Depth 100
  $template.parameters.testDefaultHostname = @{ type = "string" }
  $parameters = @{
    location             = "westus2"
    privateEndpointName  = "endpoint"
    privateLinkServiceId = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/app/providers/Microsoft.Web/staticSites/site"
    privateDnsZoneId     = "${prefix}privatelink.azurestaticapps.net"
  }
  foreach ($partition in @("", "1.", "2.", "3.", "4.", "5.", "7.")) {
    $parameters.testDefaultHostname = "example.${partition}azurestaticapps.net"
    $resource = Invoke-Template $template $parameters
    Assert-Equal $resource.properties.privateDnsZoneConfigs[0].properties.privateDnsZoneId "${prefix}privatelink.${partition}azurestaticapps.net" "Incorrect Static Web Apps zone selection for $($parameters.testDefaultHostname)."
  }
  $parameters.privateDnsZoneId = "${prefix}PRIVATELINK.AZURESTATICAPPS.NET"
  $resource = Invoke-Template $template $parameters
  Assert-Equal $resource.properties.privateDnsZoneConfigs[0].properties.privateDnsZoneId "${prefix}privatelink.7.azurestaticapps.net" "Static Web Apps partition selection must not depend on the input resource ID's casing."
  Write-Output "PASS: ARM evaluation selects unpartitioned, all five default partitions and a future Static Web Apps partition."

  $newParameters = [ordered]@{
    azureApiManagementPrivateDnsZoneId = "privatelink.azure-api.net"
    azureStaticWebAppsPrivateDnsZoneId = "privatelink.azurestaticapps.net"
    azureOpenAIPrivateDnsZoneId        = "privatelink.openai.azure.com"
    azureAIServicesPrivateDnsZoneId    = "privatelink.services.ai.azure.com"
    azureSQLPrivateDnsZoneId           = "privatelink.database.windows.net"
    azureMySQLPrivateDnsZoneId         = "privatelink.mysql.database.azure.com"
  }
  foreach ($parameter in $newParameters.Keys) {
    $binding = @($initiative.properties.policyDefinitions.parameters.Values | Where-Object { $_.value -like "*parameters('$parameter')*" })
    if ($binding.Count -ne 1) {
      throw "$parameter must be bound to exactly one deployment policy."
    }
    $template = @{
      '$schema'      = "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#"
      contentVersion = "1.0.0.0"
      parameters     = @{
        dnsZoneSubscriptionId    = @{ type = "string"; defaultValue = "" }
        dnsZoneResourceGroupName = @{ type = "string"; defaultValue = "Central-DNS" }
        dnsZoneResourceType      = @{ type = "string"; defaultValue = "Microsoft.Network/privateDnsZones" }
        dnsZoneNames             = @{ type = "object"; defaultValue = $initiative.properties.parameters.dnsZoneNames.defaultValue }
        $parameter               = @{ type = "string"; defaultValue = "${prefix}custom-zone" }
      }
      resources      = @(@{
        type       = "Microsoft.Network/privateEndpoints/privateDnsZoneGroups"
        apiVersion = "2020-03-01"
        name       = "endpoint/deployedByPolicy"
        properties = @{ privateDnsZoneId = $binding[0].value }
      })
    }
    $resource = Invoke-Template $template @{}
    Assert-Equal $resource.properties.privateDnsZoneId "${prefix}custom-zone" "$parameter must retain the explicitly supplied zone ID."
    $resource = Invoke-Template $template @{ dnsZoneSubscriptionId = "00000000-0000-0000-0000-000000000000" }
    $zone = $newParameters[$parameter]
    Assert-Equal $resource.properties.privateDnsZoneId "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/central-dns/providers/Microsoft.Network/privateDnsZones/$zone" "$parameter must resolve the central DNS zone without requiring a region."
  }
  Write-Output "PASS: all six new parameters support both explicit IDs and centrally constructed IDs."

  $audit = Read-Artifact "policy_definitions\Audit-PrivateLinkDnsZones.alz_policy_definition.json"
  $assignment = Read-Artifact "policy_assignments\Audit-PeDnsZones.alz_policy_assignment.json"
  $requiredZones = @($newParameters.Values) + @(1..5 | ForEach-Object { "privatelink.$_.azurestaticapps.net" })
  foreach ($zone in $requiredZones) {
    if ($zone -notin $audit.properties.parameters.privateLinkDnsZones.defaultValue -or $zone -notin $assignment.properties.parameters.privateLinkDnsZones.value) {
      throw "Both the audit definition and its explicit assignment override must cover $zone."
    }
  }
  Write-Output "PASS: the audit definition and assignment both cover every selected zone."

  $refreshPath = Join-Path $testPath "refresh"
  New-Item -ItemType Directory -Path $refreshPath | Out-Null
  $inputs = @(
    "policy_definitions\Deploy-Private-DNS-Generic.alz_policy_definition.json",
    "policy_definitions\Audit-PrivateLinkDnsZones.alz_policy_definition.json",
    "policy_set_definitions\Deploy-Private-DNS-Zones.alz_policy_set_definition.json",
    "policy_assignments\Deploy-Private-DNS-Zones.alz_policy_assignment.json",
    "policy_assignments\Audit-PeDnsZones.alz_policy_assignment.json",
    "archetype_definitions\root.alz_archetype_definition.json"
  )
  foreach ($path in $inputs) {
    $destination = Join-Path $refreshPath $path
    New-Item -ItemType Directory -Path (Split-Path $destination -Parent) -Force | Out-Null
    Copy-Item -LiteralPath (Join-Path $TargetPath $path) -Destination $destination
  }
  $initiative.properties.policyDefinitions = @($initiative.properties.policyDefinitions | Where-Object {
    $_.policyDefinitionId -notmatch "/Deploy-Private-DNS-(ZoneGroup|CognitiveServices|StaticWebApps)$"
  })
  $initiative.properties.policyDefinitions += @{
    policyDefinitionReferenceId = "DINE-Private-DNS-Azure-CognitiveServices"
    policyDefinitionId          = "/providers/Microsoft.Authorization/policyDefinitions/c4bc6f10-cb41-49eb-b000-d5ab82e2a091"
    parameters                  = @{}
  }
  foreach ($parameter in $newParameters.Keys) {
    $initiative.properties.parameters.Remove($parameter)
    $initiative.properties.parameters.dnsZoneNames.defaultValue.Remove($parameter)
  }
  $initiative.properties.metadata.version = "9.0.0"
  $initiative | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath (Join-Path $refreshPath $inputs[2])
  $root.policy_definitions = @($root.policy_definitions | Where-Object { $_ -notmatch "^Deploy-Private-DNS-(ZoneGroup|CognitiveServices|StaticWebApps)$" })
  $root | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath (Join-Path $refreshPath $inputs[5])
  $audit.properties.parameters.privateLinkDnsZones.defaultValue = @($audit.properties.parameters.privateLinkDnsZones.defaultValue | Where-Object { $_ -notmatch "^privatelink\.[1-5]\.azurestaticapps\.net$|^privatelink\.(openai|services\.ai)\.azure\.com$" }) + @("privatelink.future.example")
  $audit | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath (Join-Path $refreshPath $inputs[1])
  $assignment.properties.parameters.privateLinkDnsZones.value = @($audit.properties.parameters.privateLinkDnsZones.defaultValue)
  $assignment | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath (Join-Path $refreshPath $inputs[4])
  $deploymentAssignment = Read-Artifact $inputs[3]
  foreach ($parameter in $newParameters.Keys) {
    $deploymentAssignment.properties.parameters.Remove($parameter)
  }
  $deploymentAssignment | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath (Join-Path $refreshPath $inputs[3])
  $generator = Join-Path $PSScriptRoot "Update-LibraryPrivateDnsZones.ps1"
  & $generator -TargetPath $refreshPath
  $refreshed = Get-Content -LiteralPath (Join-Path $refreshPath $inputs[2]) -Raw | ConvertFrom-Json -AsHashtable -Depth 100
  Assert-Equal $refreshed.properties.metadata.version "9.0.0" "Refresh must not downgrade future upstream initiative versions."
  foreach ($parameter in $newParameters.Keys) {
    Assert-Equal $refreshed.properties.parameters.dnsZoneNames.defaultValue[$parameter] $newParameters[$parameter] "Refresh must restore $parameter after a reset."
  }
  $cognitiveReferences = @($refreshed.properties.policyDefinitions | Where-Object { $_.policyDefinitionReferenceId -eq "DINE-Private-DNS-Azure-CognitiveServices" })
  if ($cognitiveReferences.Count -ne 1 -or $cognitiveReferences[0].policyDefinitionId -notlike "*/Deploy-Private-DNS-CognitiveServices") {
    throw "Refresh must replace, not duplicate, the upstream Cognitive Services reference."
  }
  $refreshedAssignment = Get-Content -LiteralPath (Join-Path $refreshPath $inputs[3]) -Raw | ConvertFrom-Json -AsHashtable -Depth 100
  foreach ($parameter in $newParameters.Keys) {
    if ($refreshedAssignment.properties.parameters[$parameter].value -notlike "*/$($newParameters[$parameter])") {
      throw "Refresh must restore the deployment assignment parameter $parameter."
    }
  }
  $refreshed = Get-Content -LiteralPath (Join-Path $refreshPath $inputs[1]) -Raw | ConvertFrom-Json -AsHashtable -Depth 100
  $refreshedAssignment = Get-Content -LiteralPath (Join-Path $refreshPath $inputs[4]) -Raw | ConvertFrom-Json -AsHashtable -Depth 100
  foreach ($zone in @($requiredZones) + @("privatelink.future.example")) {
    if ($zone -notin $refreshed.properties.parameters.privateLinkDnsZones.defaultValue -or $zone -notin $refreshedAssignment.properties.parameters.privateLinkDnsZones.value) {
      throw "Refresh must restore selected zones and preserve upstream additions: missing $zone."
    }
  }
  $firstRun = @{}
  Get-ChildItem -LiteralPath $refreshPath -Recurse -File | ForEach-Object { $firstRun[$_.FullName] = (Get-FileHash -LiteralPath $_.FullName).Hash }
  & $generator -TargetPath $refreshPath
  Get-ChildItem -LiteralPath $refreshPath -Recurse -File | ForEach-Object {
    Assert-Equal (Get-FileHash -LiteralPath $_.FullName).Hash $firstRun[$_.FullName] "Repeated DNS refresh must not change $($_.Name)."
  }
  Write-Output "PASS: refresh restores curated coverage after reset, preserves upstream additions and versions, and is idempotent."
}
finally {
  Remove-Item -LiteralPath $testPath -Recurse -Force
}
