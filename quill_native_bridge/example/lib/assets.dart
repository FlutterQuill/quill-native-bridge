import 'package:flutter/services.dart' show Uint8List, rootBundle;

const kFlutterQuillAssetImage = 'assets/flutter-quill.png';
const kQuillJsRichTextEditor = 'assets/quilljs-rich-text-editor.png';
const kFlutterCasualGamesToolkit = 'assets/flutter-casual-games-toolkit.webp';
const kIntroducingFlutter = 'assets/introducing-flutter.jpg';
const kLoading = 'assets/loading.gif';

Future<Uint8List> loadAssetFile(String assetFilePath) async {
  return (await rootBundle.load(assetFilePath)).buffer.asUint8List();
}
