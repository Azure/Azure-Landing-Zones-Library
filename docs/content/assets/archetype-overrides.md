---
title: Archetype Overrides
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

Filename patterns:

- `*.alz_archetype_override.json`
- `*.alz_archetype_override.yaml`
- `*.alz_archetype_override.yml`

An archetype override is a delta of an existing archetype.
it is used by callers to modify the behavior of an archetype without changing the archetype itself.

{{< hint type=important >}}
Archetype overrides are designed to be used in local libraries as the last step in customization by the caller.
They should not be stored in a central library.
{{< /hint >}}

We publish the schema of an archetype override [here](https://raw.githubusercontent.com/Azure/Azure-Landing-Zones-Library/main/schemas/archetype_override.json) and we have registered the file extensions with [schemastore.org](https://www.schemastore.org/json/) to enable  automatic validation in editors.

An archetype override has a name, which must be unique amongst all archetypes and override archetypes.
It also has and a set of policy definitions, policy set definitions, policy assignments, and role definitions to add and remove from the referenced base archetype.
All of these associated assets are referenced by their name (JSON `.name`) property.

## Example

Here is an example archetype definition file:

```yaml
name: "landing_zones_override"
base_archetype: "landing_zones"
policy_assignments_to_add: []
policy_assignments_to_remove:
  - "Deny-IP-forwarding"
policy_definitions_to_add: []
policy_definitions_to_remove: []
policy_set_definitions_to_add: []
policy_set_definitions_to_remove: []
role_definitions_to_add: []
role_definitions_to_remove: []
```

## Updating the Architecture Definition

When an archetype override is used, the architecture definition must be updated to reference the new name:

```yaml
name: my architecture
management_groups:
  - id: my-mg
    display_name: My Management Group
    archetypes:
      - root
    parent_id: null
    exists: false
  - id: my-mg-child
    display_name: My Management Group Child
    archetypes:
      - landing_zones_override # Set this to the name of the override archetype
    parent_id: my-mg
    exists: false
```
