#!/usr/bin/pwsh

#
# PowerShell Script
# - Update template library in terraform-azurerm-caf-enterprise-scale repository
#

[CmdletBinding(SupportsShouldProcess)]
param (
  [Parameter()][String]$AlzToolsPath = "$PWD/enterprise-scale/src/Alz.Tools",
  [Parameter()][String]$TargetPath = "$PWD/alzlib",
  [Parameter()][String]$SourcePath = "$PWD/enterprise-scale",
  [Parameter()][String]$LineEnding = "unix",
  [Parameter()][String]$ParserToolUrl = "https://github.com/jaredfholgate/template-parser/releases/download/0.1.18"
)

$ErrorActionPreference = "Stop"

# This script relies on a custom set of classes and functions
# defined within the EnterpriseScaleLibraryTools PowerShell
# module.
Import-Module $AlzToolsPath -ErrorAction Stop

$parserPath = "$TargetPath/.temp/scripts"
$parserExe = "Template.Parser.Cli"
if ($IsWindows) {
  $parserExe += ".exe"
}

$parser = "$parserPath/$parserExe"

if (!(Test-Path $parser)) {
  Write-Information "Downloading Template Parser." -InformationAction Continue
  New-Item -ItemType Directory -Path $parserPath -Force | Out-Null
  Invoke-WebRequest "$ParserToolUrl/$parserExe" -OutFile $parser
  if (! $IsWindows) {
    $isExecutable = $(test -x "$parser"; 0 -eq $LASTEXITCODE)
    if (!($isExecutable)) {
      chmod +x $parser
    }
  }
}

# Update the policy assignments if enabled
Write-Information "Updating Policy Assignments." -InformationAction Continue
$policyAssignmentSourcePath = "$SourcePath/eslzArm/managementGroupTemplates/policyAssignments"
$policyAssignmentTargetPath = "$TargetPath/policy_assignments"
$sourcePolicyAssignmentFiles = Get-ChildItem -Path $policyAssignmentSourcePath -File
$targetPolicyAssignmentFiles = Get-ChildItem -Path $policyAssignmentTargetPath -File

# $temporaryNameMatches = @{
#   "Deny-IP-forwarding"  = "Deny-IP-Forwarding"
#   "Deny-Priv-Esc-AKS"   = "Deny-Priv-Containers-AKS"
#   "Deny-Privileged-AKS" = "Deny-Priv-Escalation-AKS"
# }

$defaultParameterValues = @(
  "-p nonComplianceMessagePlaceholder={donotchange}"
  "-p logAnalyticsWorkspaceName=placeholder",
  "-p automationAccountName=placeholder",
  "-p workspaceRegion=placeholder",
  "-p automationRegion=placeholder",
  "-p retentionInDays=30",
  "-p rgName=placeholder",
  "-p logAnalyticsResourceId=/subscriptions/00000000-0000-0000-0000-000000000000/resourcegroups/placeholder/providers/Microsoft.OperationalInsights/workspaces/placeholder",
  "-p topLevelManagementGroupPrefix=alz",
  "-p dnsZoneResourceGroupId=placeholder",
  "-p ddosPlanResourceId=/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/placeholder/providers/Microsoft.Network/ddosProtectionPlans/placeholder",
  "-p emailContactAsc=security_contact@replace_me"
)

