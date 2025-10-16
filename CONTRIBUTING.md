# Contributing

This project welcomes contributions and suggestions. Most contributions require you to
agree to a Contributor License Agreement (CLA) declaring that you have the right to,
and actually do, grant us the rights to use your contribution. For details, visit
https://cla.microsoft.com.

When you submit a pull request, a CLA-bot will automatically determine whether you need
to provide a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the
instructions provided by the bot. You will only need to do this once across all repositories using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/)
or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

# Setup and build

Run the following command to install the tools required to build the project:

```bash
make tools
```

Run the following command to build the docs for a specific library:

```bash
make docs LIB=platform/<library>
```

Where `<library>` is the name of the library you want to build the docs for. For example, to build the docs for the `alz` library, run the following command:

 ```bash
make docs LIB=platform/alz
```

# Release process

Once the PR has been merged, a new release must be created that follows the Library and CalVer versioning scheme.

This process differs slightly depending on which library is being released.

## ALZ Library

1. Create a release with a tag name that follows the format `platform/alz/yyyy.mm.patch`, where `yyyy` is the year, `mm` is the month, and `patch` is the patch number (e.g., `platform/alz/2025.09.2`).
    The year and month should only be updated when there is a policy refresh or major breaking change.
1. The release title should be the same as the tag name.
1. The release description should include a summary of the changes made in the release.
1. For breaking changes, these must be called out in the release notes.
1. Ensure that `Set as the latest release` is checked.
1. Publish the release.
1. Update the `platform\slz\alz_library_metadata.json` file with the new ALZ tag you just created.
1. Raise a PR and release the `platform/slz` library following the [steps](#slz-library) below.

## SLZ Library

1. Create a release with a tag name that follows the format `platform/slz/yyyy.mm.patch`, where `yyyy` is the year, `mm` is the month, and `patch` is the patch number (e.g., `platform/slz/2025.10.0`).
    The year and month should only be updated when there is a policy refresh or major breaking change.
1. The release title should be the same as the tag name.
1. The release description should include a summary of the changes made in the release.
1. For breaking changes, these must be called out in the release notes.
1. Ensure that `Set as the latest release` is unchecked.
1. Publish the release.

## AMBA Library

1. Create a release with a tag name that follows the format `platform/amba/yyyy.mm.patch`, where `yyyy` is the year, `mm` is the month, and `patch` is the patch number (e.g., `platform/amba/2024.06.0`).
    The year and month should only be updated when there is a policy refresh or major breaking change.
1. The release title should be the same as the tag name.
1. The release description should include a summary of the changes made in the release.
1. For breaking changes, these must be called out in the release notes.
1. Ensure that `Set as the latest release` is unchecked.
1. Publish the release.
