import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'assets.dart';
import 'cupertino.dart';

class ExampleImage {
  const ExampleImage({
    required this.assetPath,
    required this.description,
  });

  final String assetPath;
  final String description;

  String get fileType => assetPath.split('.').last;
}

const List<ExampleImage> _images = [
  ExampleImage(
      assetPath: kFlutterQuillAssetImage, description: '(PNG) Flutter Quill'),
  ExampleImage(
      assetPath: kQuillJsRichTextEditor, description: '(PNG) Quill JS'),
  ExampleImage(
      assetPath: kIntroducingFlutter, description: '(JPG) Introducing Flutter'),
  ExampleImage(
      assetPath: kFlutterCasualGamesToolkit,
      description: '(WEBp) Flutter Casual Games Toolkit'),
  ExampleImage(assetPath: kLoading, description: '(GIF) Loading'),
];

class SelectImageDialog extends StatelessWidget {
  const SelectImageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: const Text('Choose an image'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _images
              .map((image) => usesCupertino
                  ? CupertinoListTile(
                      title: Text(image.description),
                      leading:
                          Image.asset(image.assetPath, width: 50, height: 50),
                      onTap: () => Navigator.pop<ExampleImage>(context, image),
                    )
                  : ListTile(
                      title: Text(image.description),
                      leading:
                          Image.asset(image.assetPath, width: 50, height: 50),
                      onTap: () => Navigator.pop<ExampleImage>(context, image),
                    ))
              .toList(),
        ),
      ),
      actions: [
        AdaptiveDialogAction(
          onPressed: () => Navigator.pop(context, null),
          child: const Text('Cancel', textAlign: TextAlign.end),
        ),
      ],
    );
  }
}

Future<ExampleImage?> showSelectImageDialog({
  required BuildContext context,
}) =>
    showAdaptiveDialog<ExampleImage?>(
      context: context,
      builder: (context) => const SelectImageDialog(),
    );
