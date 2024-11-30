import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/src/messages.g.dart',
  dartTestOut: 'test/test_api.g.dart',
  swiftOut:
      'ios/quill_native_bridge_ios/Sources/quill_native_bridge_ios/Messages.g.swift',
  dartPackageName: 'quill_native_bridge_ios',
))
@HostApi(dartHostTestHandler: 'TestQuillNativeBridgeApi')
abstract class QuillNativeBridgeApi {
  bool isIosSimulator();

  // HTML
  String? getClipboardHtml();
  void copyHtmlToClipboard(String html);

  // Image
  Uint8List? getClipboardImage();
  void copyImageToClipboard(Uint8List imageBytes);
  Uint8List? getClipboardGif();

  @async
  void openGalleryApp();

  @async
  void saveImageToGallery(
    Uint8List imageBytes, {
    required String name,
    required String? albumName,
  });
}
