// This file is referenced by pubspec.yaml. If you plan on moving this file
// Make sure to update pubspec.yaml to the new location.

import 'dart:js_interop';

import 'package:flutter/foundation.dart' show Uint8List, debugPrint;
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:quill_native_bridge_platform_interface/quill_native_bridge_platform_interface.dart';
import 'package:web/web.dart';
import 'package:quill_native_bridge_platform_interface/src/image_mime_utils.dart';

import 'src/clipboard_api_support_unsafe.dart';
import 'src/mime_types_constants.dart';

/// A web implementation of the [QuillNativeBridgePlatform].
class QuillNativeBridgeWeb extends QuillNativeBridgePlatform {
  static void registerWith(Registrar registrar) {
    QuillNativeBridgePlatform.instance = QuillNativeBridgeWeb();
  }

  @override
  Future<bool> isSupported(QuillNativeBridgeFeature feature) async {
    switch (feature) {
      case QuillNativeBridgeFeature.isIOSSimulator:
        return false;
      case QuillNativeBridgeFeature.getClipboardHtml:
      case QuillNativeBridgeFeature.copyHtmlToClipboard:
      case QuillNativeBridgeFeature.copyImageToClipboard:
      case QuillNativeBridgeFeature.getClipboardImage:
        return isClipboardApiSupported;
      case QuillNativeBridgeFeature.getClipboardGif:
        return false;
      case QuillNativeBridgeFeature.getClipboardFiles:
        return false;
      case QuillNativeBridgeFeature.openGalleryApp:
      case QuillNativeBridgeFeature.saveImageToGallery:
        return false;
      case QuillNativeBridgeFeature.saveImage:
        return true;
    }
    // Without this default, adding a new item to the enum will be a breaking change.
    // ignore: dead_code
    throw UnimplementedError(
      'Checking if `${feature.name}` is supported on the web is not covered.',
    );
  }

  @override
  Future<String?> getClipboardHtml() async {
    if (isClipbaordApiUnsupported) {
      throw UnsupportedError(
        'Could not retrieve HTML from the clipboard.\n'
        'The Clipboard API is not supported on ${window.navigator.userAgent}.\n'
        'Should fallback to Clipboard events.',
      );
    }
    final clipboardItems =
        (await window.navigator.clipboard.read().toDart).toDart;
    for (final item in clipboardItems) {
      if (item.types.toDart.contains(kHtmlMimeType.toJS)) {
        final html = await item.getType(kHtmlMimeType).toDart;
        return (await html.text().toDart).toDart;
      }
    }
    return null;
  }

  @override
  Future<void> copyHtmlToClipboard(String html) async {
    if (isClipbaordApiUnsupported) {
      throw UnsupportedError(
        'Could not copy HTML to the clipboard.\n'
        'The Clipboard API is not supported on ${window.navigator.userAgent}.\n'
        'Should fallback to Clipboard events.',
      );
    }
    final blob = Blob([html.toJS].toJS, BlobPropertyBag(type: kHtmlMimeType));
    final clipboardItem = ClipboardItem(
      {kHtmlMimeType.toJS: blob}.jsify() as JSObject,
    );
    await window.navigator.clipboard.write([clipboardItem].toJS).toDart;
  }

  @override
  Future<void> copyImageToClipboard(Uint8List imageBytes) async {
    if (isClipbaordApiUnsupported) {
      throw UnsupportedError(
        'Could not copy image to the clipboard.\n'
        'The Clipboard API is not supported on ${window.navigator.userAgent}.\n'
        'Should fallback to Clipboard events.',
      );
    }
    final blob = Blob(
      [imageBytes.toJS].toJS,
      BlobPropertyBag(type: kImagePngMimeType),
    );

    final clipboardItem = ClipboardItem(
      {kImagePngMimeType.toJS: blob}.jsify() as JSObject,
    );

    await window.navigator.clipboard.write([clipboardItem].toJS).toDart;
  }

  @override
  Future<Uint8List?> getClipboardImage() async {
    if (isClipbaordApiUnsupported) {
      throw UnsupportedError(
        'Could not retrieve image from the clipboard.\n'
        'The Clipboard API is not supported on ${window.navigator.userAgent}.\n'
        'Should fallback to Clipboard events.',
      );
    }
    final clipboardItems =
        (await window.navigator.clipboard.read().toDart).toDart;
    for (final item in clipboardItems) {
      if (item.types.toDart.contains(kImagePngMimeType.toJS)) {
        final blob = await item.getType(kImagePngMimeType).toDart;
        final arrayBuffer = await blob.arrayBuffer().toDart;
        return arrayBuffer.toDart.asUint8List();
      }
    }
    return null;
  }

  @override
  Future<Uint8List?> getClipboardGif() {
    assert(() {
      debugPrint(
        'Retrieving gif image from the clipboard is unsupported regardless of the browser.\n'
        'Refer to https://github.com/singerdmx/flutter-quill/issues/2229 for discussion.',
      );
      return true;
    }());
    throw UnsupportedError(
      'Retrieving gif image from the clipboard is unsupported regardless of the browser.',
    );
  }

  @override
  Future<ImageSaveResult> saveImage(
    Uint8List imageBytes, {
    required ImageSaveOptions options,
  }) async {
    final blob = Blob(
      [imageBytes.toJS].toJS,
      BlobPropertyBag(type: getImageMimeType(options.fileExtension)),
    );
    final url = URL.createObjectURL(blob);

    final link = document.createElement('a') as HTMLAnchorElement;
    link.setAttribute('href', url);
    link.setAttribute(
        'download', '${options.fileExtension}.${options.fileExtension}');

    link.click();

    URL.revokeObjectURL(url);

    return ImageSaveResult.web(blobUrl: url);
  }
}
