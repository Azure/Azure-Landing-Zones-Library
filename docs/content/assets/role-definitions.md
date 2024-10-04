---
title: Role Definitions
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

Filename patterns:

- `*.alz_role_definition.json`
- `*.alz_role_definition.yaml`
- `*.alz_role_definition.yml`

These files represent Azure role definitions.
They are files that represent the resource definition as per the schema.
Although the Azure Resource Manager APIs use JSON, the library supports both JSON and YAML formats.
Any keys that are not part of the schema should be ignored.

Within the resource definition, there are several values that specific to the scope of the deployed resource and must be modified when the assignment is deployed in an architecture.

These are:

- The resource id (this must end with a UUID)
- The name (UUID) of the role definition - this must be unique within the tenant
- The role name (`.properties.roleName`) - this must be unique within the tenant
- The assignable scopes

We recommend that clients append the management group id to the end of the rolenames to ensure uniqueness.

[Clients](/Azure-Landing-Zones-Library/clients) should be aware of these values and ensure that they are correctly set when deploying the resource.
