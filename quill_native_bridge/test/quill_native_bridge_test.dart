import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:quill_native_bridge/quill_native_bridge.dart';
import 'package:quill_native_bridge_platform_interface/quill_native_bridge_platform_interface.dart';

@GenerateMocks([], customMocks: [MockSpec<QuillNativeBridgePlatform>()])
import 'quill_native_bridge_test.mocks.dart' as base_mock;

// Add the mixin to make the platform interface accept the mock.
// For more details, refer to https://pub.dev/packages/plugin_platform_interface#mocking-or-faking-platform-interfaces
class _MockQuillNativeBridgePlatform extends base_mock
    .MockQuillNativeBridgePlatform with MockPlatformInterfaceMixin {}

void main() {
  final plugin = QuillNativeBridge();
  late _MockQuillNativeBridgePlatform mockQuillNativeBridgePlatform;

  setUp(() {
    mockQuillNativeBridgePlatform = _MockQuillNativeBridgePlatform();

    QuillNativeBridgePlatform.instance = mockQuillNativeBridgePlatform;
  });

  group('isSupported', () {
    test(
      'returns correct value based on platform implementation',
      () async {
        for (final isSupported in {true, false}) {
          const exampleFeature = QuillNativeBridgeFeature.isIOSSimulator;
          when(mockQuillNativeBridgePlatform.isSupported(exampleFeature))
              .thenAnswer((_) async => isSupported);

          final result = await plugin.isSupported(exampleFeature);
          verify(mockQuillNativeBridgePlatform.isSupported(exampleFeature))
              .called(1);
          expect(result, isSupported);
        }
      },
    );

    test(
      'passes the $QuillNativeBridgeFeature correctly to the platform implementation',
      () async {
        for (final feature in QuillNativeBridgeFeature.values) {
          when(mockQuillNativeBridgePlatform.isSupported(any))
              .thenAnswer((_) async => false);

          await plugin.isSupported(feature);
          verify(mockQuillNativeBridgePlatform.isSupported(feature)).called(1);
        }
      },
    );
  });

  test('isIOSSimulator returns correct value based on platform implementation',
      () async {
    for (final isSimulator in {true, false}) {
      when(mockQuillNativeBridgePlatform.isIOSSimulator())
          .thenAnswer((_) async => isSimulator);
      final result = await plugin.isIOSSimulator();
      verify(mockQuillNativeBridgePlatform.isIOSSimulator()).called(1);
      expect(result, isSimulator);
    }
  });

  test(
      'getClipboardHtml returns correct value based on platform implementation',
      () async {
    for (final html in {'<center></center>', '<html></html>'}) {
      when(mockQuillNativeBridgePlatform.getClipboardHtml())
          .thenAnswer((_) async => html);
      final result = await plugin.getClipboardHtml();
      verify(mockQuillNativeBridgePlatform.getClipboardHtml()).called(1);
      expect(result, html);
    }
  });

  test(
    'copyHtmlToClipboard passes the HTML correctly to the platform implementation',
    () async {
      const exampleHtml = '<body></body>';
      when(mockQuillNativeBridgePlatform.copyHtmlToClipboard(any))
          .thenAnswer((_) async {});

      await plugin.copyHtmlToClipboard(exampleHtml);
      verify(mockQuillNativeBridgePlatform.copyHtmlToClipboard(exampleHtml))
          .called(1);
    },
  );

  test(
    'copyImageToClipboard passes the image bytes correctly to the platform implementation',
    () async {
      final imageBytes = Uint8List.fromList([1, 0, 1]);
      when(mockQuillNativeBridgePlatform.copyImageToClipboard(any))
          .thenAnswer((_) async {});

      await plugin.copyImageToClipboard(imageBytes);
      verify(mockQuillNativeBridgePlatform.copyImageToClipboard(imageBytes))
          .called(1);
    },
  );

  test(
      'getClipboardImage returns correct value based on platform implementation',
      () async {
    final imageBytes = Uint8List.fromList([1, 0, 1]);
    when(mockQuillNativeBridgePlatform.getClipboardImage())
        .thenAnswer((_) async => imageBytes);
    final result = await plugin.getClipboardImage();
    verify(mockQuillNativeBridgePlatform.getClipboardImage()).called(1);
    expect(result, imageBytes);
  });

  test('getClipboardGif returns correct value based on platform implementation',
      () async {
    final imageBytes = Uint8List.fromList([1, 0, 1]);
    when(mockQuillNativeBridgePlatform.getClipboardGif())
        .thenAnswer((_) async => imageBytes);
    final result = await plugin.getClipboardGif();
    verify(mockQuillNativeBridgePlatform.getClipboardGif()).called(1);
    expect(result, imageBytes);
  });

  test(
      'getClipboardFiles returns correct value based on platform implementation',
      () async {
    final clipboardFiles = ['/path/to/file', '/foo/bar'];
    when(mockQuillNativeBridgePlatform.getClipboardFiles())
        .thenAnswer((_) async => clipboardFiles);
    final result = await plugin.getClipboardFiles();
    verify(mockQuillNativeBridgePlatform.getClipboardFiles()).called(1);
    expect(result, clipboardFiles);
  });

  test(
    'openGalleryApp calls platform implementation',
    () async {
      when(mockQuillNativeBridgePlatform.openGalleryApp())
          .thenAnswer((_) async {});

      await plugin.openGalleryApp();
      verify(mockQuillNativeBridgePlatform.openGalleryApp()).called(1);
    },
  );

  group(
    'saveImageToGallery',
    () {
      test(
        'calls platform implementation',
        () async {
          when(mockQuillNativeBridgePlatform.saveImageToGallery(
            any,
            options: anyNamed('options'),
          )).thenAnswer((_) async {});

          await plugin.saveImageToGallery(
            Uint8List.fromList([0, 1, 0]),
            options: const GalleryImageSaveOptions(
              name: 'ExampleImage',
              albumName: 'ExampleAlbum',
              fileExtension: 'jpg',
            ),
          );
          verify(mockQuillNativeBridgePlatform.saveImageToGallery(
            any,
            options: anyNamed('options'),
          )).called(1);
        },
      );
      test('passes the arguments to the platform implementation correctly',
          () async {
        final imageBytes = Uint8List.fromList([0, 1, 0]);
        const options = GalleryImageSaveOptions(
            name: 'Example Image', fileExtension: 'jpg', albumName: 'AnAlbum');

        when(mockQuillNativeBridgePlatform.saveImageToGallery(
          any,
          options: anyNamed('options'),
        )).thenAnswer((_) async {});

        await plugin.saveImageToGallery(
          imageBytes,
          options: options,
        );
        final capturedOptions =
            verify(mockQuillNativeBridgePlatform.saveImageToGallery(
          captureAny,
          options: captureAnyNamed('options'),
        )).captured;

        expect(capturedOptions[0] as Uint8List, imageBytes);
        expect(capturedOptions[1] as GalleryImageSaveOptions, options);
      });
    },
  );

  group(
    'saveImage',
    () {
      test(
        'calls platform implementation',
        () async {
          when(mockQuillNativeBridgePlatform.saveImage(
            any,
            options: anyNamed('options'),
          )).thenAnswer((_) async => ImageSaveResult.io(filePath: null));

          await plugin.saveImage(Uint8List.fromList([0, 1, 0]),
              options: const ImageSaveOptions(
                  name: 'ExampleImage', fileExtension: 'jpg'));
          verify(mockQuillNativeBridgePlatform.saveImage(
            any,
            options: anyNamed('options'),
          )).called(1);
        },
      );
      test('passes the arguments to the platform implementation correctly',
          () async {
        final imageBytes = Uint8List.fromList([0, 1, 0]);

        const options =
            ImageSaveOptions(name: 'Example Image', fileExtension: 'jpg');

        when(mockQuillNativeBridgePlatform.saveImage(
          any,
          options: anyNamed('options'),
        )).thenAnswer((_) async => ImageSaveResult.io(filePath: null));

        await plugin.saveImage(
          imageBytes,
          options: options,
        );
        final capturedOptions = verify(mockQuillNativeBridgePlatform.saveImage(
          captureAny,
          options: captureAnyNamed('options'),
        )).captured;

        expect(capturedOptions[0] as Uint8List, imageBytes);
        expect(capturedOptions[1] as ImageSaveOptions, options);
      });
    },
  );
}
