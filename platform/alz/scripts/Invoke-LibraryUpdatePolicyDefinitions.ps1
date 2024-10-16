#!/usr/bin/pwsh

#
# PowerShell Script
# - Update template library in terraform-azurerm-caf-enterprise-scale repository
#
# Valid object schema for Export-LibraryArtifact function loop:
#
# @{
#     inputPath      = [String]
#     inputFilter    = [String]
#     typeFilter     = [String[]]
#     outputPath     = [String]
#     fileNamePrefix = [String]
#     fileNameSuffix = [String]
#     asTemplate     = [Boolean]
#     recurse        = [Boolean]
#     whatIf         = [Boolean]
# }
#

[CmdletBinding(SupportsShouldProcess)]
param (
  [Parameter()][String]$TargetPath = "$PWD/library/platform/alz",
  [Parameter()][String]$SourcePath = "$PWD/enterprise-scale",
  [Parameter()][String]$LineEnding = "unix",
  [Parameter()][Switch]$Reset,
  [Parameter()][Switch]$UpdateProviderApiVersions
)

$ErrorActionPreference = "Stop"

# If the -Reset parameter is set, delete all existing
# artefacts (by resource type) from the library
if ($Reset) {
  Write-Information "Deleting existing Policy Definitions from library." -InformationAction Continue
  Remove-Item -Path "$TargetPath/platform/alz/policy_definitions/" -Recurse -Force
  Write-Information "Deleting existing Policy Set Definitions from library." -InformationAction Continue
  Remove-Item -Path "$TargetPath/platform/alz/policy_set_definitions/" -Recurse -Force
}

# Get a list of current Policy Definition names
$policyDefinitionFiles = Get-ChildItem -Path "$TargetPath/platform/alz/policy_definitions/"
$policyDefinitionNames = $policyDefinitionFiles | ForEach-Object {
    (Get-Content -Path $_ | ConvertFrom-Json).Name
}

# Get a list of current Policy Set Definition names
$policySetDefinitionFiles = Get-ChildItem -Path "$TargetPath/platform/alz/policy_set_definitions/"
$policySetDefinitionNames = $policySetDefinitionFiles | ForEach-Object {
    (Get-Content -Path $_ | ConvertFrom-Json).Name
}

# Update the es_root archetype definition to reflect
# the current list of Policy Definitions and Policy
# Set Definitions
$esRootFilePath = $TargetPath + "/platform/alz/archetype_definitions/root.alz_archetype_definition.json"
Write-Information "Loading `"root`" archetype definition." -InformationAction Continue
$esRootConfig = Get-Content -Path $esRootFilePath | ConvertFrom-Json
Write-Information "Updating Policy Definitions in `"root`" archetype definition." -InformationAction Continue
$esRootConfig.policy_definitions = $policyDefinitionNames
Write-Information "Updating Policy Set Definitions in `"root`" archetype definition." -InformationAction Continue
$esRootConfig.policy_set_definitions = $policySetDefinitionNames
Write-Information "Saving `"root`" archetype definition." -InformationAction Continue
$esRootConfig | ConvertTo-Json -Depth 10 | Out-File -FilePath $esRootFilePath -Force
