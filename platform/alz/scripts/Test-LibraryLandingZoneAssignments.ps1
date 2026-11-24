[CmdletBinding()]
param (
  [Parameter(Mandatory)][String]$TargetPath
)

$ErrorActionPreference = "Stop"

$libraryPath = Join-Path $TargetPath "platform/alz"
$archetype = Get-Content -LiteralPath "$libraryPath/archetype_definitions/landing_zones.alz_archetype_definition.json" -Raw | ConvertFrom-Json

if ("Enforce-AKS-HTTPS" -in $archetype.policy_assignments) {
  throw "The generated landing_zones archetype must not reintroduce Enforce-AKS-HTTPS."
}

foreach ($assignmentName in @("Enforce-TLS-SSL-Q225", "Deny-Priv-Esc-AKS")) {
  if ($assignmentName -notin $archetype.policy_assignments) {
    throw "The generated landing_zones archetype must retain $assignmentName."
  }
}

$assignment = Get-Content -LiteralPath "$libraryPath/policy_assignments/Enforce-AKS-HTTPS.alz_policy_assignment.json" -Raw | ConvertFrom-Json
if ($assignment.name -ne "Enforce-AKS-HTTPS") {
  throw "The standalone Enforce-AKS-HTTPS assignment must remain available for explicit use."
}

Write-Output "PASS: landing_zones omits the duplicate AKS HTTPS assignment while retaining TLS and privilege-escalation controls."
Write-Output "PASS: the standalone Enforce-AKS-HTTPS assignment remains available."
