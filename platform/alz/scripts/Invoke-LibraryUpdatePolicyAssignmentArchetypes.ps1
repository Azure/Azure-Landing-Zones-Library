#!/usr/bin/pwsh

#
# PowerShell Script
# - Update template library in terraform-azurerm-caf-enterprise-scale repository
#

[CmdletBinding(SupportsShouldProcess)]
param (
  [Parameter()][String]$TargetPath = "$PWD/library",
  [Parameter()][String]$SourcePath = "$PWD/enterprise-scale",
  [Parameter()][String]$LineEnding = "unix",
  [Parameter()][String]$ParserToolUrl = "https://github.com/Azure/arm-template-parser/releases/download/0.2.4"
)

$assignmentsToSkip = @(
  "Deploy-Log-Analytics"
)

$ErrorActionPreference = "Stop"

$parserPath = "$TargetPath/platform/alz/scripts"
$parserExe = "Template.Parser.Cli"
if ($IsWindows) {
  $parserExe += ".exe"
}

$parser = "$parserPath/$parserExe"

if (!(Test-Path $parser)) {
  Write-Information "Downloading Template Parser." -InformationAction Continue
  Invoke-WebRequest "$ParserToolUrl/$parserExe" -OutFile $parser
  if ($IsLinux -Or $IsMacOS) {
    chmod +x $parser
  }
}

# Update the policy assignments if enabled
Write-Information "Updating Policy Assignment Archetypes." -InformationAction Continue

$eslzArmSourcePath = "$SourcePath/eslzArm/eslzArm.json"
$eslzArmParametersSourcePath = "$SourcePath/eslzArm/eslzArm.terraform-sync.param.json"

$eslzArm = & $parser "-s $eslzArmSourcePath" "-f $eslzArmParametersSourcePath" "-a" | Out-String | ConvertFrom-Json

$policyAssignments = New-Object 'System.Collections.Generic.Dictionary[string,System.Collections.Generic.List[string]]'

foreach ($resource in $eslzArm) {
  $scope = $resource.scope
  $policyAssignment = $resource.properties.templateLink.uri

  if ($null -ne $policyAssignment -and $policyAssignment.StartsWith("https://deploymenturi/managementGroupTemplates/policyAssignments/") -and $resource.condition) {
    $managementGroup = $scope.Split("/")[-1]
    $policyAssignmentFileName = $policyAssignment.Split("/")[-1]

    if (!($policyAssignmentFileName.StartsWith("fairfax"))) {
      if (!($policyAssignments.ContainsKey($managementGroup))) {
        $values = New-Object 'System.Collections.Generic.List[string]'
        $values.Add($policyAssignmentFileName)
        $policyAssignments.Add($managementGroup, $values)
      }
      else {
        $policyAssignments[$managementGroup].Add($policyAssignmentFileName)
      }
    }
  }
}

$managementGroupMapping = @{
  "defaults"       = "root"
  "management"     = "management"
  "connectivity"   = "connectivity"
  "corp"           = "corp"
  "landingzones"   = "landing_zones"
  "decommissioned" = "decommissioned"
  "sandboxes"      = "sandbox"
  "identity"       = "identity"
  "platform"       = "platform"
}

$logAnalyticsWorkspaceIdPlaceholder = "/subscriptions/00000000-0000-0000-0000-000000000000/resourcegroups/placeholder/providers/Microsoft.OperationalInsights/workspaces/placeholder-la"

