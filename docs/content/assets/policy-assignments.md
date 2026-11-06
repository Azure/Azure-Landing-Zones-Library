---
title: Policy Assignments
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

Filename patterns:

- `*.alz_policy_assignment.json`

These files represent Azure Policy assignments.
They are files that represent the resource definition as per the schema.
The file type is JSON.
Any keys that are not part of the schema should be ignored.

Within the resource definition, there are several values that specific to the scope of the deployed resource and must be modified when the assignment is deployed in an architecture.

These are:

- The resource id
- The scope
- The location
- The referenced policy (set) definition resource id

[Clients](/Azure-Landing-Zones-Library/clients) should be aware of these values and ensure that they are correctly set when deploying the resource.

## Diagnostic Logging Category Groups

`Deploy-Diag-LogsCat` defaults to the `allLogs` initiative, `0884adba-2312-4468-abeb-5422caed1038`, matching the Enterprise-Scale deployment default.
The assignment sync explicitly supplies `laCategory = allLogs` when evaluating the Enterprise-Scale template.

The library contains evaluated policy assignment resources, not ARM deployment templates with runtime parameters.
The Enterprise-Scale `laCategory` parameter therefore cannot be passed as an initiative parameter to switch this assignment between initiatives.

To opt into `audit`, use a custom library asset with the same assignment name and set `properties.policyDefinitionId` to `/providers/Microsoft.Authorization/policySetDefinitions/f5b29bc4-feca-4cc6-a58a-772dd5e290a5`.
Retain the assignment's Log Analytics workspace parameter and other required properties.
Configure a client that supports asset replacement to load this custom assignment after the standard library; for example, the ALZ Terraform provider supports `library_overwrite_enabled`.
See [Extensibility]({{< relref "extensibility/index" >}}) for library references and asset replacement.
This replaces the default assignment; do not add a second overlapping assignment merely to select a different category group.

Changing an existing deployment from `audit` to `allLogs` can increase log volume and ingestion cost.
Review the category choice and costs before upgrading.
