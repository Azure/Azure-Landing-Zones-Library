---
title: Versioning Strategy
geekdocNav: true
geekdocAnchor: true
---

Each library member is released using a [CalVer](https://calver.org/) tagging strategy.
The strategy is as follows:

```text
library/path/YYYY.0M.P-modifier
```

Where:

- `YYYY` is the year of the release.
- `0M` is the zero-padded month of the release.
- `P` is the patch number of the release, starting at zero.
- `modifier` is an optional modifier, such as `alpha`, `beta`, or `rc`.

## Changes

Consumers may expect breaking changes between year and month releases but not between patch releases.

## Example

For example, the October 2024 release of the library member `alz` in the `platform/alz` directory would be tagged as: `platform/alz/2021.10.0`.

## Latest

The latest release of a the `platform/alz` member will be marked as latest for the repository.
