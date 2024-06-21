[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/Azure/Azure-Landing-Zones-Library/badge)](https://scorecard.dev/viewer/?uri=github.com/Azure/Azure-Landing-Zones-Library)

# Azure Landing Zones Library

This repo contains the assets required to deploy Azure Landing Zones.
It is designed to be read by the [alzlib](https://github.com/Azure/alzlib) go module.

## Library Contents

The library assets are organized into the following directories:

```text
.
├── platform
│   ├── alz
    └── ...
```

The Azure Landing Zones reference architecture is defined in the `platform/alz` directory.
Other architectures are defined as children of `platform`.

## Dependencies

In order to reduce duplication, a member of the library can be dependeant on another.
For example, it is common to have Azure Landing Zones as a base architecture and then have industry or region-sepcific variants based on ALZ.
In this case, the industry or region-specific variant would depend on the Azure Landing Zones architecture and only contain the differences.

## Asset Naming

Each library asset must have a unique name.
This is the JSON `.name` property in the asset file.

## Policy Definitions

These are JSON files with the following suffix `*.alz_policy_definition.json`.
They are the same JSON files as you would get if you queried the Azure policy definition API.

## Policy Set Definitions

These are JSON files with the following suffix `*.alz_policy_set_definition.json`.
They are the same JSON files as you would get if you queried the Azure policy set definition API.

## Policy Assignments

These are JSON files with the following suffix `*.alz_policy_assignment.json`.
They are the same JSON files as you would get if you queried the Azure policy assignment API.

## Role Definitions

These are JSON files with the following suffix `*.alz_role_definition.json`.
They are the same JSON files as you would get if you queried the Azure role definition API.

## Archetypes

These are JSON files with the following suffix `*.alz_archetype_definition.json`. The schema is defined in the `schemas` directory.

An archetype is a **mapping** of assets to fulfill a specific goal.
It is collection of assets (policy/role) representing a specific governance model that can be assigned to a management group in an Architecture.

## Architecture

These are JSON files with the following suffix `*.alz_architecture_definition.json`. The schema is defined in the `schemas` directory.

A representation of a deployed management group hierarchy, with associated archetypes. It is left to the specific implementation to add deploy-time values such as policy assignment parameters, resource selectors, overrides, and role assignments.

When an architecture is selected by the `alzlib` module:

- The assets are copied in memory and all references are corretly updated
- Optionally, additional data is generated to ensure the correct role assignments for policy are made
- The data (ARM JSON) is then available to be deployed

> Important: A management group in an architecture must have one or more archetypes assigned. `alzlib` will create a union of the assets supplied in all archetypes.

## Contributing

This project welcomes contributions and suggestions. Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit <https://cla.opensource.microsoft.com>.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft
trademarks or logos is subject to and must follow
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.
