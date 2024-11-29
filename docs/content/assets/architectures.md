---
title: Architectures
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

Filename patterns:

- `*.alz_architecture_definition.json`
- `*.alz_architecture_definition.yaml`
- `*.alz_architecture_definition.yml`

Architectures define a management group hierarchy, together with the policies and policy assignments that are applied to the management groups.

We publish the schema of an architecture definition [here](https://raw.githubusercontent.com/Azure/Azure-Landing-Zones-Library/main/schemas/architecture_definition.json) and we have registered the file extensions with [schemastore.org](https://www.schemastore.org/json/) to enable  automatic validation in editors.

An architecture has a name, which must be unique, and a set of management groups with associated archetypes.
Each management group has the following properties:

- **id**: The name of the management group
- **display_name**: The display name of the management group
- **archetypes**: A list of archetype names to apply to the management group
- **parent_id**: The id of the parent management group, set to `null` to indicate the root management group
- **exists**: A boolean value indicating whether the management group already exists and should not be created

If `parent_id` is set to `null`, the management group is created as a child of the management group defined by the client.
Typically, this is the tenant root management group.

All of these associated assets are referenced by their name (JSON `.name`) property.

## Example

Here is an example architecture definition file:

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
      - landing_zones
    parent_id: my-mg
    exists: false
```
