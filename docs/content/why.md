---
title: Why did we build this?
geekdocNav: true
# geekdocAlign: center
geekdocAnchor: true
---

First some history...

The concept of the library began with the original ALZ Terraform ([caf-enterprise-scale](https://registry.terraform.io/modules/Azure/caf-enterprise-scale/azurerm/latest)), but it was (and still is) built into that module.
In the [early days of alzlib](https://github.com/Azure/alzlib/tree/v0.9.0), we also embedded the library into the Go module.

This tight coupling made it difficult to update the library without updating the module - it was impossible to separate module feature updates from library updates.
If you wanted the most up to date policies, then you also had to take the latest module feature updates too.

This design also made the library useful only for Terraform users, and not for other clients.
We had the idea to decouple the library from the Terraform module, and this repository is the result.
We plan that this library will be the source of truth for all Azure Landing Zones assets.

Because the library is now a separate entity, it can be updated and version controlled independently of the module.
It also has the added benefit of being able to be consumed by other clients, not just Terraform.

## Benefits

- **Consumable**: The library can be consumed by any client
- **Extensible**: The library can be extended by anyone
- **Quality**: The library can be tested and validated independently of the consumer
- **Versioning**: The library can be versioned independently of the consumer
