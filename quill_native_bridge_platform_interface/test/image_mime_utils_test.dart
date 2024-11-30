import 'package:flutter_test/flutter_test.dart';
import 'package:quill_native_bridge_platform_interface/src/image_mime_utils.dart';

void main() {
  group('getImageMimeType', () {
    test('returns correct MIME type for jpg', () {
      expect(getImageMimeType('jpg'), equals('image/jpeg'));
    });

    test('returns correct MIME type for jpeg', () {
      expect(getImageMimeType('jpeg'), equals('image/jpeg'));
    });

    test('returns correct MIME type for png', () {
      expect(getImageMimeType('png'), equals('image/png'));
    });

    test('returns correct MIME type for gif', () {
      expect(getImageMimeType('gif'), equals('image/gif'));
    });

    test('returns correct MIME type for bmp', () {
      expect(getImageMimeType('bmp'), equals('image/bmp'));
    });

    test('returns correct MIME type for webp', () {
      expect(getImageMimeType('webp'), equals('image/webp'));
    });

    test('returns correct MIME type for svg', () {
      expect(getImageMimeType('svg'), equals('image/svg+xml'));
    });

    test('throws ArgumentError for unsupported extension', () {
      expect(
          () => getImageMimeType('unsupported'), throwsA(isA<ArgumentError>()));
    });

    test('throws ArgumentError with correct message for unsupported extension',
        () {
      final unsupportedExtension = 'unsupported';

      expect(
        () => getImageMimeType(unsupportedExtension),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          'Unsupported image file extension: $unsupportedExtension.',
        )),
      );
    });
  });
}
