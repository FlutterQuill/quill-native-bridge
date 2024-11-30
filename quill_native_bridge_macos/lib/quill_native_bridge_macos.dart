// This file is referenced by pubspec.yaml. If you plan on moving this file
// Make sure to update pubspec.yaml to the new location.

import 'package:flutter/services.dart';
import 'package:quill_native_bridge_platform_interface/quill_native_bridge_platform_interface.dart';

import 'src/messages.g.dart';

/// An implementation of [QuillNativeBridgePlatform] for macOS.
class QuillNativeBridgeMacOS extends QuillNativeBridgePlatform {
  final QuillNativeBridgeApi _hostApi = QuillNativeBridgeApi();

  /// Registers this class as the default instance of [QuillNativeBridgePlatform].
  static void registerWith() {
    QuillNativeBridgePlatform.instance = QuillNativeBridgeMacOS();
  }

  @override
  Future<bool> isSupported(QuillNativeBridgeFeature feature) async {
    if (feature == QuillNativeBridgeFeature.saveImageToGallery) {
      return await _hostApi.supportsGallerySave();
    }
    return {
      QuillNativeBridgeFeature.getClipboardHtml,
      QuillNativeBridgeFeature.copyHtmlToClipboard,
      QuillNativeBridgeFeature.copyImageToClipboard,
      QuillNativeBridgeFeature.getClipboardImage,
      QuillNativeBridgeFeature.getClipboardFiles,
      QuillNativeBridgeFeature.openGalleryApp,
      QuillNativeBridgeFeature.saveImage,
    }.contains(feature);
  }

  @override
  Future<bool> isIOSSimulator() => throw UnsupportedError(
        'isIOSSimulator() is only supported on iOS.',
      );

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
  Future<List<String>> getClipboardFiles() => _hostApi.getClipboardFiles();

  @override
  Future<void> openGalleryApp() => _hostApi.openGalleryApp();

  @override
  Future<void> saveImageToGallery(
    Uint8List imageBytes, {
    required String name,
    required String extension,
    required String? albumName,
  }) async {
    try {
      await _hostApi.saveImageToGallery(imageBytes,
          name: name, albumName: albumName);
    } on PlatformException catch (e) {
      if (e.code == 'UNSUPPORTED') {
        throw UnsupportedError(
            'Saving an image to the gallery is not supported on this macOS version. Check before calling this method. Platform Details: ${e.toString()}');
      }
      assert(() {
        if (e.code == 'PERMISSION_DENIED') {
          throw StateError(
            'Insufficient permission to save the image to the gallery.\n\n'
            '''
===============================================================
                    Possible Issue Details
===============================================================
'''
            '\nApple macOS imposes security restrictions. If the app is running using sources other than Xcode or macOS terminal such as Android Studio or VS Code\n'
            'then this issue might be encountered.\n'
            'If the issue was encountered even with Xcode and you did not explicitly deny the requested permission,\n'
            'consider filing an issue to https://github.com/FlutterQuill/quill-native-bridge\n\n'
            '''
===============================================================
                    Important Information
===============================================================
'''
            '\nThis exception will be only thrown in development mode.\n'
            'If you have explicitly denied the requested permission or run on Xcode / macOS terminal without this issue,\n'
            'then you can ignore this error since it is not applicable in the production app.\n\n'
            'For more details, refer to: https://pub.dev/packages/quill_native_bridge#-saving-images-to-the-gallery\n'
            'Platform error details: ${e.toString()}',
          );
        } else if (e.code == 'MACOS_INFO_PLIST_NOT_CONFIGURED') {
          throw StateError(
            '\nThe Info.plist file was not configured to support saving images to the gallery on macOS.\n'
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

  @override
  Future<String?> saveImage(
    Uint8List imageBytes, {
    required String name,
    required String extension,
  }) =>
      _hostApi.saveImage(imageBytes, name: name, extension: extension);
}
