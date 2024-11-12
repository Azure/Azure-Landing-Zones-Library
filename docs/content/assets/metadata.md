---
title: Metadata
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

Filename patterns:

- `alz_library_metadata.json`

The metadata file is a JSON file that contains metadata about the library.
Note only the JSON format is supported for this file, there can only be one metadata file and it must be in the root of the library member directory.
It is used to provide information about the library, such as the name, display name, description and any dependencies.

We publish the schema of the library metadata [here](https://raw.githubusercontent.com/Azure/Azure-Landing-Zones-Library/main/schemas/library_metadata.json) and we have registered the file name with [schemastore.org](https://www.schemastore.org/json/) to enable  automatic validation in editors.

## Dependencies

It is a key value proposition that one library member can depend on another library member.
This is done by specifying library references in the `.dependencies` section of the metadata file.

Clients can read this metadata to understand the dependencies of the library and ensure that they download all the required libraries in order to create a successful deployment.

Dependencies come in two flavors:

1. ALZ Library dependencies
2. External dependencies

### ALZ Library dependencies

These are defined by the library path and reference (version):

```json
{
  "dependencies": [
    {
      "path": "platform/alz",
      "ref": "2024.07.0"
    }
  ]
}
```

### External dependencies

These are defined by the library path and reference (version):

```json
{
  "dependencies": [
    {
      "custom_url": "git::https://github.com/myorg/myrepo.git//mypath/subdir?ref=mytag-or-branch",
    }
  ]
}
```

The `custom_url` should be valid [go-getter](https://pkg.go.dev/github.com/hashicorp/go-getter#section-readme) URL format.

{{< hint type=note >}}
Do not put security sensitive information into the `custom_url`.
Instead configure any authentication/authorization externally to the client.
{{< /hint >}}
