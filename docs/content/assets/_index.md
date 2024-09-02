---
title: Library Assets
geekdocNav: true
# geekdocAlign: center
geekdocAnchor: true
---

Assets are identified by filename patterns and are read from the library member directories. The assets are processed according to their names, the directory they are in is not considered, however you may wish to organize your files in to directories for clarity.

{{< hint type=important >}}
The name (JSON property `.name`) of the asset must be unique for any given asset type. For example, you cannot have two policy definitions with the same name. This is especially important when considering extensibility.
{{< /hint >}}

Assets are keyed by name, during the process of creating a deployable architecture, the assets are modified to update references such as resource ids.
Clients should lookup references resources by name and correctly update values before deploying the resource.

The following assets are supported:

- [**Policy Definitions**](/Azure-Landing-Zones-Library/assets/policy-definitions): These are the custom Azure policy definitions that you can assign to your environment.

- [**Policy Set Definitions**](/Azure-Landing-Zones-Library/assets/policy-set-definitions): These are the custom Azure policy set definitions that you can assign to your environment.

- [**Policy Assignments**](/Azure-Landing-Zones-Library/assets/policy-assignments): These are the Azure policy assignments that you can assign to your environment.
They may reference built-in or custom policy (set) definitions.

- [**Role Definitions**](/Azure-Landing-Zones-Library/assets/role-definitions): These are the custom Azure role definitions that you can assign to your environment.

The above assets are organized in to a hierarchy of constructs. The constructs are:

- [**Archetypes**](/Azure-Landing-Zones-Library/assets/archetypes): These constructs that represent a set of policies and roles.
One or more archetypes may be assigned to a management group using an architecture.

- [**Archetype Overrides**](/Azure-Landing-Zones-Library/assets/archetype-overrides): These constructs that represent a delta from a base archetype.
Just like regular archetypes, thay may be assigned to a management group using an architecture.

- [**Architectures**](/Azure-Landing-Zones-Library/assets/architectures): These are the constructs that represent a deployable management group hierarchy, together with associated archetypes.

There are also some additional items in each library member:

- [**Metadata**](/Azure-Landing-Zones-Library/assets/metadata): This is the metadata for the library member. It includes the name, description, and dependency information.
A library memebr may extend another, if this is the case then the dependency information is useful for clients to understand the relationship between the members.

- [**Policy Default Values**](/Azure-Landing-Zones-Library/assets/policy-default-values): It is common to want to pass the same value into multiple policy assignments.
For example, a default Log Analytics workspace id. This construct allows you to define a default value that can be referenced by many policy assignments, for specific parameters.
