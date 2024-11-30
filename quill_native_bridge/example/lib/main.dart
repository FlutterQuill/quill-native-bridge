import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quill_native_bridge/quill_native_bridge.dart';

import 'album_name_input_dialog.dart';
import 'assets.dart';
import 'select_image_dialog.dart';

/// Creates a global instance of [QuillNativeBridge], allowing it to be overridden in tests.
QuillNativeBridge quillNativeBridge = QuillNativeBridge();

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Quill Native Bridge'),
        ),
        body: const SingleChildScrollView(
          child: Center(child: Buttons()),
        ),
      ),
    );
  }
}

class Buttons extends StatelessWidget {
  const Buttons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          kFlutterQuillAssetImage,
          width: 300,
        ),
        const SizedBox(height: 50),
        ElevatedButton.icon(
          onPressed: () => _onButtonPressed(
            QuillNativeBridgeFeature.isIOSSimulator,
            context: context,
          ),
          label: const Text('Is iOS Simulator'),
          icon: const Icon(Icons.apple),
        ),
        ElevatedButton.icon(
          onPressed: () => _onButtonPressed(
            QuillNativeBridgeFeature.getClipboardHtml,
            context: context,
          ),
          label: const Text('Get HTML from Clipboard'),
          icon: const Icon(Icons.html),
        ),
        ElevatedButton.icon(
          onPressed: () => _onButtonPressed(
            QuillNativeBridgeFeature.copyHtmlToClipboard,
            context: context,
          ),
          label: const Text('Copy HTML to Clipboard'),
          icon: const Icon(Icons.copy),
        ),
        ElevatedButton.icon(
          onPressed: () => _onButtonPressed(
            QuillNativeBridgeFeature.copyImageToClipboard,
            context: context,
          ),
          label: const Text('Copy Image to Clipboard'),
          icon: const Icon(Icons.copy),
        ),
        ElevatedButton.icon(
          onPressed: () => _onButtonPressed(
            QuillNativeBridgeFeature.getClipboardImage,
            context: context,
          ),
          label: const Text('Retrieve Image from Clipboard'),
          icon: const Icon(Icons.image),
        ),
        ElevatedButton.icon(
          onPressed: () => _onButtonPressed(
            QuillNativeBridgeFeature.getClipboardGif,
            context: context,
          ),
          label: const Text('Retrieve Gif from Clipboard'),
          icon: const Icon(Icons.gif),
        ),
        ElevatedButton.icon(
          onPressed: () => _onButtonPressed(
            QuillNativeBridgeFeature.getClipboardFiles,
            context: context,
          ),
          label: const Text('Retrieve Files from Clipboard'),
          icon: const Icon(Icons.file_open),
        ),
        ElevatedButton.icon(
          onPressed: () => _onButtonPressed(
            QuillNativeBridgeFeature.openGalleryApp,
            context: context,
          ),
          label: const Text('Open the gallery app'),
          icon: const Icon(Icons.photo_album),
        ),
        ElevatedButton.icon(
          onPressed: () => _onButtonPressed(
            QuillNativeBridgeFeature.saveImageToGallery,
            context: context,
          ),
          label: const Text('Save image to gallery'),
          icon: const Icon(Icons.photo_album),
        ),
        ElevatedButton.icon(
          onPressed: () => _onButtonPressed(
            QuillNativeBridgeFeature.saveImage,
            context: context,
          ),
          label: const Text('Save image'),
          icon: const Icon(Icons.image),
        ),
      ],
    );
  }
}

