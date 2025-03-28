import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:quill_native_bridge_android/quill_native_bridge_android.dart';
import 'package:quill_native_bridge_platform_interface/quill_native_bridge_platform_interface.dart';
import 'package:quill_native_bridge_platform_interface/src/image_mime_utils.dart';

@GenerateMocks([TestQuillNativeBridgeApi])
import 'quill_native_bridge_android_test.mocks.dart';
import 'test_api.g.dart';

void main() {
  // Required when calling TestQuillNativeBridgeApi.setUp()
  TestWidgetsFlutterBinding.ensureInitialized();

  late QuillNativeBridgeAndroid plugin;
  late MockTestQuillNativeBridgeApi mockHostApi;

  setUp(() {
    plugin = QuillNativeBridgeAndroid();
    mockHostApi = MockTestQuillNativeBridgeApi();
    TestQuillNativeBridgeApi.setUp(mockHostApi);

    when(mockHostApi.openGalleryApp()).thenAnswer((_) async {});
    when(mockHostApi.saveImageToGallery(
      any,
      name: anyNamed('name'),
      albumName: anyNamed('albumName'),
      fileExtension: anyNamed('fileExtension'),
      mimeType: anyNamed('mimeType'),
    )).thenAnswer((_) async {});
  });

  test('registered instance', () {
    QuillNativeBridgeAndroid.registerWith();
    expect(QuillNativeBridgePlatform.instance, isA<QuillNativeBridgeAndroid>());
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
        'copyImageToClipboard throws $StateError in debug mode when AndroidManifest.xml is not configured',
        () async {
          when(mockHostApi.copyImageToClipboard(any)).thenThrow(
              PlatformException(code: 'ANDROID_MANIFEST_NOT_CONFIGURED'));
          await expectLater(
            plugin.copyImageToClipboard(Uint8List.fromList([])),
            throwsA(isA<StateError>().having(
              (e) => e.message,
              'message',
              contains(
                  'The AndroidManifest.xml file was not configured to support copying images to the clipboard on Android'),
            )),
          );
        },
      );

      test(
        'getClipboardImage returns null in case of Android file access read denied',
        () async {
          when(mockHostApi.getClipboardImage()).thenThrow(
              PlatformException(code: 'FILE_READ_PERMISSION_DENIED'));
          final image = await plugin.getClipboardImage();
          expect(image, isNull);

          when(mockHostApi.getClipboardGif()).thenThrow(
              PlatformException(code: 'FILE_READ_PERMISSION_DENIED'));
          final gif = await plugin.getClipboardGif();
          expect(gif, isNull);
        },
      );

      test(
        'getClipboardImage returns null in case of Android file not found error',
        () async {
          when(mockHostApi.getClipboardImage())
              .thenThrow(PlatformException(code: 'FILE_NOT_FOUND'));
          final result = await plugin.getClipboardImage();
          expect(result, isNull);

          when(mockHostApi.getClipboardGif())
              .thenThrow(PlatformException(code: 'FILE_NOT_FOUND'));
          final gif = await plugin.getClipboardGif();
          expect(gif, isNull);
        },
      );
    },
  );

  group('gallery', () {
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
            fileExtension: anyNamed('fileExtension'),
            albumName: anyNamed('albumName'),
            mimeType: anyNamed('mimeType'),
          )).called(1);
        },
      );

      test(
        'passes the arguments correctly to the platform host API',
        () async {
          final imageBytes = Uint8List.fromList([1, 0, 1]);

          const options = GalleryImageSaveOptions(
            name: 'ExampleImage',
            fileExtension: 'jpg',
            albumName: 'ExampleAlbum',
          );

          when(mockHostApi.saveImageToGallery(
            imageBytes,
            name: anyNamed('name'),
            albumName: anyNamed('albumName'),
            fileExtension: anyNamed('fileExtension'),
            mimeType: anyNamed('mimeType'),
          )).thenAnswer((_) async {});

          await plugin.saveImageToGallery(imageBytes, options: options);

          final capturedOptions = verify(mockHostApi.saveImageToGallery(
            captureAny,
            name: captureAnyNamed('name'),
            albumName: captureAnyNamed('albumName'),
            fileExtension: captureAnyNamed('fileExtension'),
            mimeType: captureAnyNamed('mimeType'),
          )).captured;

          expect(capturedOptions[0] as Uint8List, imageBytes);
          expect(capturedOptions[1] as String, options.name);
          expect(capturedOptions[2] as String, options.albumName);
          expect(capturedOptions[3] as String, options.fileExtension);
          expect(capturedOptions[4] as String,
              getImageMimeType(options.fileExtension));
        },
      );

      test(
        'passes the mime type correctly to the platform host API',
        () async {
          const options = GalleryImageSaveOptions(
            name: 'ImageName',
            // IMPORTANT: Use jpg specifically instead of jpeg or png
            // since the "image/jpg" is invalid and it will verify behavior,
            // ensuring the mimeType is passed correctly.
            fileExtension: 'jpg',
            albumName: 'ExampleAlbum',
          );
          await plugin.saveImageToGallery(Uint8List.fromList([]),
              options: options);

          final capturedOptions = verify(mockHostApi.saveImageToGallery(
            any,
            name: anyNamed('name'),
            albumName: anyNamed('albumName'),
            fileExtension: anyNamed('fileExtension'),
            mimeType: captureAnyNamed('mimeType'),
          )).captured;
          expect(
            capturedOptions[0] as String,
            getImageMimeType(options.fileExtension),
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
              fileExtension: anyNamed('fileExtension'),
              mimeType: anyNamed('mimeType'),
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

          expectThrowsForCode('ANDROID_MANIFEST_NOT_CONFIGURED',
              containsMessage:
                  'The AndroidManifest.xml file was not configured to support saving images to the gallery on Android 9 (API 28).');
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
          fileExtension: anyNamed('fileExtension'),
          mimeType: anyNamed('mimeType'),
        )).thenThrow(PlatformException(code: errorCode));
        expect(
          plugin.saveImageToGallery(
            Uint8List.fromList([1, 0, 1]),
            options: const GalleryImageSaveOptions(
              name: 'ExampleImage',
              fileExtension: 'png',
              albumName: null,
            ),
          ),
          throwsA(isA<PlatformException>()
              .having((e) => e.code, 'code', errorCode)),
        );

        when(mockHostApi.saveImageToGallery(
          any,
          name: anyNamed('name'),
          albumName: anyNamed('albumName'),
          fileExtension: anyNamed('fileExtension'),
          mimeType: anyNamed('mimeType'),
        )).thenAnswer((_) async {});
        await expectLater(
          plugin.saveImageToGallery(Uint8List.fromList([1, 0, 1]),
              options: const GalleryImageSaveOptions(
                name: 'ExampleImage',
                fileExtension: 'png',
                albumName: null,
              )),
          completes,
        );
      });
    });
  });
}
