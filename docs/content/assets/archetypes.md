---
title: Archetypes
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

Filename patterns:

- `*.alz_archetype_definition.json`
- `*.alz_archetype_definition.yaml`
- `*.alz_archetype_definition.yml`

An archetype is a collection of assets that can be deployed to a management group.
In order to promote extensibility, multiple archetypes can be deployed to the same management group.

We publish the schema of an archetype definition [here](https://raw.githubusercontent.com/Azure/Azure-Landing-Zones-Library/main/schemas/archetype_definition.json) and we have registered the file extensions with [schemastore.org](https://www.schemastore.org/json/) to enable  automatic validation in editors.

An archetype has a name, which must be unique, and a set of associated policy definitions, policy set definitions, policy assignments, and role definitions.
All of these associated assets are referenced by their name (JSON `.name`) property.

## Example

Here is an example archetype definition file:

```yaml
name: "landing_zones"
policy_assignments:
  - "Audit-AppGW-WAF"
  - "Deny-IP-forwarding"
  - "Deny-MgmtPorts-Internet"
  - "Deny-Priv-Esc-AKS"
  - "Deny-Privileged-AKS"
  - "Deny-Storage-http"
  - "Deny-Subnet-Without-Nsg"
  - "Deploy-AKS-Policy"
  - "Deploy-AzSqlDb-Auditing"
  - "Deploy-MDFC-DefSQL-AMA"
  - "Deploy-SQL-TDE"
  - "Deploy-SQL-Threat"
  - "Deploy-VM-Backup"
  - "Deploy-VM-ChangeTrack"
  - "Deploy-VM-Monitoring"
  - "Deploy-vmArc-ChangeTrack"
  - "Deploy-vmHybr-Monitoring"
  - "Deploy-VMSS-ChangeTrack"
  - "Deploy-VMSS-Monitoring"
  - "Enable-AUM-CheckUpdates"
  - "Enable-DDoS-VNET"
  - "Enforce-AKS-HTTPS"
  - "Enforce-ASR"
  - "Enforce-GR-KeyVault"
  - "Enforce-TLS-SSL-H224"
policy_definitions: []
policy_set_definitions: []
role_definitions: []
```
