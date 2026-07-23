# Changelog

All notable changes to this project will be documented in this file.

## 0.0.3

- Depends on [`package:is_ios_simulator`](https://pub.dev/packages/is_ios_simulator) for iOS Simulator detection while preserving the existing API, avoiding duplication of the native implementation across packages.
- Updates generated Pigeon code after updating the Pigeon dev dependency.

## 0.0.2

- Reads the clipboard (`getClipboardHtml()`, `getClipboardImage()` and `getClipboardGif()`) asynchronously with `NSItemProvider` instead of `UIPasteboard.data(forPasteboardType:)`, fixing app hangs (ANR) on paste when the pasteboard item has to be fetched first (for example a Universal Clipboard item coming from another Apple device). [#22](https://github.com/FlutterQuill/quill-native-bridge/issues/22)

## 0.0.1

- Adds support for saving images.

## 0.0.1-dev.6

- Adds pub topics to package metadata.
- Minor changes in doc comments.

## 0.0.1-dev.5

- Support Swift Package Manager.

## 0.0.1-dev.4

- Added support for WebP image format in `getClipboardImage()`

## 0.0.1-dev.3

- Require `quill_native_bridge_platform_interface` minimum version `0.0.1-dev.4`.

## 0.0.1-dev.2

- Experimental changes in https://github.com/singerdmx/flutter-quill/pull/2230 (WIP). Not intended for public use as breaking changes will occur.
- Moved the package repo from https://github.com/singerdmx/flutter-quill to https://github.com/FlutterQuill/quill-native-bridge

## 0.0.1-dev.1

- Highly experimental changes in https://github.com/singerdmx/flutter-quill/pull/2230 (WIP). Not intended for public use as breaking changes will occur. Not stable yet.

## 0.0.1-dev.0

- Initial experimental release. WIP in https://github.com/singerdmx/flutter-quill/pull/2230. Not intended for public use as breaking changes will occur.