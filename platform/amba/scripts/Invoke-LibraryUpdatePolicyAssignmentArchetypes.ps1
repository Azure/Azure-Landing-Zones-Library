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
    nonComplianceMessagePlaceholder    = "{donotchange}"
    topLevelManagementGroupPrefix      = "`${temp}"
    userAssignedManagedIdentityName    = "id-amba-alz-prod-001"
    ALZMonitorResourceGroupName        = "rg-amba-alz-prod-001"
    ALZUserAssignedManagedIdentityName = "id-amba-alz-arg-reader-prod-001"
    ALZMonitorResourceGroupLocation    = "eastus"
    ALZMonitorDisableTagName           = "MonitorDisable"
  }
  overrides = @{}
}

$finalPolicyAssignments = New-Object 'System.Collections.Generic.Dictionary[string,System.Collections.Generic.List[string]]'

$policyAssignmentSourcePath = "$SourcePath/patterns/alz/policyAssignments"
$policyAssignmentTargetPath = "$TargetPath/platform/amba/policy_assignments"

# Remove any pre-existing policy assignment files before regenerating. This
# prevents stale files (e.g. legacy PascalCase filenames) from coexisting with
# the freshly generated snake_case files that share the same assignment name,
# which would otherwise cause a duplicate assignment name error in alzlib.
if (Test-Path $policyAssignmentTargetPath) {
  Get-ChildItem -Path $policyAssignmentTargetPath -Filter "*.alz_policy_assignment.json" -File | Remove-Item -Force
}

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

      # Ensure the policy assignment has a top-level "location", defaulting to the
      # templated "${default_location}" placeholder when the source template does
      # not specify one. The placeholder is substituted with the consumer's target
      # region at deployment time, so the library must not hardcode a region here.
      #
      # The location is (re)positioned immediately after the "name" property to
      # match the library's curated convention. We rebuild the assignment as an
      # ordered dictionary because Add-Member only appends, which would place
      # "location" at the end and create noisy property-order diffs against the
      # existing curated assignments.
      $existingLocation = $null
      if (Get-Member -InputObject $parsedAssignment -Name "location" -MemberType Properties) {
        $existingLocation = $parsedAssignment.location
      }
      $assignmentLocation = if ([string]::IsNullOrEmpty($existingLocation)) { '${default_location}' } else { $existingLocation }

      $orderedAssignment = [ordered]@{}
      foreach ($assignmentProperty in $parsedAssignment.PSObject.Properties) {
        if ($assignmentProperty.Name -eq "location") {
          continue
        }
        $orderedAssignment[$assignmentProperty.Name] = $assignmentProperty.Value
        if ($assignmentProperty.Name -eq "name") {
          $orderedAssignment["location"] = $assignmentLocation
        }
      }
      if (!($orderedAssignment.Contains("location"))) {
        $orderedAssignment["location"] = $assignmentLocation
      }
      $parsedAssignment = [PSCustomObject]$orderedAssignment

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

      $targetPolicyAssignmentFileName = "$($policyAssignmentName.ToLower() -replace "-", "_" -replace "ambaconnectivity2", "amba_connectivity2").alz_policy_assignment.json"

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

$archetypeTargetPath = "$TargetPath/platform/amba/archetype_definitions"

foreach ($managementGroup in $finalPolicyAssignments.Keys) {
  $archetypeFilePath = "$archetypeTargetPath/$managementGroup.alz_archetype_definition.json"
  if (!(Test-Path $archetypeFilePath)) {
    $ambaArchetypeFilePath = "$archetypeTargetPath/amba_$managementGroup.alz_archetype_definition.json"
    if (Test-Path $ambaArchetypeFilePath) {
      $archetypeFilePath = $ambaArchetypeFilePath
    }
    else {
      throw "Could not find archetype definition file for management group '$managementGroup'. Checked '$archetypeFilePath' and '$ambaArchetypeFilePath'."
    }
  }

  $archetypeJson = Get-Content $archetypeFilePath | ConvertFrom-Json

  $archetypeJson.policy_assignments = @($finalPolicyAssignments[$managementGroup] | Sort-Object)

  Write-Information "Writing $archetypeFilePath" -InformationAction Continue
  $json = $archetypeJson | ConvertTo-Json -Depth 10
  $json | Edit-LineEndings -LineEnding $LineEnding | Out-File -FilePath "$archetypeFilePath" -Force
}

$policySetDefinitions = Get-ChildItem -Path "$TargetPath/platform/amba/policy_set_definitions" -Filter *.alz_policy_set_definition.json -Recurse

foreach ($policySetDefinition in $policySetDefinitions) {
  $policySetDefinitionJson = Get-Content $policySetDefinition.FullName -Raw | ConvertFrom-Json

  if ((Get-Member -InputObject $policySetDefinitionJson -Name "properties" -MemberType NoteProperty) -and
    (Get-Member -InputObject $policySetDefinitionJson.properties -Name "metadata" -MemberType NoteProperty) -and
    (Get-Member -InputObject $policySetDefinitionJson.properties.metadata -Name "supersededBy" -MemberType NoteProperty) -and
    $policySetDefinitionJson.properties.metadata.supersededBy) {
    Write-Information "Skipping superseded policy set definition '$($policySetDefinitionJson.name)' (superseded by '$($policySetDefinitionJson.properties.metadata.supersededBy)')." -InformationAction Continue
    continue
  }

  $policyAssignmentPath = $policySetDefinition.FullName.Replace("policy_set_definitions", "policy_assignments").Replace("Alerting-", "deploy_amba_").Replace("Notification-Assets", "deploy_amba_notification").Replace(".alz_policy_set_definition.json", ".alz_policy_assignment.json").Replace("KeyManagement", "keymgmt").Replace("LoadBalancing", "loadbalance").Replace("NetworkChanges", "networkchang").Replace("RecoveryServices", "recoverysvc").Replace("ResourceAndServiceHealth", "res_svchlth").Replace("ServiceHealth", "svchealth").Replace("Connectivity", "connectivity").Replace("Identity", "identity").Replace("Storage", "storage").Replace("Management", "management").Replace("Web", "web").Replace("VMSS", "vmss").Replace("VM", "vm").Replace("HybridVM", "hybridvm").Replace("Hybridvm", "hybridvm").Replace("connectivity-2", "connectivity2")
  $policyAssignmentJson = Get-Content $policyAssignmentPath -Raw | ConvertFrom-Json

  $policySetDefinitionJson.properties.parameters = $policySetDefinitionJson.properties.parameters | Select-Object * -ExcludeProperty *WindowSize, *EvaluationFrequency, *AlertState, *AlertSeverity, *Threshold, *Frequency, *Severity, *AutoMitigate, *AutoResolve, *AutoResolveTime, *ComputersToInclude, *EvaluationPeriods, *FailingPeriods, *Operator, *TimeAggregation, *AlertSensitivity

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

  $policyAssignmentJson | ConvertTo-Json -Depth 100 | Set-Content $policyAssignmentPath
}
