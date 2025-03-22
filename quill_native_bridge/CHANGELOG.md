# Changelog

All notable changes to this project will be documented in this file.

## 11.0.1

- Adds `isAppleSafari` method to check whether the current web app is running on Safari browser.

## 11.0.0

- Improves `README.md`. Adds more details to `README.md`.
- Updates the section `Platform configuration` to `Setup` in `README.md`.
- Improves doc comments.
- Adds unit tests for `QuillNativeBridge`.
- Adds support for saving images.
- Updates Java compatibility version to 11. Related [flutter#156111](https://github.com/flutter/flutter/issues/156111).
- **BREAKING CHANGE**: Converted all static methods in `QuillNativeBridge` to instance methods to improve unit testing and extensibility.

## 10.7.11

- Adds pub topics to package metadata.
- Updates minimum versions of platform implementation dependencies.
- Removes redundant `platforms` in package metadata.

## 10.7.10

- Support Swift package manager.
- Update minimum required versions for Android, iOS, macOS and web implementation packages.

## 10.7.9

- Require `quill_native_bridge_platform_interface` minimum version `0.0.1-dev.4`.

## 10.7.8

- Experimental changes in https://github.com/singerdmx/flutter-quill/pull/2230 (WIP). Not intended for public use as breaking changes will occur.
- Moved the package repo from https://github.com/singerdmx/flutter-quill to https://github.com/FlutterQuill/quill-native-bridge

## 10.7.7

- Highly experimental changes in https://github.com/singerdmx/flutter-quill/pull/2230 (WIP). Not intended for public use as breaking changes will occur. Not stable yet.

## 10.7.6

- Highly experimental changes in https://github.com/singerdmx/flutter-quill/pull/2230 (WIP). Not intended for public use as breaking changes will occur. Not stable yet.
- Update `quill_native_bridge_web`

## 10.7.5

- Highly experimental changes in https://github.com/singerdmx/flutter-quill/pull/2230 (WIP). Not intended for public use as breaking changes will occur. Not stable yet.

## 10.7.5-dev.0

- Move the plugin platform interface `QuillNativeBridgePlatform` to [quill_native_bridge_platform_interface](https://pub.dev/packages/quill_native_bridge_platform_interface).
- Highly experimental changes in https://github.com/singerdmx/flutter-quill/pull/2230 (WIP). Not intended for public use as breaking changes will occur.

## 10.7.4

- Seperate the version of `quill_native_bridge` from `flutter_quill` and related packages.
- Highly experimental changes in https://github.com/singerdmx/flutter-quill/pull/2230 (WIP). Not intended for public use as breaking changes will occur.