$parameters = @{
  default   = @{
    nonComplianceMessagePlaceholder          = "{donotchange}"
    logAnalyticsWorkspaceName                = "placeholder-la"
    automationAccountName                    = "placeholder-automation"
    workspaceRegion                          = "northeurope"
    automationRegion                         = "northeurope"
    retentionInDays                          = "30"
    rgName                                   = "`${root_scope_id}-mgmt"
    logAnalyticsResourceId                   = "$logAnalyticsWorkspaceIdPlaceholder"
    topLevelManagementGroupPrefix            = "`${temp}"
    dnsZoneResourceGroupId                   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/placeholder/providers/Microsoft.Network/privateDnsZones/"
    ddosPlanResourceId                       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/placeholder/providers/Microsoft.Network/ddosProtectionPlans/placeholder"
    emailContactAsc                          = "security_contact@replace_me"
    location                                 = "northeurope"
    listOfResourceTypesDisallowedForDeletion = "[[[Array]]]"
    userWorkspaceResourceId                  = "$logAnalyticsWorkspaceIdPlaceholder"
    userAssignedIdentityResourceId           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/placeholder/providers/Microsoft.ManagedIdentity/userAssignedIdentities/placeholder"
    dcrResourceId                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/placeholder/providers/Microsoft.Insights/dataCollectionRules/placeholder"
    dataCollectionRuleResourceId             = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/placeholder/providers/Microsoft.Insights/dataCollectionRules/placeholder"
    resourceType                             = "Microsoft.ManagedIdentity/userAssignedIdentities"
  }
  overrides = @{
    sql_data_collection_rule_overrides             = @{
      policy_assignments = @(
        "DINE-MDFCDefenderSQLAMAPolicyAssignment.json"
      )
      parameters         = @{
        dcrResourceId                = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/placeholder/providers/Microsoft.Insights/dataCollectionRules/placeholder"
        dataCollectionRuleResourceId = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/placeholder/providers/Microsoft.Insights/dataCollectionRules/placeholder"
      }
    }
    vm_insights_data_collection_rule_overrides     = @{
      policy_assignments = @(
        "DINE-VMHybridMonitoringPolicyAssignment.json",
        "DINE-VMMonitoringPolicyAssignment.json",
        "DINE-VMSSMonitoringPolicyAssignment.json"
      )
      parameters         = @{
        dcrResourceId                = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/placeholder/providers/Microsoft.Insights/dataCollectionRules/placeholder"
        dataCollectionRuleResourceId = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/placeholder/providers/Microsoft.Insights/dataCollectionRules/placeholder"
      }
    }
    change_tracking_data_collection_rule_overrides = @{
      policy_assignments = @(
        "DINE-ChangeTrackingVMArcPolicyAssignment.json",
        "DINE-ChangeTrackingVMPolicyAssignment.json",
        "DINE-ChangeTrackingVMSSPolicyAssignment.json"
      )
      parameters         = @{
        dcrResourceId                = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/placeholder/providers/Microsoft.Insights/dataCollectionRules/placeholder"
        dataCollectionRuleResourceId = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/placeholder/providers/Microsoft.Insights/dataCollectionRules/placeholder"
      }
    }
  }
}

$finalPolicyAssignments = New-Object 'System.Collections.Generic.Dictionary[string,System.Collections.Generic.List[string]]'

$policyAssignmentSourcePath = "$SourcePath/eslzArm/managementGroupTemplates/policyAssignments"
$policyAssignmentTargetPath = "$TargetPath/platform/alz/policy_assignments"

