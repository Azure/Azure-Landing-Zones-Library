---
title: Extensibility
geekdocNav: true
# geekdocAlign: center
geekdocAnchor: true
---

The Azure Landing Zones Library is designed to be flexible:

- ✅ You want to fork host your own version of the library? You can do that!
- ✅ You want to be able to extend the library with your own constructs, and use them in your own deployments? You can do that as well!
- ✅ You want to be able to consume the library with your own client? You can do that too!
- ✅ You want to host your own personal customizations based on published library assets? You guessed it, you can do that!

## On dependencies

If you host your own library, we recommend that you use create a [`alz_library_metadata.json`]({{< relref "assets/metadata" >}}) file in the root of your library directory to provide metadata about your library.
In this file you should include any dependencies.

Alternatively you can supply the dependent library to your client.
In the ALZ Terraform provider, you can include the dependent library in the `library_references` field of the provider configuration.

By default, your client will not allow you to add assets to the library that already exist.
For example, you cannot create an another architecture called `alz` when you are using the `platform/alz` library.
We recommend that you use unique naming for your assets to avoid conflicts.

If you are unable to avoid conflicts, you can use configure your client to allow you to override assets in the library.
In the ALZ Terraform provider, you can set the [`library_overwrite_enabled`](https://registry.terraform.io/providers/Azure/alz/latest/docs#library_overwrite_enabled-1) field of the provider configuration.

## Forking or hosting your own version of the library

You may wish to fork the library and host your own version of it, or you may wish to host your own extensions to this library.
Examples are:

- Customizing the architecture definitions to suit your own needs, e.g. naming conventions
- Including your own policy assets
- Removing or modifying policy assets in this library that you do not wish to use (using [archetype overrides]({{< relref "assets/archetype-overrides" >}}))

Library clients should be able to access the library from a variety of sources, including git, local file system, or a URL.
The [`alzlib`](https://github.com/Azure/alzlib) library client uses the [`hashicorp/go-getter`](https://github.com/hashicorp/go-getter) library to fetch the library from a variety of sources.

{{< hint type=important icon=gdoc_check_circle_outline title="Dependencies" >}}
Dependencies are transitive, so if you include a dependency in your library, you do not need to explicitly include any dependants of your dependencies.
{{< /hint >}}

You can either add dependencies to the Azure Landing Zones Library, or a custom URL.
Custom URLs can be any URL supported by `go-getter`, including git repositories, local file systems, or HTTP URLs.

### Using a local filesystem

This example shows how to configure the ALZ Terraform provider with a local library.
This is common for when you want to augment the ALZ library with your own customizations.

This will replace the default `library_referneces` value, which is pinned to a version of the ALZ Library, see the [provider docs](https://registry.terraform.io/providers/Azure/alz/latest/docs#library_references-1) for more information:

```terraform
provider "alz" {
  library_references = [
    {
      custom_url = "${path.root}/lib"
    },
    # If you do not host metadata in your local library then include any dependencies here...
  ]
}
```

## Changing the default library Git URL

Using environment variables, you can change the git URL that the `alzlib` client uses, the default is: `github.com/Azure/Azure-Landing-Zones-Library`.
This is useful if you want to use a different library URL for your deployments, or if you are testing updates in a fork before making a pull request back to the upstream repo.
This is documented [here](https://github.com/Azure/alzlib?tab=readme-ov-file#configuration).

Using the `ALZLIB_LIBRARY_GIT_URL` environment variable is only supported with the git protocol.
The value is appended to the `git::` prefix to force the `go-getter` library to use the git protocol.

{{< hint type=important icon=gdoc_check_circle_outline title="Git authentication" >}}
Do not include your Git credentials in your library reference or dependency URLs.
Instead, configure Git to use valid credentials for the URL you are using before running the `alzlib` client.
{{< /hint >}}

### Example

```bash
export ALZLIB_LIBRARY_GIT_URL="https://FabrikamFiber01@dev.azure.com/FabrikamFiber01/FabrikamFiber01-01/_git/FabrikamFiber01-01"
```
