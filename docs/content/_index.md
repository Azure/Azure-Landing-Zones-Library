---
title: Azure Landing Zones Library
geekdocNav: true
# geekdocAlign: center
geekdocAnchor: true
---

Welcome to the Azure Landing Zones Library. This library is a collection of resources to help you build and manage governance on Azure. The library is comprised of Azure Policy assets, together with a series of constructs that result in a deployable architecture.

For an example, please see the alz library member in the `platform/alz` directory of the [repository](https://github.com/Azure/Azure-Landing-Zones-Library/tree/main/platform/alz).

For more information on why we built this, see the [Why]({{< relref "why" >}}) section.

## What types of things can you find in the library?

See the [Library Assets]({{< relref "assets" >}}) section for more information.

## How can you consume the library?

See the [Library Clients]({{< relref "clients" >}}) section for more information.

## Library structure

Each library member has its own directory in the `platform` directory of the repo.
The files are processed according to their file names, the directory they are in is not considered, however you may wish to organize your files in to directories for clarity.
We recommend that you use the following directory naming convention for consistency:

- `archetype_definitions`
- `architecture_definitions`
- `policy_assignments`
- `policy_definitions`
- `policy_set_definitions`
- `role_definitions`

You should place the metadata and policy default values files in the root of the library member directory.
