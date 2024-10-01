#!/usr/bin/pwsh

#
# PowerShell Script
# - Update template library in terraform-azurerm-caf-enterprise-scale repository
#

[CmdletBinding(SupportsShouldProcess)]
param (
  [Parameter()][String]$AlzToolsPath = "$PWD/enterprise-scale/src/Alz.Tools",
  [Parameter()][String]$TargetPath = "$PWD/library",
  [Parameter()][String]$SourcePath = "$PWD/enterprise-scale",
  [Parameter()][String]$LineEnding = "unix",
  [Parameter()][String]$ParserToolUrl = "https://github.com/Azure/arm-template-parser/releases/download/0.2.4"
)

$ErrorActionPreference = "Stop"

# This script relies on a custom set of classes and functions
# defined within the EnterpriseScaleLibraryTools PowerShell
# module.
Import-Module $AlzToolsPath -ErrorAction Stop

$parserPath = "$TargetPath/.github/scripts"
$parserExe = "Template.Parser.Cli"
if ($IsWindows) {
  $parserExe += ".exe"
}

$parser = "$parserPath/$parserExe"

if (!(Test-Path $parser)) {
  Write-Information "Downloading Template Parser." -InformationAction Continue
  if (!(Test-Path $parserPath)) {
    New-Item -Path $parserPath -ItemType Directory
  }
  Invoke-WebRequest "$ParserToolUrl/$parserExe" -OutFile $parser
  if ($IsLinux -Or $IsMacOS) {
    chmod +x $parser
  }
}

# Update the policy assignments if enabled
Write-Information "Updating Policy Assignment Archetypes." -InformationAction Continue

$eslzArmSourcePath = "$SourcePath/patterns/alz/alzArm.json"
$eslzArmParametersSourcePath = "$SourcePath/patterns/alz/eslzArm.terraform-sync.param.json"

$eslzArm = & $parser "-s $eslzArmSourcePath" "-f $eslzArmParametersSourcePath" "-a" | Out-String | ConvertFrom-Json

$policyAssignments = New-Object 'System.Collections.Generic.Dictionary[string,System.Collections.Generic.List[string]]'

foreach ($resource in $eslzArm) {
  $scope = $resource.scope
  $policyAssignment = $resource.properties.templateLink.uri

  if ($null -ne $policyAssignment -and $policyAssignment.StartsWith("https://deploymenturi/policyAssignments/") -and $resource.condition) {

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
  "sandboxes"      = "sandboxes"
  "identity"       = "identity"
  "platform"       = "platform"
}

$parameters = @{
  default   = @{
    nonComplianceMessagePlaceholder          = "{donotchange}"
    userAssignedManagedIdentityName = "id-amba-alz-prod-001"
    ALZMonitorResourceGroupName     = "rg-amba-alz-prod-001"
    ALZUserAssignedManagedIdentityName = "id-amba-alz-arg-reader-prod-001"
    ALZMonitorResourceGroupLocation = "eastus"
  }
  overrides = @{}
}

$finalPolicyAssignments = New-Object 'System.Collections.Generic.Dictionary[string,System.Collections.Generic.List[string]]'

$policyAssignmentSourcePath = "$SourcePath/patterns/alz/policyAssignments"
$policyAssignmentTargetPath = "$TargetPath/platform/amba-alz/policy_assignments"

foreach ($managementGroup in $policyAssignments.Keys) {
  $managementGroupNameFinal = $managementGroupMapping[$managementGroup.Replace("defaults-", "")]
  $managementGroupNameFinal
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

      # if (!(Get-Member -InputObject $parsedAssignment -Name "identity" -MemberType Properties)) {
      #     $parsedAssignment | Add-Member -MemberType NoteProperty -Name "identity" -Value @{ type = "None" }
      # }

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

      $targetPolicyAssignmentFileName = "$($policyAssignmentName.ToLower() -replace "-", "_").alz_policy_assignment.json"

      Write-Information "Writing $targetPolicyAssignmentFileName" -InformationAction Continue
      $json = $parsedAssignment | ConvertTo-Json -Depth 10
      $json | Edit-LineEndings -LineEnding $LineEnding | Out-File -FilePath "$policyAssignmentTargetPath/$targetPolicyAssignmentFileName" -Force

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

$archetypeTargetPath = "$TargetPath/platform/amba-alz/archetype_definitions"

foreach ($managementGroup in $finalPolicyAssignments.Keys) {
  $archetypeFilePath = "$archetypeTargetPath/$managementGroup.alz_archetype_definition.json"
  $archetypeJson = Get-Content $archetypeFilePath | ConvertFrom-Json

  $archetypeJson.policy_assignments = @($finalPolicyAssignments[$managementGroup] | Sort-Object)

  Write-Information "Writing $archetypeFilePath" -InformationAction Continue
  $json = $archetypeJson | ConvertTo-Json -Depth 10
  $json | Edit-LineEndings -LineEnding $LineEnding | Out-File -FilePath "$archetypeFilePath" -Force
}

$policySetDefinitions = Get-ChildItem -Path $TargetPath/platform/amba-alz/policy_set_definitions -Filter *.alz_policy_set_definition.json -Recurse

foreach ($policySetDefinition in $policySetDefinitions) {
  $policySetDefinitionJson = Get-Content $policySetDefinition.FullName -Raw | ConvertFrom-Json
  $policyAssignmentJson = Get-Content $policySetDefinition.FullName.Replace("policy_set_definitions", "policy_assignments").Replace("Alerting-","deploy_amba_").Replace("Notification-Assets","deploy_amba_notification").Replace(".alz_policy_set_definition.json", ".alz_policy_assignment.json").Replace("KeyManagement","keymgmt").Replace("LoadBalancing","loadbalance").Replace("NetworkChanges","networkchang").Replace("RecoveryServices","recoverysvc").Replace("ServiceHealth","svchealth") -Raw | ConvertFrom-Json

  $policySetDefinitionJson.properties.parameters = $policySetDefinitionJson.properties.parameters | Select-Object * -ExcludeProperty *WindowSize, *EvaluationFrequency, *AlertState, *AlertSeverity, *Threshold, *Frequency, *Severity, *AutoMitigate, *AutoResolve, *AutoResolveTime, *ComputersToInclude, *EvaluationPeriods, *FailingPeriods, *Operator, *TimeAggregation

  $newParameters = [ordered]@{}

  foreach ($param in $policySetDefinitionJson.properties.parameters.PSObject.Properties) {
    if ($parameters.default.ContainsKey($param.Name)) {
      $value = $parameters.default.$($param.Name)
    }
    else {
      $value = $param.Value.defaultValue
    }

    $newParameters.$($param.Name) = [PSCustomObject]@{
      value = $value
    }
  }

  $policyAssignmentJson.properties.parameters = $newParameters

  $policyAssignmentJson | ConvertTo-Json -Depth 100 | Set-Content ToLower($policySetDefinition.FullName.Replace("policy_set_definitions", "policy_assignments").Replace("Alerting-","deploy_amba_").Replace("Notification-Assets","deploy_amba_notification").Replace(".alz_policy_set_definition.json", ".alz_policy_assignment.json").Replace("KeyManagement","keymgmt").Replace("LoadBalancing","loadbalance").Replace("NetworkChanges","networkchang").Replace("RecoveryServices","recoverysvc").Replace("ServiceHealth","svchealth"))
}
