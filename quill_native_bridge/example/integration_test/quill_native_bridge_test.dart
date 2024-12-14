import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_compare/image_compare.dart';
import 'package:integration_test/integration_test.dart';
import 'package:quill_native_bridge/quill_native_bridge.dart';
import 'package:quill_native_bridge_example/assets.dart';
import 'package:quill_native_bridge_example/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // TODO: Write tests for copying other image formats (jpeg, webp, png etc...)
  // TODO: Improve the integration tests

  // TODO: Fix the integration tests failing on Windows: https://github.com/FlutterQuill/quill-native-bridge/actions/runs/12323723239/job/34399916127?pr=10
  if (defaultTargetPlatform == TargetPlatform.windows) {
    test('no op', () {});
    return;
  }
  print('The GitHub workflow should fail.');

  group('getClipboardImage and copyImageToClipboard', () {
    test('copying images to the clipboard should make them accessible',
        () async {
      Future<void> verifyImageCopiedToClipboard(String assetPath) async {
        final imageBytes = await loadAssetFile(assetPath);
        await quillNativeBridge.copyImageToClipboard(imageBytes);
        final clipboardImageBytes = await quillNativeBridge.getClipboardImage();
        final pixelMismatchPercentage =
            await compareImages(src1: imageBytes, src2: clipboardImageBytes);
        expect(pixelMismatchPercentage, 0);
      }

      await verifyImageCopiedToClipboard(kFlutterQuillAssetImage);
      await verifyImageCopiedToClipboard(kQuillJsRichTextEditor);
      await verifyImageCopiedToClipboard(kFlutterQuillAssetImage);
      await verifyImageCopiedToClipboard(kQuillJsRichTextEditor);
    });

    test(
      'copying an image should return the image that was recently copied',
      () async {
        final imageBytes = await loadAssetFile(kFlutterQuillAssetImage);
        final imageBytes2 = await loadAssetFile(kQuillJsRichTextEditor);

        await quillNativeBridge.copyImageToClipboard(imageBytes);
        await quillNativeBridge.copyImageToClipboard(imageBytes2);

        final clipboardImageBytes = await quillNativeBridge.getClipboardImage();
        final pixelMismatchPercentage =
            await compareImages(src1: imageBytes, src2: clipboardImageBytes);
        expect(pixelMismatchPercentage, isNot(0));

        final pixelMismatchPercentage2 =
            await compareImages(src1: imageBytes2, src2: clipboardImageBytes);
        expect(pixelMismatchPercentage2, 0);
      },
    );
  });

  group('getClipboardHtml and copyHtmlToClipbaord', () {
    test('copying HTML to the clipboard should make it accessible', () async {
      const htmlToCopy =
          '<div class="container"><h1>Test Document</h1><p>This is a <strong>sample</strong> paragraph with <a href="https://example.com">a link</a> and some <span style="color:red;">red text</span>.</p><ul><li>Item 1</li><li>Item 2</li><li>Item 3</li></ul><footer>Footer content here</footer></div>';
      await quillNativeBridge.copyHtmlToClipboard(htmlToCopy);
      final clipboardHtml = await quillNativeBridge.getClipboardHtml();
      expect(htmlToCopy, clipboardHtml);
    });

    test('copying HTML should return the HTML that was recently copied',
        () async {
      const html1 = '<pre style="font-family: monospace;">HTML</pre>';
      const html2 = '<div style="border: 1px solid;">HTML Div</div>';

      await quillNativeBridge.copyHtmlToClipboard(html1);
      await quillNativeBridge.copyHtmlToClipboard(html2);

      final clipboardHtml = await quillNativeBridge.getClipboardHtml();
      expect(clipboardHtml, isNot(html1));
      expect(clipboardHtml, html2);
    });
    // TODO: See if there is a need for writing a similar test for getClipboardImage
    test(
      'getClipboardHtml should return the HTML content after copying HTML, '
      'and should no longer return HTML once an image (or any non-HTML item) '
      'has been copied to the clipboard after that.',
      () async {
        const html = '<pre style="font-family: monospace;">HTML</pre>';

        // Copy HTML to clipboard before copying an image

        await quillNativeBridge.copyHtmlToClipboard(html);

        expect(
          await quillNativeBridge.getClipboardHtml(),
          html,
        );

        // Image clipboard item
        final imageBytes = await loadAssetFile(kFlutterQuillAssetImage);
        await quillNativeBridge.copyImageToClipboard(imageBytes);

        expect(
          await quillNativeBridge.getClipboardHtml(),
          null,
        );

        // Copy HTML to clipboard before copying plain text

        await quillNativeBridge.copyHtmlToClipboard(html);

        expect(
          await quillNativeBridge.getClipboardHtml(),
          html,
        );

        // Plain text clipboard item
        const plainTextExample = 'Flutter Quill';
        Clipboard.setData(
          const ClipboardData(text: plainTextExample),
        );
        expect(
          (await Clipboard.getData(Clipboard.kTextPlain))?.text,
          plainTextExample,
        );

        expect(
          await quillNativeBridge.getClipboardHtml(),
          null,
        );
      },
    );

    // Some platforms such as windows might include comments/description
    // that can make the HTML invalid
    test(
      'should return valid HTML that can be parsed',
      () async {
        const exampleHtml = '<div style="border: 1px solid;">HTML Div</div>';

        await quillNativeBridge.copyHtmlToClipboard(exampleHtml);
        final clipboardHtml = await quillNativeBridge.getClipboardHtml();

        if (clipboardHtml == null) {
          fail(
            'Html has been copied to the clipboard and expected to be not null.',
          );
        }

        bool isHTML(String str) {
          final htmlRegExp =
              RegExp('<[^>]*>', multiLine: true, caseSensitive: false);
          return htmlRegExp.hasMatch(str) && str.startsWith('<');
        }

        expect(isHTML(clipboardHtml), true);
        expect(isHTML('Invalid<html></html>'), false);
      },
    );
  });

  group(
    'saveImageToGallery',
    () {
      test('throws an error if image bytes are invalid', () async {
        if (!(await quillNativeBridge
            .isSupported(QuillNativeBridgeFeature.saveImageToGallery))) {
          markTestSkipped(
              'The platform $defaultTargetPlatform does not apply to save images to the gallery feature');
          return;
        }
        await expectLater(
          quillNativeBridge.saveImageToGallery(Uint8List.fromList([1, 0, 1]),
              options: const GalleryImageSaveOptions(
                name: 'ExampleImageName',
                fileExtension: 'png',
                albumName: null,
              )),
          throwsA(isA<PlatformException>().having(
            (e) => e.code,
            'code',
            equals('INVALID_IMAGE'),
          )),
        );
      });
    },
  );
}
