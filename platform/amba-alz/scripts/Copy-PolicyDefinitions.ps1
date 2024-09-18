
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

$files = (Select-String -Path $TemplatePath/policies-*.bicep -Pattern "../../../services/").Line -replace ([regex]::Escape("loadTextContent('../../..")), "" -replace ([regex]::Escape("')")), ""

New-Item $TargetPath -Type Directory

foreach ($file in $files) {
    Copy-Item -Path $SourcePath+$file -Destination $TargetPath -Force
}
