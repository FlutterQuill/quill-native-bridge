import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:quill_native_bridge_macos/quill_native_bridge_macos.dart';
import 'package:quill_native_bridge_platform_interface/quill_native_bridge_platform_interface.dart';

@GenerateMocks([TestQuillNativeBridgeApi])
import 'quill_native_bridge_macos_test.mocks.dart';
import 'test_api.g.dart';

void main() {
  // Required when calling TestQuillNativeBridgeApi.setUp()
  TestWidgetsFlutterBinding.ensureInitialized();

  late QuillNativeBridgeMacOS plugin;
  late MockTestQuillNativeBridgeApi mockHostApi;

  setUp(() {
    plugin = QuillNativeBridgeMacOS();
    mockHostApi = MockTestQuillNativeBridgeApi();
    TestQuillNativeBridgeApi.setUp(mockHostApi);

    when(mockHostApi.openGalleryApp()).thenAnswer((_) async {});
    when(mockHostApi.saveImageToGallery(
      any,
      name: anyNamed('name'),
      albumName: anyNamed('albumName'),
    )).thenAnswer((_) async {});
    when(mockHostApi.saveImage(
      any,
      name: anyNamed('name'),
      fileExtension: anyNamed('fileExtension'),
    )).thenAnswer((_) async => null);
  });

  test('registered instance', () {
    QuillNativeBridgeMacOS.registerWith();
    expect(QuillNativeBridgePlatform.instance, isA<QuillNativeBridgeMacOS>());
  });

  test('isIOSSimulator is not applicable on macOS', () async {
    expect(() async => await plugin.isIOSSimulator(), throwsUnsupportedError);
  });

  group(
    'clipboard',
    () {
      test(
        'getClipboardHtml delegates to _hostApi.getClipboardHtml',
        () async {
          when(mockHostApi.getClipboardHtml()).thenReturn(null);
          final nullHtml = await plugin.getClipboardHtml();
          verify(mockHostApi.getClipboardHtml()).called(1);
          expect(nullHtml, isNull);

          const exampleHtml = 'An HTML';

          when(mockHostApi.getClipboardHtml()).thenReturn(exampleHtml);
          final nonNullHtml = await plugin.getClipboardHtml();
          verify(mockHostApi.getClipboardHtml()).called(1);
          expect(nonNullHtml, equals(exampleHtml));
        },
      );

      test(
        'copyHtmlToClipboard delegates to _hostApi.copyHtmlToClipboard',
        () async {
          const input = 'Example HTML';
          when(mockHostApi.copyHtmlToClipboard(input)).thenReturn(null);
          await plugin.copyHtmlToClipboard(input);
          verify(mockHostApi.copyHtmlToClipboard(input)).called(1);
        },
      );

      test(
        'getClipboardImage delegates to _hostApi.getClipboardImage',
        () async {
          when(mockHostApi.getClipboardImage()).thenReturn(null);
          final nullImage = await plugin.getClipboardImage();
          verify(mockHostApi.getClipboardImage()).called(1);
          expect(nullImage, isNull);

          final exampleImage = Uint8List.fromList([1, 0, 1]);

          when(mockHostApi.getClipboardImage()).thenReturn(exampleImage);
          final nonNullImage = await plugin.getClipboardImage();
          verify(mockHostApi.getClipboardImage()).called(1);
          expect(nonNullImage, equals(exampleImage));
        },
      );

      test(
        'copyImageToClipboard delegates to _hostApi.copyImageToClipboard',
        () async {
          final input = Uint8List.fromList([1, 0, 1]);
          when(mockHostApi.copyImageToClipboard(input)).thenReturn(null);
          await plugin.copyImageToClipboard(input);
          verify(mockHostApi.copyImageToClipboard(input)).called(1);
        },
      );

      test(
        'getClipboardGif delegates to _hostApi.getClipboardGif',
        () async {
          when(mockHostApi.getClipboardGif()).thenReturn(null);
          final nullImage = await plugin.getClipboardGif();
          verify(mockHostApi.getClipboardGif()).called(1);
          expect(nullImage, isNull);

          final exampleImage = Uint8List.fromList([1, 0, 1]);

          when(mockHostApi.getClipboardGif()).thenReturn(exampleImage);
          final nonNullImage = await plugin.getClipboardGif();
          verify(mockHostApi.getClipboardGif()).called(1);
          expect(nonNullImage, equals(exampleImage));
        },
      );

      test(
        'getClipboardFiles delegates to _hostApi.getClipboardFiles',
        () async {
          when(mockHostApi.getClipboardFiles()).thenReturn([]);
          final emptyFiles = await plugin.getClipboardFiles();
          verify(mockHostApi.getClipboardFiles()).called(1);
          expect(emptyFiles, []);

          final exampleFiles = ['/foo/bar', '/path/to/file'];

          when(mockHostApi.getClipboardFiles()).thenReturn(exampleFiles);
          final nonEmptyFiles = await plugin.getClipboardFiles();
          verify(mockHostApi.getClipboardFiles()).called(1);
          expect(nonEmptyFiles, equals(exampleFiles));
        },
      );
    },
  );

  group('gallery', () {
    test(
      'isSupported delegates to _hostApi.supportsGallerySave for ${QuillNativeBridgeFeature.saveImageToGallery}',
      () async {
        when(mockHostApi.supportsGallerySave()).thenReturn(true);
        expect(
            await plugin
                .isSupported(QuillNativeBridgeFeature.saveImageToGallery),
            true);
        verify(mockHostApi.supportsGallerySave()).called(1);

        when(mockHostApi.supportsGallerySave()).thenReturn(false);
        expect(
            await plugin
                .isSupported(QuillNativeBridgeFeature.saveImageToGallery),
            false);
        verify(mockHostApi.supportsGallerySave()).called(1);
      },
    );

    test(
      'openGalleryApp delegates to _hostApi.openGalleryApp',
      () async {
        await plugin.openGalleryApp();
        verify(mockHostApi.openGalleryApp()).called(1);
      },
    );

    group('saveImageToGallery', () {
      test(
        'delegates to _hostApi.saveImageToGallery',
        () async {
          await plugin.saveImageToGallery(Uint8List.fromList([1, 0, 1]),
              options: const GalleryImageSaveOptions(
                name: 'ExampleImage',
                fileExtension: 'png',
                albumName: null,
              ));
          verify(mockHostApi.saveImageToGallery(
            any,
            name: anyNamed('name'),
            albumName: anyNamed('albumName'),
          )).called(1);
        },
      );

      test(
        'passes the arguments correctly to the platform host API',
        () async {
          final imageBytes = Uint8List.fromList([1, 0, 1]);
          const imageName = 'ExampleImage';
          const imageAlbumName = 'ExampleAlbum';

          when(mockHostApi.saveImageToGallery(
            imageBytes,
            name: anyNamed('name'),
            albumName: anyNamed('albumName'),
          )).thenAnswer((_) async {});

          await plugin.saveImageToGallery(imageBytes,
              options: const GalleryImageSaveOptions(
                name: imageName,
                fileExtension: 'png',
                albumName: imageAlbumName,
              ));

          final capturedOptions = verify(mockHostApi.saveImageToGallery(
            captureAny,
            name: captureAnyNamed('name'),
            albumName: captureAnyNamed('albumName'),
          )).captured;

          expect(capturedOptions[0] as Uint8List, imageBytes);
          expect(capturedOptions[1] as String, imageName);
          expect(capturedOptions[2] as String, imageAlbumName);
        },
      );

      test(
        'passes the arguments correctly to the platform host API',
        () async {
          final imageBytes = Uint8List.fromList([1, 0, 1]);
          const options =
              ImageSaveOptions(name: 'ExampleImage', fileExtension: 'png');

          when(mockHostApi.saveImage(
            imageBytes,
            name: anyNamed('name'),
            fileExtension: anyNamed('fileExtension'),
          )).thenAnswer((_) async => null);

          await plugin.saveImage(imageBytes, options: options);

          final capturedOptions = verify(mockHostApi.saveImage(
            captureAny,
            name: captureAnyNamed('name'),
            fileExtension: captureAnyNamed('fileExtension'),
          )).captured;

          expect(capturedOptions[0] as Uint8List, imageBytes);
          expect(capturedOptions[1] as String, options.name);
          expect(capturedOptions[2] as String, options.fileExtension);
        },
      );

      test(
        'throws $UnsupportedError when _hostApi.saveImageToGallery responds as unsupported',
        () async {
          when(mockHostApi.saveImageToGallery(
            any,
            name: anyNamed('name'),
            albumName: anyNamed('albumName'),
          )).thenThrow(PlatformException(code: 'UNSUPPORTED'));
          expect(
            plugin.saveImageToGallery(Uint8List.fromList([1, 0, 1]),
                options: const GalleryImageSaveOptions(
                  name: 'ExampleImage',
                  fileExtension: 'png',
                  albumName: null,
                )),
            throwsUnsupportedError,
          );
        },
      );

      test(
        'throws $StateError in debug mode for common issues',
        () {
          void expectThrowsForCode(String errorCode,
              {required String containsMessage}) {
            when(mockHostApi.saveImageToGallery(
              any,
              name: anyNamed('name'),
              albumName: anyNamed('albumName'),
            )).thenThrow(PlatformException(code: errorCode));
            expect(
              plugin.saveImageToGallery(Uint8List.fromList([1, 0, 1]),
                  options: const GalleryImageSaveOptions(
                    name: 'ExampleImage',
                    fileExtension: 'png',
                    albumName: null,
                  )),
              throwsA(isA<StateError>().having(
                (e) => e.message,
                'message',
                contains(containsMessage),
              )),
            );
          }

          expectThrowsForCode(
            'PERMISSION_DENIED',
            containsMessage:
                'Apple macOS imposes security restrictions. If the app is running using sources other than Xcode or macOS terminal such as Android Studio or VS Code',
          );
          expectThrowsForCode(
            'MACOS_INFO_PLIST_NOT_CONFIGURED',
            containsMessage:
                'The Info.plist file was not configured to support saving images to the gallery on macOS.',
          );
        },
      );

      test(
          'rethrows the $PlatformException from _hostApi.saveImageToGallery if not handled',
          () async {
        // Currently, that's the expected behavior but it is subject to changes for improvements.
        // See https://github.com/FlutterQuill/quill-native-bridge/issues/2

        const errorCode = '404';
        when(mockHostApi.saveImageToGallery(
          any,
          name: anyNamed('name'),
          albumName: anyNamed('albumName'),
        )).thenThrow(PlatformException(code: errorCode));
        expect(
          plugin.saveImageToGallery(
            Uint8List.fromList([1, 0, 1]),
            options: const GalleryImageSaveOptions(
                name: 'ExampleImage', fileExtension: 'png', albumName: null),
          ),
          throwsA(isA<PlatformException>()
              .having((e) => e.code, 'code', errorCode)),
        );

        when(mockHostApi.saveImageToGallery(
          any,
          name: anyNamed('name'),
          albumName: anyNamed('albumName'),
        )).thenAnswer((_) async {});
        await expectLater(
          plugin.saveImageToGallery(
            Uint8List.fromList([1, 0, 1]),
            options: const GalleryImageSaveOptions(
              name: 'ExampleImage',
              fileExtension: 'png',
              albumName: null,
            ),
          ),
          completes,
        );
      });
    });

    test(
      'saveImage delegates to _hostApi.saveImage',
      () async {
        await plugin.saveImage(Uint8List.fromList([1, 0, 1]),
            options: const ImageSaveOptions(
              name: 'ExampleImage',
              fileExtension: 'png',
            ));
        verify(mockHostApi.saveImage(
          any,
          name: anyNamed('name'),
          fileExtension: anyNamed('fileExtension'),
        )).called(1);
      },
    );

    test(
      'saveImage always passes null to blob URL on non-web platforms',
      () async {
        final result = await plugin.saveImage(Uint8List.fromList([1, 0, 1]),
            options: const ImageSaveOptions(
              name: 'ExampleImage',
              fileExtension: 'png',
            ));
        expect(result.blobUrl, isNull);

        const examplePath = 'path/to/file';
        when(mockHostApi.saveImage(
          any,
          name: anyNamed('name'),
          fileExtension: anyNamed('fileExtension'),
        )).thenAnswer((_) async => examplePath);
        final result2 = await plugin.saveImage(Uint8List.fromList([1, 0, 1]),
            options: const ImageSaveOptions(
              name: 'ExampleImage',
              fileExtension: 'png',
            ));
        expect(result2.blobUrl, isNull);
        expect(result2.filePath, examplePath);
      },
    );
  });
}
