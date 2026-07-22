# Changelog

All notable changes to this project will be documented in this file.

## 0.0.2

- Updates the minimum supported SDK version to Flutter 3.44/Dart 3.12.
- Migrates to built-in Kotlin.

## 0.0.1+2

- Setup [native unit tests](https://docs.flutter.dev/testing/testing-plugins#native-unit-tests) to test plugin platform functionality.

## 0.0.1+1

- Fixes a crash that can happen on Android API 28 and earlier when permission is denied. [Related comment with more details](https://github.com/singerdmx/flutter-quill/pull/2403#discussion_r1866055681).

## 0.0.1

- Adds support for saving images.

## 0.0.1-dev.6

- Deregister platform method channel correctly in `onDetachedFromEngine`.
- Adds Dart unit tests.
- Supports saving an image to the system gallery app.
- Supports opening the system gallery app.
- Updates Java compatibility version to 11. Related [flutter#156111](https://github.com/flutter/flutter/issues/156111).

## 0.0.1-dev.5

- Adds pub topics to package metadata.
- Minor changes in doc comments.

## 0.0.1-dev.4

- Fixes [build failure](https://github.com/singerdmx/flutter-quill/issues/2340) by avoiding `androidx.core.graphics.decodeBitmap` (causing compatibility issues).

## 0.0.1-dev.3

- Requires `quill_native_bridge_platform_interface` minimum version `0.0.1-dev.4`.

## 0.0.1-dev.2

- Experimental changes in https://github.com/singerdmx/flutter-quill/pull/2230 (WIP). Not intended for public use as breaking changes will occur.
- Moved the package repo from https://github.com/singerdmx/flutter-quill to https://github.com/FlutterQuill/quill-native-bridge

## 0.0.1-dev.1

- Highly experimental changes in https://github.com/singerdmx/flutter-quill/pull/2230 (WIP). Not intended for public use as breaking changes will occur. Not stable yet.

## 0.0.1-dev.0

- Initial experimental release. WIP in https://github.com/singerdmx/flutter-quill/pull/2230. Not intended for public use as breaking changes will occur.