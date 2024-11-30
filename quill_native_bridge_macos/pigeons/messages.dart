import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/src/messages.g.dart',
  dartTestOut: 'test/test_api.g.dart',
  swiftOut:
      'macos/quill_native_bridge_macos/Sources/quill_native_bridge_macos/Messages.g.swift',
  dartPackageName: 'quill_native_bridge_macos',
))
@HostApi(dartHostTestHandler: 'TestQuillNativeBridgeApi')
abstract class QuillNativeBridgeApi {
  // HTML
  String? getClipboardHtml();
  void copyHtmlToClipboard(String html);

  // Image
  Uint8List? getClipboardImage();
  void copyImageToClipboard(Uint8List imageBytes);
  Uint8List? getClipboardGif();

  // File
  List<String> getClipboardFiles();

  void openGalleryApp();

  /// Supports macOS 10.15 and later
  bool supportsGallerySave();

  @async
  void saveImageToGallery(
    Uint8List imageBytes, {
    required String name,
    required String? albumName,
  });

  @async
  String? saveImage(
    Uint8List imageBytes, {
    required String name,
    required String extension,
  });
}
