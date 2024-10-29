import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'ensure compatibility by avoiding unresolved image decoder import (See https://github.com/singerdmx/flutter-quill/issues/2340)',
    () {
      // TODO: Avoid hardcoding the `dev/flutterquill/quill_native_bridge/`
      //  in here and in pigeons/messages.dart
      final targetDirectory = Directory(
          'android/src/main/kotlin/dev/flutterquill/quill_native_bridge/');

      expect(targetDirectory.existsSync(), isTrue,
          reason: 'Target directory does not exist: ${targetDirectory.path}');

      for (final entity in targetDirectory.listSync(recursive: true)) {
        if (entity is! File) {
          continue;
        }
        final content = entity.readAsStringSync();
        expect(
          content.contains('import androidx.core.graphics.decodeBitmap'),
          isFalse,
          reason: 'Compatibility issue detected in ${entity.path}. '
              'Avoid using `androidx.core.graphics.decodeBitmap`. '
              'For more details, see https://github.com/FlutterQuill/quill-native-bridge/pull/7',
        );
      }
    },
  );
}