Future<void> _onButtonPressed(
  QuillNativeBridgeFeature feature, {
  required BuildContext context,
}) async {
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  final isFeatureUnsupported = !(await quillNativeBridge.isSupported(feature));

  switch (feature) {
    case QuillNativeBridgeFeature.isIOSSimulator:
      if (isFeatureUnsupported) {
        scaffoldMessenger.showText(
          kIsWeb
              ? "Can't check if the device is an iOS simulator on the web."
              : 'Available only on iOS to determine if the device is a simulator.',
        );
        return;
      }
      final result = await quillNativeBridge.isIOSSimulator();
      scaffoldMessenger.showText(result
          ? "You're running the app on iOS simulator."
          : "You're running the app on a real iOS device.");
      break;
    case QuillNativeBridgeFeature.getClipboardHtml:
      if (isFeatureUnsupported) {
        scaffoldMessenger.showText(
          kIsWeb
              ? 'Retrieving HTML from the clipboard is currently not supported on the web.'
              : 'Retrieving HTML from the clipboard is currently not supported on ${defaultTargetPlatform.name}.',
        );
        return;
      }
      final result = await quillNativeBridge.getClipboardHtml();
      if (result == null) {
        scaffoldMessenger
            .showText('The HTML is not available on the clipboard.');
        return;
      }
      scaffoldMessenger.showText('HTML from the clipboard: $result');
      debugPrint('HTML from the clipboard: $result');
      break;
    case QuillNativeBridgeFeature.copyHtmlToClipboard:
      if (isFeatureUnsupported) {
        scaffoldMessenger.showText(
          kIsWeb
              ? 'Copying HTML to the clipboard is not supported on the web.'
              : 'Copying HTML to the clipboard is not supported on ${defaultTargetPlatform.name}.',
        );
        return;
      }
      const html = '''
          <strong>Bold text</strong>
          <em>Italic text</em>
          <u>Underlined text</u>
          <span style="color:red;">Red text</span>
          <span style="background-color:yellow;">Highlighted text</span>
        ''';
      await quillNativeBridge.copyHtmlToClipboard(html);
      scaffoldMessenger.showText('HTML copied to the clipboard: $html');
      break;
    case QuillNativeBridgeFeature.copyImageToClipboard:
      if (isFeatureUnsupported) {
        scaffoldMessenger.showText(
          kIsWeb
              ? 'Copying an image to the clipboard is not supported on web.'
              : 'Copying an image to the Clipboard is not supported on ${defaultTargetPlatform.name}.',
        );
        return;
      }
      final imageBytes = await loadAssetFile(kFlutterQuillAssetImage);
      await quillNativeBridge.copyImageToClipboard(imageBytes);

      // Not widely supported but some apps copy the image as text:
      // final file = File(
      //   '${Directory.systemTemp.path}/clipboard-image.png',
      // );
      // await file.create(recursive: true);
      // await file.writeAsBytes(imageBytes);
      // Clipboard.setData(
      //   ClipboardData(
      //     // Currently the Android plugin doesn't support content://
      //     text: 'file://${file.absolute.path}',
      //   ),
      // );

      scaffoldMessenger.showText('Image has been copied to the clipboard.');
      break;
    case QuillNativeBridgeFeature.getClipboardImage:
      if (isFeatureUnsupported) {
        scaffoldMessenger.showText(
          kIsWeb
              ? 'Retrieving an image from the clipboard is currently not supported on web.'
              : 'Retrieving an image from the clipboard is currently not supported on ${defaultTargetPlatform.name}.',
        );
        return;
      }
      final imageBytes = await quillNativeBridge.getClipboardImage();
      if (imageBytes == null) {
        scaffoldMessenger
            .showText('The image is not available on the clipboard.');
        return;
      }
      if (!context.mounted) {
        return;
      }
      showDialog(
        context: context,
        builder: (context) => Dialog(
          child: Image.memory(imageBytes),
        ),
      );
      break;
    case QuillNativeBridgeFeature.getClipboardGif:
      if (isFeatureUnsupported) {
        scaffoldMessenger.showText(
          kIsWeb
              ? 'Retrieving a gif from the clipboard is not supported on web.'
              : 'Retrieving a gif from the clipboard is not supported on ${defaultTargetPlatform.name}.',
        );
        return;
      }
      final gifBytes = await quillNativeBridge.getClipboardGif();
      if (gifBytes == null) {
        scaffoldMessenger.showText(
          'The gif is not available on the clipboard.',
        );
        return;
      }
      if (!context.mounted) {
        return;
      }
      showDialog(
        context: context,
        builder: (context) => Dialog(
          child: Image.memory(gifBytes),
        ),
      );
      break;
    case QuillNativeBridgeFeature.getClipboardFiles:
      if (isFeatureUnsupported) {
        scaffoldMessenger.showText(
          kIsWeb
              ? 'Retrieving files from the clipboard is not supported on web.'
              : 'Retrieving files from the clipboard is not supported on ${defaultTargetPlatform.name}.',
        );
        return;
      }
      final files = await quillNativeBridge.getClipboardFiles();
      if (files.isEmpty) {
        scaffoldMessenger.showText('There are no files on the clipboard.');
        return;
      }
      scaffoldMessenger.showText(
        '${files.length} Files from the clipboard: ${files.toString()}',
      );
      debugPrint('Files from the clipboard: $files');
      break;
    case QuillNativeBridgeFeature.openGalleryApp:
      if (isFeatureUnsupported) {
        scaffoldMessenger.showText(
          kIsWeb
              ? 'Opening the gallery app is not supported on web.'
              : 'Opening the gallery app is not supported on ${defaultTargetPlatform.name}.',
        );
        return;
      }
      await quillNativeBridge.openGalleryApp();
      break;
    case QuillNativeBridgeFeature.saveImageToGallery:
      if (isFeatureUnsupported) {
        scaffoldMessenger.showText(
          kIsWeb
              ? 'Saving an image to the gallery is not supported on web.'
              : 'Saving an image is not supported on ${defaultTargetPlatform.name}.',
        );
        return;
      }

      if (!context.mounted) return;
      final selectedImage = await showSelectImageDialog(context: context);

      if (selectedImage == null) {
        scaffoldMessenger.showText('Image save was canceled.');
        return;
      }
      final imageBytes = await loadAssetFile(selectedImage.assetPath);

      if (!context.mounted) return;
      final albumName = await showAlbumNameInputDialog(context: context);
      if (albumName == null) {
        scaffoldMessenger.showText('Image save was canceled.');
        return;
      }

      await quillNativeBridge.saveImageToGallery(
        imageBytes,
        options: GalleryImageSaveOptions(
          name: selectedImage.description,
          fileExtension: selectedImage.fileType,
          // On iOS and macOS, read-write permission (instead of add-only even when supported) is required to save to an album.
          albumName: albumName.isNotEmpty ? albumName : null,
        ),
      );
      scaffoldMessenger.showText(
        'The image has been saved to the gallery.',
        action: SnackBarAction(
            label: 'Open Gallery', onPressed: quillNativeBridge.openGalleryApp),
      );
      break;
    case QuillNativeBridgeFeature.saveImage:
      if (isFeatureUnsupported) {
        scaffoldMessenger.showText(
          kIsWeb
              ? 'Saving an image is not supported on web.'
              : 'Saving an image is not supported on ${defaultTargetPlatform.name}.',
        );
        return;
      }

      if (!context.mounted) return;
      final selectedImage = await showSelectImageDialog(context: context);

      if (selectedImage == null) {
        scaffoldMessenger.showText('Image save was canceled.');
        return;
      }
      final imageBytes = await loadAssetFile(selectedImage.assetPath);

      final imagePath = (await quillNativeBridge.saveImage(
        imageBytes,
        options: ImageSaveOptions(
          name: selectedImage.description,
          fileExtension: selectedImage.fileType,
        ),
      ))
          .filePath;
      if (!kIsWeb && imagePath == null) {
        scaffoldMessenger.showText('Image save was canceled.');
        return;
      }
      scaffoldMessenger.showText('The image has been saved at: $imagePath.');
      break;
  }
}

extension ScaffoldMessengerX on ScaffoldMessengerState {
  void showText(String text, {SnackBarAction? action}) {
    clearSnackBars();
    showSnackBar(SnackBar(content: Text(text), action: action));
  }
}
