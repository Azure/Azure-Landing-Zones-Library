[CmdletBinding()]
param (
  [Parameter(Mandatory)][String]$TargetPath,
  [Parameter(Mandatory)][String]$SourcePath,
  [Parameter()][String]$ParserPath
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrEmpty($ParserPath)) {
  $parserExe = if ($IsWindows) { "Template.Parser.Cli.exe" } else { "Template.Parser.Cli" }
  $ParserPath = Join-Path "$TargetPath/platform/alz/scripts" $parserExe
}

$templatePath = "$SourcePath/eslzArm/managementGroupTemplates/policyAssignments/DINE-ResourceDiagnosticsPolicyAssignment.json"
$workspaceId = "/subscriptions/00000000-0000-0000-0000-000000000000/resourcegroups/placeholder/providers/Microsoft.OperationalInsights/workspaces/placeholder-la"
$initiatives = [ordered]@{
  allLogs = "/providers/Microsoft.Authorization/policySetDefinitions/0884adba-2312-4468-abeb-5422caed1038"
  audit   = "/providers/Microsoft.Authorization/policySetDefinitions/f5b29bc4-feca-4cc6-a58a-772dd5e290a5"
}

foreach ($category in $initiatives.Keys) {
  $arguments = @(
    "-s $templatePath",
    "-p topLevelManagementGroupPrefix=defaults",
    "-p logAnalyticsResourceId=$workspaceId",
    "-p laCategory=$category",
    "-a"
  )
  $parsed = & $ParserPath @arguments | Out-String
  if ($LASTEXITCODE -ne 0) {
    throw "Template parsing failed for diagnostic category $category."
  }

  $assignments = @($parsed | ConvertFrom-Json | Where-Object { $_.type -eq "Microsoft.Authorization/policyAssignments" -and $_.name -eq "Deploy-Diag-LogsCat" })
  if ($assignments.Count -ne 1 -or $assignments[0].properties.policyDefinitionId -ne $initiatives[$category]) {
    throw "Diagnostic category $category must select initiative $($initiatives[$category])."
  }
  if ($assignments[0].properties.parameters.logAnalytics.value -ne $workspaceId) {
    throw "Diagnostic category $category must retain the Log Analytics workspace parameter."
  }
  Write-Output "PASS: $category selects $($initiatives[$category])."
}

$assignmentPath = "$TargetPath/platform/alz/policy_assignments/Deploy-Diag-LogsCat.alz_policy_assignment.json"
$assignment = Get-Content -LiteralPath $assignmentPath -Raw | ConvertFrom-Json
if ($assignment.properties.policyDefinitionId -ne $initiatives.allLogs) {
  throw "The generated Deploy-Diag-LogsCat library assignment must default to allLogs."
}
Write-Output "PASS: the library diagnostic assignment defaults to allLogs."