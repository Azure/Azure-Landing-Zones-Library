---
title: Policy Set Definitions
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

Filename patterns:

- `*.alz_policy_set_definition.json`

These files represent Azure Policy Set (initiative) definitions.
They are files that represent the resource definition as per the schema.
The file type is JSON.
Any keys that are not part of the schema should be ignored.

Within the resource definition, there are several values that specific to the scope of the deployed resource and must be modified when the assignment is deployed in an architecture.

These are:

- The resource id
- The resource ids of the custom policy definitions that are part of the policy set

[Clients](/Azure-Landing-Zones-Library/clients) should be aware of these values and ensure that they are correctly set when deploying the resource.
