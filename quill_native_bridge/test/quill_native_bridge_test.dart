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

          final result = await QuillNativeBridge.isSupported(exampleFeature);
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

          await QuillNativeBridge.isSupported(feature);
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
      final result = await QuillNativeBridge.isIOSSimulator();
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
      final result = await QuillNativeBridge.getClipboardHtml();
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

      await QuillNativeBridge.copyHtmlToClipboard(exampleHtml);
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

      await QuillNativeBridge.copyImageToClipboard(imageBytes);
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
    final result = await QuillNativeBridge.getClipboardImage();
    verify(mockQuillNativeBridgePlatform.getClipboardImage()).called(1);
    expect(result, imageBytes);
  });

  test('getClipboardGif returns correct value based on platform implementation',
      () async {
    final imageBytes = Uint8List.fromList([1, 0, 1]);
    when(mockQuillNativeBridgePlatform.getClipboardGif())
        .thenAnswer((_) async => imageBytes);
    final result = await QuillNativeBridge.getClipboardGif();
    verify(mockQuillNativeBridgePlatform.getClipboardGif()).called(1);
    expect(result, imageBytes);
  });

  test(
      'getClipboardFiles returns correct value based on platform implementation',
      () async {
    final clipboardFiles = ['/path/to/file', '/foo/bar'];
    when(mockQuillNativeBridgePlatform.getClipboardFiles())
        .thenAnswer((_) async => clipboardFiles);
    final result = await QuillNativeBridge.getClipboardFiles();
    verify(mockQuillNativeBridgePlatform.getClipboardFiles()).called(1);
    expect(result, clipboardFiles);
  });

  test(
    'openGalleryApp calls platform implementation',
    () async {
      when(mockQuillNativeBridgePlatform.openGalleryApp())
          .thenAnswer((_) async {});

      await QuillNativeBridge.openGalleryApp();
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
            name: anyNamed('name'),
            albumName: anyNamed('albumName'),
            extension: anyNamed('extension'),
          )).thenAnswer((_) async {});

          await QuillNativeBridge.saveImageToGallery(
            Uint8List.fromList([0, 1, 0]),
            name: 'ExampleImage',
            albumName: 'ExampleAlbum',
            extension: 'jpg',
          );
          verify(mockQuillNativeBridgePlatform.saveImageToGallery(
            any,
            name: anyNamed('name'),
            albumName: anyNamed('albumName'),
            extension: anyNamed('extension'),
          )).called(1);
        },
      );
      test('passes the arguments to the platform implementation correctly',
          () async {
        final imageBytes = Uint8List.fromList([0, 1, 0]);
        const imageName = 'Example Image';
        const albumName = 'AnAlbum';
        const imageFileExtension = 'jpg';

        when(mockQuillNativeBridgePlatform.saveImageToGallery(
          any,
          name: anyNamed('name'),
          albumName: anyNamed('albumName'),
          extension: anyNamed('extension'),
        )).thenAnswer((_) async {});

        await QuillNativeBridge.saveImageToGallery(
          imageBytes,
          name: imageName,
          albumName: albumName,
          extension: imageFileExtension,
        );
        final capturedOptions =
            verify(mockQuillNativeBridgePlatform.saveImageToGallery(
          captureAny,
          name: captureAnyNamed('name'),
          albumName: captureAnyNamed('albumName'),
          extension: captureAnyNamed('extension'),
        )).captured;

        expect(capturedOptions[0] as Uint8List, imageBytes);
        expect(capturedOptions[1] as String, imageName);
        expect(capturedOptions[2] as String, albumName);
        expect(capturedOptions[3] as String, imageFileExtension);
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
            name: anyNamed('name'),
            extension: anyNamed('extension'),
          )).thenAnswer((_) async => null);

          await QuillNativeBridge.saveImage(
            Uint8List.fromList([0, 1, 0]),
            name: 'ExampleImage',
            extension: 'jpg',
          );
          verify(mockQuillNativeBridgePlatform.saveImage(
            any,
            name: anyNamed('name'),
            extension: anyNamed('extension'),
          )).called(1);
        },
      );
      test('passes the arguments to the platform implementation correctly',
          () async {
        final imageBytes = Uint8List.fromList([0, 1, 0]);
        const imageName = 'Example Image';

        const imageFileExtension = 'jpg';

        when(mockQuillNativeBridgePlatform.saveImage(
          any,
          name: anyNamed('name'),
          extension: anyNamed('extension'),
        )).thenAnswer((_) async => null);

        await QuillNativeBridge.saveImage(
          imageBytes,
          name: imageName,
          extension: imageFileExtension,
        );
        final capturedOptions = verify(mockQuillNativeBridgePlatform.saveImage(
          captureAny,
          name: captureAnyNamed('name'),
          extension: captureAnyNamed('extension'),
        )).captured;

        expect(capturedOptions[0] as Uint8List, imageBytes);
        expect(capturedOptions[1] as String, imageName);
        expect(capturedOptions[2] as String, imageFileExtension);
      });
    },
  );
}
