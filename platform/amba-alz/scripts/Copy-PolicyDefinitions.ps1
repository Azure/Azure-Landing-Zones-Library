<#
.SYNOPSIS
    Copies policy definition files from a source directory to a target directory.

.DESCRIPTION
    This script reads the AMBA-ALZ template files to find policy definition file paths, then copies those files from the source directory to the target directory. It creates the target directory if it does not exist.

.NOTES
    Intended to be used in the context of the update platform/amba-alz workflow.

.LINK
    https://github.com/Azure/Azure-Landing-Zones-Library

.PARAMETER TemplatePath
    The path to the template files containing the policy definition file paths. Typically "patterns/alz/templates".

.PARAMETER SourcePath
    The path to the source directory where the policy definition files are located.

.PARAMETER TargetPath
    The path to the target directory where the policy definition files will be copied.
#>

[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory = $true)]
    [string]
    $TemplatePath,

    [Parameter(Mandatory = $true)]
    [string]
    $SourcePath,

    [Parameter(Mandatory = $true)]
    [string]
    $TargetPath
)

$files = (Select-String -Path $TemplatePath/policies-*.bicep -Pattern "../../../services/").Line -replace ([regex]::Escape("    loadTextContent('../../..")), "" -replace ([regex]::Escape("')")), ""

New-Item $TargetPath -Type Directory

foreach ($file in $files) {
    Copy-Item -Path $($SourcePath+$file) -Destination $TargetPath -Force
}
