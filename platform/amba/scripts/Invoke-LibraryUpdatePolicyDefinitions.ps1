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
    [Parameter()][String]$AlzToolsPath = "$PWD/enterprise-scale/src/Alz.Tools",
    [Parameter()][String]$TargetPath = "$PWD/library/platform/amba",
    [Parameter()][String]$SourcePath = "$PWD/enterprise-scale",
    [Parameter()][String]$LineEnding = "unix",
    [Parameter()][Switch]$Reset,
    [Parameter()][Switch]$UpdateProviderApiVersions
)

$ErrorActionPreference = "Stop"

# This script relies on a custom set of classes and functions
# defined within the EnterpriseScaleLibraryTools PowerShell
# module.
Import-Module $AlzToolsPath -ErrorAction Stop

# To avoid needing to authenticate with Azure, the following
# code will preload the ProviderApiVersions cache from a
# stored state in the module if the UseCacheFromModule flag
# is set and the ProviderApiVersions.zip file is present.
if (!$UpdateProviderApiVersions -and (Test-Path "$AlzToolsPath/ProviderApiVersions.zip")) {
    Write-Information "Pre-loading ProviderApiVersions from saved cache." -InformationAction Continue
    Invoke-UseCacheFromModule($AlzToolsPath)
}

# Get a list of current Policy Definition names
$policyDefinitionFiles = Get-ChildItem -Path "$TargetPath/platform/amba/policy_definitions/"
$policyDefinitionNames = $policyDefinitionFiles | ForEach-Object {
    (Get-Content -Path $_ | ConvertFrom-Json).Name
}

# Get a list of current Policy Set Definition names
$policySetDefinitionFiles = Get-ChildItem -Path "$TargetPath/platform/amba/policy_set_definitions/"
$policySetDefinitionNames = $policySetDefinitionFiles | ForEach-Object {
    (Get-Content -Path $_ | ConvertFrom-Json).Name
}

# Update the es_root archetype definition to reflect
# the current list of Policy Definitions and Policy
# Set Definitions
$esRootFilePath = $TargetPath + "/platform/amba/archetype_definitions/root.alz_archetype_definition.json"
Write-Information "Loading `"root`" archetype definition." -InformationAction Continue
$esRootConfig = Get-Content -Path $esRootFilePath | ConvertFrom-Json
Write-Information "Updating Policy Definitions in `"root`" archetype definition." -InformationAction Continue
$esRootConfig.policy_definitions = $policyDefinitionNames
Write-Information "Updating Policy Set Definitions in `"root`" archetype definition." -InformationAction Continue
$esRootConfig.policy_set_definitions = $policySetDefinitionNames
Write-Information "Saving `"root`" archetype definition." -InformationAction Continue
$esRootConfig | ConvertTo-Json -Depth 10 | Edit-LineEndings -LineEnding $LineEnding | Out-File -FilePath $esRootFilePath -Force