$parsedAssignments = @{}
foreach ($sourcePolicyAssignmentFile in $sourcePolicyAssignmentFiles) {
  $parsedAssignment = & $parser "-s $sourcePolicyAssignmentFile" $defaultParameterValues | Out-String | ConvertFrom-Json
  $parsedAssignments[$parsedAssignment.name] = @{
    json = $parsedAssignment
    file = $sourcePolicyAssignmentFile
  }
  # if (!(Get-Member -InputObject $parsedAssignments[$parsedAssignment.name].json.properties -Name "scope" -MemberType Properties)) {
  #   $parsedAssignments[$parsedAssignment.name].json.properties | Add-Member -MemberType NoteProperty -Name "scope" -Value "`${current_scope_resource_id}"
  # }

  if (!(Get-Member -InputObject $parsedAssignments[$parsedAssignment.name].json.properties -Name "notScopes" -MemberType Properties)) {
    $parsedAssignments[$parsedAssignment.name].json.properties | Add-Member -MemberType NoteProperty -Name "notScopes" -Value @()
  }

  if (!(Get-Member -InputObject $parsedAssignments[$parsedAssignment.name].json.properties -Name "parameters" -MemberType Properties)) {
    $parsedAssignments[$parsedAssignment.name].json.properties | Add-Member -MemberType NoteProperty -Name "parameters" -Value @{}
  }

  # if (!(Get-Member -InputObject $parsedAssignments[$parsedAssignment.name].json -Name "location" -MemberType Properties)) {
  #   $parsedAssignments[$parsedAssignment.name].json | Add-Member -MemberType NoteProperty -Name "location" -Value "`${default_location}"
  # }

  if (!(Get-Member -InputObject $parsedAssignments[$parsedAssignment.name].json -Name "identity" -MemberType Properties)) {
    $parsedAssignments[$parsedAssignment.name].json | Add-Member -MemberType NoteProperty -Name "identity" -Value @{ type = "None" }
  }

  # if ($parsedAssignments[$parsedAssignment.name].json.properties.policyDefinitionId.StartsWith("/providers/Microsoft.Management/managementGroups/`${temp}")) {
  #   $parsedAssignments[$parsedAssignment.name].json.properties.policyDefinitionId = $parsedAssignments[$parsedAssignment.name].json.properties.policyDefinitionId.Replace("/providers/Microsoft.Management/managementGroups/`${temp}", "`/providers/Microsoft.Management/managementGroups/PLACEHOLDER")
  # }

  # foreach ($property in Get-Member -InputObject $parsedAssignments[$parsedAssignment.name].json.properties.parameters -MemberType NoteProperty) {
  #   $propertyName = $property.Name
  #   if ($parsedAssignments[$parsedAssignment.name].json.properties.parameters.($propertyName).value.StartsWith("`${private_dns_zone_prefix}/providers/Microsoft.Network/privateDnsZones/")) {
  #     $parsedAssignments[$parsedAssignment.name].json.properties.parameters.($propertyName).value = $parsedAssignments[$parsedAssignment.name].json.properties.parameters.($propertyName).value.Replace("`${private_dns_zone_prefix}/providers/Microsoft.Network/privateDnsZones/", "`${private_dns_zone_prefix}")
  #     $parsedAssignments[$parsedAssignment.name].json.properties.parameters.($propertyName).value = $parsedAssignments[$parsedAssignment.name].json.properties.parameters.($propertyName).value.Replace("privatelink.batch.azure.com", "privatelink.`${connectivity_location}.batch.azure.com")
  #   }
  #   if ($parsedAssignments[$parsedAssignment.name].json.properties.parameters.($propertyName).value.StartsWith("`${temp}")) {
  #     $parsedAssignments[$parsedAssignment.name].json.properties.parameters.($propertyName).value = $parsedAssignments[$parsedAssignment.name].json.properties.parameters.($propertyName).value.Replace("`${temp}", "`${root_scope_id}")
  #   }
  # }
}

$originalAssignments = @{}
foreach ($targetPolicyAssignmentFile in $targetPolicyAssignmentFiles) {
  $originalAssignment = Get-Content $targetPolicyAssignmentFile | ConvertFrom-Json
  $originalAssignments[$originalAssignment.name] = @{
    json = $originalAssignment
    file = $targetPolicyAssignmentFile
  }
}

foreach ($key in $parsedAssignments.Keys | Sort-Object) {
  $targetPolicyAssignmentFileName = "$($key.ToLower() -replace "-", "_").alz_policy_assignment.json"

  # $mappedKey = $key
  # if ($temporaryNameMatches.ContainsKey($key)) {
  #   $mappedKey = $temporaryNameMatches[$key]
  # }

  $sourceFileName = $parsedAssignments[$key].file.Name

  if ($originalAssignments.ContainsKey($key)) {
    $originalFileName = $originalAssignments[$key].file.Name

    Write-Information "Found match for $mappedKey $key $originalFileName $sourceFileName $targetPolicyAssignmentFileName" -InformationAction Continue
    # if ($originalFileName -ne $targetPolicyAssignmentFileName) {
    #   Write-Information "Renaming $originalFileName to $targetPolicyAssignmentFileName" -InformationAction Continue
    #   Set-Location $policyAssignmentTargetPath
    #   git mv $originalAssignments[$key].file.FullName $targetPolicyAssignmentFileName
    #   Set-Location $SourcePath
    #   Set-Location ..
    # }
  }
  else {
    Write-Information "No match found for $mappedKey $key $sourceFileName $targetPolicyAssignmentFileName" -InformationAction Continue
  }

  Write-Information "Writing $targetPolicyAssignmentFileName" -InformationAction Continue
  $json = $parsedAssignments[$key].json | ConvertTo-Json -Depth 10
  $json | Edit-LineEndings -LineEnding $LineEnding | Out-File -FilePath "$policyAssignmentTargetPath/$targetPolicyAssignmentFileName" -Force
}
