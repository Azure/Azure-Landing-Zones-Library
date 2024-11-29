---
title: Policy Assignment Default Values
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

Filename patterns:

- `alz_policy_default_values.json`
- `alz_policy_default_values.yaml`
- `alz_policy_default_values.yml`

A policy default values file is a mapping of common values to policy assignments and parameter names.
There can only be one policy default values file in an library member, we recommend that this is stored in the root of the library member directory.

It is common to want to specify a default log analytics workspace for all policy assignments that require one.
This file allows you to specify the default values for these parameters.
Clients should be aware of these values and modify assignments as required.

We publish the schema of an archetype definition [here](https://raw.githubusercontent.com/Azure/Azure-Landing-Zones-Library/main/schemas/default_policy_values.json) and we have registered the file extensions with [schemastore.org](https://www.schemastore.org/json/) to enable  automatic validation in editors.

## Example

Here is an example policy default values file:

```json
{
  "$schema": "https://raw.githubusercontent.com/Azure/Azure-Landing-Zones-Library/main/schemas/default_policy_values.json",
  "defaults": [
    {
      "default_name": "ama_user_assigned_managed_identity_id",
      "description": "An optional description that can be used for documentation",
      "policy_assignments": [
        {
          "parameter_names": [
            "userAssignedIdentityResourceId"
          ],
          "policy_assignment_name": "Deploy-VM-ChangeTrack"
        },
        {
          "parameter_names": [
            "userAssignedIdentityResourceId"
          ],
          "policy_assignment_name": "Deploy-vmArc-ChangeTrack"
        },
        {
          "parameter_names": [
            "userAssignedIdentityResourceId"
          ],
          "policy_assignment_name": "Deploy-VMSS-ChangeTrack"
        }
      ]
    }
  ]
}
```
