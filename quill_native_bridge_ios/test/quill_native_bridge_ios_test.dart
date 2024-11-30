import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:quill_native_bridge_ios/quill_native_bridge_ios.dart';
import 'package:quill_native_bridge_platform_interface/quill_native_bridge_platform_interface.dart';

import 'test_api.g.dart';

@GenerateMocks([TestQuillNativeBridgeApi])
import 'quill_native_bridge_ios_test.mocks.dart';

void main() {
  // Required when calling TestQuillNativeBridgeApi.setUp()
  TestWidgetsFlutterBinding.ensureInitialized();

  late QuillNativeBridgeIos plugin;
  late MockTestQuillNativeBridgeApi mockHostApi;

  setUp(() {
    plugin = QuillNativeBridgeIos();
    mockHostApi = MockTestQuillNativeBridgeApi();
    TestQuillNativeBridgeApi.setUp(mockHostApi);

    when(mockHostApi.openGalleryApp()).thenAnswer((_) async {});
    when(mockHostApi.saveImageToGallery(
      any,
      name: anyNamed('name'),
      albumName: anyNamed('albumName'),
    )).thenAnswer((_) async {});
  });

  test('registered instance', () {
    QuillNativeBridgeIos.registerWith();
    expect(QuillNativeBridgePlatform.instance, isA<QuillNativeBridgeIos>());
  });

  test(
    'isIOSSimulator delegates to _hostApi.isIOSSimulator',
    () async {
      when(mockHostApi.isIosSimulator()).thenReturn(false);
      final result = await plugin.isIOSSimulator();
      verify(mockHostApi.isIosSimulator()).called(1);
      expect(result, isFalse);

      when(mockHostApi.isIosSimulator()).thenReturn(true);
      final result2 = await plugin.isIOSSimulator();
      verify(mockHostApi.isIosSimulator()).called(1);
      expect(result2, isTrue);
    },
  );

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

          final exampleHtml = 'An HTML';

          when(mockHostApi.getClipboardHtml()).thenReturn(exampleHtml);
          final nonNullHtml = await plugin.getClipboardHtml();
          verify(mockHostApi.getClipboardHtml()).called(1);
          expect(nonNullHtml, equals(exampleHtml));
        },
      );

      test(
        'copyHtmlToClipboard delegates to _hostApi.copyHtmlToClipboard',
        () async {
          final input = 'Example HTML';
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
          await plugin.saveImageToGallery(
            Uint8List.fromList([1, 0, 1]),
            options: GalleryImageSaveOptions(
              name: 'ExampleImage',
              fileExtension: 'png',
              albumName: null,
            ),
          );
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
          final imageName = 'ExampleImage';
          final imageAlbumName = 'ExampleAlbum';

          when(mockHostApi.saveImageToGallery(
            imageBytes,
            name: anyNamed('name'),
            albumName: anyNamed('albumName'),
          )).thenAnswer((_) async => null);

          await plugin.saveImageToGallery(imageBytes,
              options: GalleryImageSaveOptions(
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
                  options: GalleryImageSaveOptions(
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
            'IOS_INFO_PLIST_NOT_CONFIGURED',
            containsMessage:
                'The Info.plist file was not configured to support saving images to the gallery on iOS.',
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
            options: GalleryImageSaveOptions(
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
        )).thenAnswer((_) async {});
        await expectLater(
          plugin.saveImageToGallery(Uint8List.fromList([1, 0, 1]),
              options: GalleryImageSaveOptions(
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
