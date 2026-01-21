#!/usr/bin/pwsh

#
# PowerShell Script
# - Update template library in azure-landing-zones-library repository
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
  [Parameter()][String]$TargetPath = "$PWD/library/platform/alz"  
)

# Functions

# Function to rename files to match the pattern: {name}.{version}.{fileType}.{ext} or {name}.{fileType}.{ext}
function Rename-LibraryFile {
  param (
    [Parameter(Mandatory)][System.IO.FileInfo]$File,
    [Parameter(Mandatory)][String]$FileType
  )

  $content = Get-Content -Path $File.FullName | ConvertFrom-Json
  $name = $content.name
  $version = $content.properties.version

  if ($version) {
    Write-Information "File has version: $version. Renaming..." -InformationAction Continue
    $expectedFileName = "$name.$version.$FileType.json"
  }
  else {
    Write-Information "File has no version." -InformationAction Continue
    $expectedFileName = "$name.$FileType.json"
  }

  if ($File.Name -ne $expectedFileName) {
    Write-Information "Renaming file: $($File.Name) -> $expectedFileName" -InformationAction Continue
    Rename-Item -Path $File.FullName -NewName $expectedFileName -Force
  }
}

$ErrorActionPreference = "Stop"

$removedPolicySetDefinitions = @(
  "Enforce-Encryption-CMK.alz_policy_set_definition.json"
)

$removedPolicyDefinitions = @()

# Remove any Policy Set Definitions that are no longer
# present in the source repository
Get-ChildItem -Path (Join-Path $TargetPath "policy_set_definitions") -File | ForEach-Object {
  if ($removedPolicySetDefinitions -contains $_.Name) {
    Write-Information "==> Removing obsolete Policy Set Definition: $($_.Name)" -InformationAction Continue
    Remove-Item -Path $_.FullName -Force
  }
}

# Remove any Policy Definitions that are no longer
# present in the source repository
Get-ChildItem -Path (Join-Path $TargetPath "policy_definitions") -File | ForEach-Object {
  if ($removedPolicyDefinitions -contains $_.Name) {
    Write-Information "==> Removing obsolete Policy Definition: $($_.Name)" -InformationAction Continue
    Remove-Item -Path $_.FullName -Force
  }
}

# Rename Policy Definition files to match naming convention
Write-Information "=====> Checking Policy Definition file names." -InformationAction Continue
Get-ChildItem -Path (Join-Path $TargetPath "policy_definitions") -File -Filter "*.json" | ForEach-Object {
  Write-Information "==> Processing file: $($_.FullName) for versioning naming." -InformationAction Continue
  Rename-LibraryFile -File $_ -FileType "alz_policy_definition"
}

# Rename Policy Set Definition files to match naming convention
Write-Information "=====> Checking Policy Set Definition file names." -InformationAction Continue
Get-ChildItem -Path (Join-Path $TargetPath "policy_set_definitions") -File -Filter "*.json" | ForEach-Object {
  Write-Information "==> Processing file: $($_.FullName) for versioning naming." -InformationAction Continue
  Rename-LibraryFile -File $_ -FileType "alz_policy_set_definition"
}

# Get a list of current Policy Definition names
$policyDefinitionFiles = Get-ChildItem -Path (Join-Path $TargetPath "policy_definitions") -File
$policyDefinitionNames = $policyDefinitionFiles | ForEach-Object {
  (Get-Content -Path $_ | ConvertFrom-Json).name
}

# Get a list of current Policy Set Definition names
$policySetDefinitionFiles = Get-ChildItem -Path (Join-Path $TargetPath "policy_set_definitions") -File
$policySetDefinitionNames = $policySetDefinitionFiles | ForEach-Object {
  (Get-Content -Path $_ | ConvertFrom-Json).name
}

# Update the es_root archetype definition to reflect
# the current list of Policy Definitions and Policy
# Set Definitions
$esRootFilePath = Join-Path $TargetPath "archetype_definitions/root.alz_archetype_definition.json"
Write-Information "=====> Loading `"root`" archetype definition." -InformationAction Continue
$esRootConfig = Get-Content -Path $esRootFilePath | ConvertFrom-Json
Write-Information "=====> Updating Policy Definitions in `"root`" archetype definition." -InformationAction Continue
$esRootConfig.policy_definitions = $policyDefinitionNames
Write-Information "=====> Updating Policy Set Definitions in `"root`" archetype definition." -InformationAction Continue
$esRootConfig.policy_set_definitions = $policySetDefinitionNames
Write-Information "=====> Saving `"root`" archetype definition." -InformationAction Continue
$esRootConfig | ConvertTo-Json -Depth 10 | Out-File -FilePath $esRootFilePath -Force


