// This file is referenced by pubspec.yaml. If you plan on moving this file
// Make sure to update pubspec.yaml to the new location.

import 'package:flutter/services.dart';
import 'package:quill_native_bridge_platform_interface/quill_native_bridge_platform_interface.dart';

import 'src/messages.g.dart';

/// An implementation of [QuillNativeBridgePlatform] for iOS.
class QuillNativeBridgeIos extends QuillNativeBridgePlatform {
  final QuillNativeBridgeApi _hostApi = QuillNativeBridgeApi();

  /// Registers this class as the default instance of [QuillNativeBridgePlatform].
  static void registerWith() {
    QuillNativeBridgePlatform.instance = QuillNativeBridgeIos();
  }

  @override
  Future<bool> isSupported(QuillNativeBridgeFeature feature) async => {
        QuillNativeBridgeFeature.isIOSSimulator,
        QuillNativeBridgeFeature.getClipboardHtml,
        QuillNativeBridgeFeature.copyHtmlToClipboard,
        QuillNativeBridgeFeature.copyImageToClipboard,
        QuillNativeBridgeFeature.getClipboardImage,
        QuillNativeBridgeFeature.getClipboardGif,
        QuillNativeBridgeFeature.openGalleryApp,
        QuillNativeBridgeFeature.saveImageToGallery,
      }.contains(feature);

  @override
  Future<bool> isIOSSimulator() => _hostApi.isIosSimulator();

  @override
  Future<String?> getClipboardHtml() => _hostApi.getClipboardHtml();

  @override
  Future<void> copyHtmlToClipboard(String html) =>
      _hostApi.copyHtmlToClipboard(html);

  @override
  Future<Uint8List?> getClipboardImage() => _hostApi.getClipboardImage();

  @override
  Future<void> copyImageToClipboard(Uint8List imageBytes) =>
      _hostApi.copyImageToClipboard(imageBytes);

  @override
  Future<Uint8List?> getClipboardGif() => _hostApi.getClipboardGif();

  @override
  Future<void> openGalleryApp() => _hostApi.openGalleryApp();

  @override
  Future<void> saveImageToGallery(
    Uint8List imageBytes, {
    required GalleryImageSaveOptions options,
  }) async {
    try {
      await _hostApi.saveImageToGallery(imageBytes,
          name: options.name, albumName: options.albumName);
    } on PlatformException catch (e) {
      assert(() {
        if (e.code == 'IOS_INFO_PLIST_NOT_CONFIGURED') {
          throw StateError(
            '\nThe Info.plist file was not configured to support saving images to the gallery on iOS.\n'
            'For more details, refer to https://pub.dev/packages/quill_native_bridge#-saving-images-to-the-gallery\n'
            'This exception will be only thrown in debug mode.\n\n'
            'Platform error details: ${e.toString()}',
          );
        }
        return true;
      }());

      rethrow;
    }
  }
}
