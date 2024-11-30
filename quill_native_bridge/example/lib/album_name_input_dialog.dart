import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'cupertino.dart';

/// Platforms that require full permission access to the gallery to save an image to an album.
final _albumRequiresAppleReadWritePermission = {
      TargetPlatform.iOS,
      TargetPlatform.macOS
    }.contains(defaultTargetPlatform) &&
    !kIsWeb;

class AlbumNameInputDialog extends StatefulWidget {
  const AlbumNameInputDialog({super.key});

  @override
  State<AlbumNameInputDialog> createState() => _AlbumNameInputDialogState();
}

class _AlbumNameInputDialogState extends State<AlbumNameInputDialog> {
  final TextEditingController _albumNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: const Text('Saving to Gallery'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_albumRequiresAppleReadWritePermission) ...[
            const Text(
                'Specifying the album requires read-write permission on iOS / macOS even when add-only permission is available (iOS 14 / macOS 11 and newer).'),
            const SizedBox(height: 6)
          ],
          usesCupertino
              ? CupertinoTextField.borderless(
                  controller: _albumNameController,
                  placeholder: 'Album name',
                )
              : TextField(
                  controller: _albumNameController,
                  decoration: const InputDecoration(
                      hintText: 'Album name', labelText: 'Album name'),
                )
        ],
      ),
      actions: [
        AdaptiveDialogAction(
          onPressed: () => Navigator.pop(context, null),
          child: const Text('Cancel', textAlign: TextAlign.end),
        ),
        AdaptiveDialogAction(
          onPressed: () => Navigator.pop(context, _albumNameController.text),
          child: const Text('Confirm', textAlign: TextAlign.end),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _albumNameController.dispose();
    super.dispose();
  }
}

Future<String?> showAlbumNameInputDialog(
    {required BuildContext context}) async {
  final albumName = await showAdaptiveDialog<String?>(
    context: context,
    builder: (context) => const AlbumNameInputDialog(),
  );
  return albumName;
}
