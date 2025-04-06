# Unofficial and Experimental Binary Ninja vcpkg Overlays

This repository holds [vcpkg](https://github.com/microsoft/vcpkg) overlays related to packaging [Binary Ninja's C++ API](https://github.com/Vector35/binaryninja-api).

This repository is experimental for testing an unofficial [CMake refactor](https://github.com/ekilmer/binaryninja-api/tree/cmake-refactor).

**NOTE:** Binary Ninja UI API support does not exist yet. It is recommended to follow [these directions](https://docs.binary.ninja/dev/plugins.html#ui-plugins_1) and build against Vector 35's Qt version. You can also download pre-built Qt from [Vector35/qt-artifacts](https://github.com/Vector35/qt-artifacts/releases) repository releases.

## Usage

Clone this repo wherever you want and tell vcpkg to use the appropriate directory(s) as overlays.

### Latest Development Version of Binary Ninja

This will build against the latest commit on the cmake-refactor branch. This port overlay is unstable because vcpkg will always pull the latest commit, which might not be tested.

If there is an issue, please report or submit a pull request.

```text
--overlay-ports=[...]/api-dev
```

### Stable Version

This is a pinned version of the Binary Ninja API, as was tagged for an official release.

```text
--overlay-ports=[...]/api-5.0.7290-stable
```

### ABI Version and Release Mapping

| Release         | Minimum Core ABI | Current Core ABI | # Commits | Version String            |
|-----------------|------------------|------------------|-----------|---------------------------|
| dev             | 100*             | 104*             | 9999      | 100.104.9999*             |
| 5.0.7920-stable | 100              | 103              | 3         | 100.103.3+5.0.7290-stable |
|                 |                  |                  |           |                           |

\* May be outdated, due to rolling commits

## Purpose

The reason for packaging with vcpkg (or any packaging solution, really) is that it makes building software on top of a library/dependency much easier.

Instead of vendoring by copy-paste or submodules, dependencies are made explicit. Their origin is better understood, patches (or a fork) are explicit, and collecting a compatible set of dependencies together is easier.

Vcpkg allows building of all dependencies from source with the same compiler, thus ensuring binary compatibility.

Vcpkg also integrates well with CI to cache pre-built dependencies for the next run, thus speeding up CI times.

Usage of static analysis, linting, and formatting tools in the primary project can be used to look _only_ at the project's own source code, without much configuration to ignore submodules or vendored dependency directories.

## Repository Layout and Notes

This is not a vcpkg registry because it is difficult to update past versions for bug fixes in the packaging logic. However, this means there are many copies of the same files, which will _all_ need to be updated if a bug is found to affect different versions of the API. This is definitely a drawback, but managing different versions of the API is easier.

### Versioning

For versioning, I want to experiment with the following [semver](https://semver.org/) format (spoiler alert: this isn't perfect):

```text
100.103.3+5.0.7290-stable
<BN_MINIMUM_CORE_ABI_VERSION>.<BN_CURRENT_CORE_ABI_VERSION>.<COMMITS_SINCE_MODIFYING_CURRENT_CORE_ABI_VERSION>+<BINARY_NINJA_RELEASE_VERSION>
```

Reasoning for worrying about the core ABI version is that native plugins will fail to load within Binary Ninja unless they **_are between or equal to_** the minimum (major version) and current (minor version) core ABI versions. So, when upstream bumps the minimum core ABI version, this will require a rebuild of the native plugin.

A glaring issue with this scheme is that we are only tracking the C ABI. C++-only changes are recorded by just the patch version, which means any backward-incompatible changes made to the C++ API is not captured appropriately. I'm not sure how to fix this without upstream's support for tracking C++ API changes.

Ideally, for tracking this information, there would be a tool to automatically extract the full version from a specified API commit or released Binary Ninja version. Rough plan and notes:

- Keep track of commits that bump `BN_MINIMUM_CORE_ABI_VERSION` and `BN_CURRENT_CORE_ABI_VERSION` values
- Calculate number of commits _after_ bumping `BN_CURRENT_CORE_ABI_VERSION` for arbitrary commits (this would be like C++ API compatibility and bounding for introduction of new features, bug-fixes, etc.)
- Map binaryninja-api commits to released Binary Ninja stable and dev builds (using [`version_switcher.py`](https://github.com/Vector35/binaryninja-api/blob/dev/python/examples/version_switcher.py))

## API Dependencies

Below is a summary of API dependency versions.

- Development (rolling, so might be outdated)
  - fmt v11.0.2
  - rapidjson v1.1.0
    - With [custom patches](./api-dev/rapidjson/vector35.patch)
  - nlohmann-json v3.11.3
  - jsoncpp v1.8.4 (vendored in API repo)
    - Uses [custom patches](https://github.com/Vector35/binaryninja-api/tree/dev/json) with reference to Binary Ninja API headers
  - Qt v6.8.2 (not packaged in this repo)
    - With [custom patches](https://github.com/Vector35/qt-build/tree/11d911af3178fcf7df5810e01eee572fb3174d72)

- 5.0.7290
  - fmt v11.0.2
  - rapidjson v1.1.0
    - With [custom patches](./api-5.0/rapidjson/vector35.patch)
  - nlohmann-json v3.11.3
  - jsoncpp v1.8.4 (vendored in API repo)
    - Uses [custom patches](https://github.com/Vector35/binaryninja-api/tree/dev/json) with reference to Binary Ninja API headers
  - Qt 6.8.2 (not packaged in this repo)
    - With [custom patches](https://github.com/Vector35/qt-build/tree/11d911af3178fcf7df5810e01eee572fb3174d72)