foreach ($managementGroup in $policyAssignments.Keys) {
  $managementGroupNameFinal = $managementGroupMapping[$managementGroup.Replace("defaults-", "")]
  Write-Output "`nProcessing Archetype Policy Assignments for Management Group: $managementGroupNameFinal"

  foreach ($policyAssignmentFile in $policyAssignments[$managementGroup]) {
    Write-Output "`nProcessing Archetype Policy Assignment: $managementGroupNameFinal - $policyAssignmentFile"

    $defaultParameters = $parameters.default
    foreach ($overrideKey in $parameters.overrides.Keys) {
      if ($policyAssignmentFile -in $parameters.overrides[$overrideKey].policy_assignments) {
        foreach ($parameter in $parameters.overrides[$overrideKey].parameters.Keys) {
          $defaultParameters.$parameter = $parameters.overrides[$overrideKey].parameters.$parameter
        }
      }
    }

    $defaultParameterFormatted = $defaultParameters.GetEnumerator().ForEach({ "-p $($_.Name)=$($_.Value)" })

    $parsedAssignmentArray = & $parser "-s $policyAssignmentSourcePath/$policyAssignmentFile" $defaultParameterFormatted "-a" | Out-String | ConvertFrom-Json

    foreach ($parsedAssignment in $parsedAssignmentArray) {
      if ($parsedAssignment.type -ne "Microsoft.Authorization/policyAssignments") {
        continue
      }

      $policyAssignmentName = $parsedAssignment.name

      if ($assignmentsToSkip.Contains($policyAssignmentName)) {
        continue
      }

      Write-Output "Parsed Assignment Name: $($parsedAssignment.name)"

      if (!(Get-Member -InputObject $parsedAssignment.properties -Name "scope" -MemberType Properties)) {
        $parsedAssignment.properties | Add-Member -MemberType NoteProperty -Name "scope" -Value "/providers/Microsoft.Management/managementGroups/placeholder"
      }

      if (!(Get-Member -InputObject $parsedAssignment.properties -Name "notScopes" -MemberType Properties)) {
        $parsedAssignment.properties | Add-Member -MemberType NoteProperty -Name "notScopes" -Value @()
      }

      if (!(Get-Member -InputObject $parsedAssignment.properties -Name "parameters" -MemberType Properties)) {
        $parsedAssignment.properties | Add-Member -MemberType NoteProperty -Name "parameters" -Value @{}
      }

      if (!(Get-Member -InputObject $parsedAssignment -Name "location" -MemberType Properties)) {
        $parsedAssignment | Add-Member -MemberType NoteProperty -Name "location" -Value "uksouth"
      }

      if ($parsedAssignment.properties.policyDefinitionId.StartsWith("/providers/Microsoft.Management/managementGroups/`${temp}")) {
        $parsedAssignment.properties.policyDefinitionId = $parsedAssignment.properties.policyDefinitionId.Replace("/providers/Microsoft.Management/managementGroups/`${temp}", "/providers/Microsoft.Management/managementGroups/placeholder")
      }

      foreach ($property in Get-Member -InputObject $parsedAssignment.properties.parameters -MemberType NoteProperty) {
        $propertyName = $property.Name
        Write-Verbose "Checking Parameter: $propertyName"
        if ($parsedAssignment.properties.parameters.($propertyName).value.GetType() -ne [System.String]) {
          Write-Verbose "Skipping non-string parameter: $propertyName"
          continue
        }

        if ($parsedAssignment.properties.parameters.($propertyName).value.StartsWith("`${private_dns_zone_prefix}/providers/Microsoft.Network/privateDnsZones/")) {
          $parsedAssignment.properties.parameters.($propertyName).value = $parsedAssignment.properties.parameters.($propertyName).value.Replace("`${private_dns_zone_prefix}/providers/Microsoft.Network/privateDnsZones/", "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/placeholder/providers/Microsoft.Network/privateDnsZones/")
          # $parsedAssignment.properties.parameters.($propertyName).value = $parsedAssignment.properties.parameters.($propertyName).value.Replace("privatelink.uks.backup.windowsazure.com", "privatelink.`${connectivity_location_short}.backup.windowsazure.com")
        }
        if ($parsedAssignment.properties.parameters.($propertyName).value.StartsWith("`${temp}")) {
          $parsedAssignment.properties.parameters.($propertyName).value = $parsedAssignment.properties.parameters.($propertyName).value.Replace("`${temp}", "/providers/Microsoft.Management/managementGroups/placeholder")
        }
      }

      $targetPolicyAssignmentFileName = $policyAssignmentName + ".alz_policy_assignment.json"

      Write-Information "Writing $targetPolicyAssignmentFileName" -InformationAction Continue
      $json = $parsedAssignment | ConvertTo-Json -Depth 10
      $json | Out-File -FilePath "$policyAssignmentTargetPath/$targetPolicyAssignmentFileName" -Force

      Write-Verbose "Got final data for $managementGroupNameFinal and $policyAssignmentName"

      if (!($finalPolicyAssignments.ContainsKey($managementGroupNameFinal))) {
        $values = New-Object 'System.Collections.Generic.List[string]'
        $values.Add($policyAssignmentName)
        $finalPolicyAssignments.Add($managementGroupNameFinal, $values)
      }
      else {
        $finalPolicyAssignments[$managementGroupNameFinal].Add($policyAssignmentName)
      }
    }
  }
}

$archetypeTargetPath = "$TargetPath/platform/alz/archetype_definitions"

foreach ($managementGroup in $finalPolicyAssignments.Keys) {
  $archetypeFilePath = "$archetypeTargetPath/$managementGroup.alz_archetype_definition.json"
  $archetypeJson = Get-Content $archetypeFilePath | ConvertFrom-Json

  $archetypeJson.policy_assignments = @($finalPolicyAssignments[$managementGroup] | Sort-Object)

  Write-Information "Writing $archetypeFilePath" -InformationAction Continue
  $json = $archetypeJson | ConvertTo-Json -Depth 10
  $json | Out-File -FilePath "$archetypeFilePath" -Force
}
