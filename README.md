# Flutter Core Packages

[![Release Status](https://github.com/flutter/core-packages/actions/workflows/release.yml/badge.svg)](https://github.com/flutter/core-packages/actions/workflows/release.yml)
[![Flutter CI Status](https://flutter-dashboard.appspot.com/api/public/build-status-badge?repo=core-packages)](https://flutter-dashboard.appspot.com/#/build?repo=core-packages)

This repo is a companion to the [flutter/flutter](https://github.com/flutter/flutter)
and [flutter/packages]() repositiories. It contains the source code for Flutter's
first-party packages (i.e., packages developed by the core Flutter team) that cannot
depend on Flutter, generally because they are used by the flutter/flutter repository.
Check the [`packages`](./packages) directory to see all packages.

These packages are also available on [pub](https://pub.dev/flutter/packages).

## Issues

Please file any issues, bugs, or feature requests in the [main flutter
repo](https://github.com/flutter/flutter/issues/new/choose).
Issues pertaining to this repository are [labeled
"package"](https://github.com/flutter/flutter/issues?q=is%3Aopen+is%3Aissue+label%3Apackage).

## Contributing

If you wish to contribute a new package to the Flutter ecosystem, please
see the documentation for [developing packages](https://flutter.dev/to/develop-packages). You can store
your package source code in any GitHub repository (the present repo is only
intended for packages developed by the core Flutter team). Once your package
is ready you can [publish](https://flutter.dev/to/develop-packages#publish)
to the [pub repository](https://pub.dev/).

If you wish to contribute a change to any of the existing packages in this repo,
please review our [contribution guide](https://github.com/flutter/core-packages/blob/main/CONTRIBUTING.md),
and send a [pull request](https://github.com/flutter/core-packages/pulls).

## Packages

These are the packages hosted in this repository:

| Package | Pub | Points | Usage | Issues | Pull requests |
|---------|-----|--------|-------|--------|---------------|
| [flutter\_hook\_config](./packages/flutter_hook_config/) | [![pub package](https://img.shields.io/pub/v/flutter_hook_config.svg)](https://pub.dev/packages/flutter_hook_config) | [![pub points](https://img.shields.io/pub/points/flutter_hook_config)](https://pub.dev/packages/flutter_hook_config/score) | [![downloads](https://img.shields.io/pub/dm/flutter_hook_config)](https://pub.dev/packages/flutter_hook_config/score) | [![GitHub issues by-label](https://img.shields.io/github/issues/flutter/flutter/p%3A%20flutter_hook_config?label=)](https://github.com/flutter/flutter/labels/p%3A%20flutter_hook_config) | [![GitHub pull requests by-label](https://img.shields.io/github/issues-pr/flutter/core-packages/p%3A%20flutter_hook_config?label=)](https://github.com/flutter/core-packages/labels/p%3A%20flutter_hook_config) |
| [vector\_math](./packages/vector_math/) | [![pub package](https://img.shields.io/pub/v/vector_math.svg)](https://pub.dev/packages/vector_math) | [![pub points](https://img.shields.io/pub/points/vector_math)](https://pub.dev/packages/vector_math/score) | [![downloads](https://img.shields.io/pub/dm/vector_math)](https://pub.dev/packages/vector_math/score) | [![GitHub issues by-label](https://img.shields.io/github/issues/flutter/flutter/p%3A%20vector_math?label=)](https://github.com/flutter/flutter/labels/p%3A%20vector_math) | [![GitHub pull requests by-label](https://img.shields.io/github/issues-pr/flutter/core-packages/p%3A%20vector_math?label=)](https://github.com/flutter/core-packages/labels/p%3A%20vector_math) |
