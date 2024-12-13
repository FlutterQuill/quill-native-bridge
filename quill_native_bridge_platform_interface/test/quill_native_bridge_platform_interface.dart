import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:quill_native_bridge_platform_interface/quill_native_bridge_platform_interface.dart';
import 'package:quill_native_bridge_platform_interface/src/placeholder_implementation.dart';

class MockQuillNativeBridgePlatform
    with MockPlatformInterfaceMixin
    implements QuillNativeBridgePlatform {
  @override
  Future<bool> isSupported(QuillNativeBridgeFeature feature) async {
    return false;
  }

  @override
  Future<bool> isIOSSimulator() async => false;

  @override
  Future<String?> getClipboardHtml() async {
    return '<center>Invalid HTML</center>';
  }

  String? primaryHTMLClipbaord;

  @override
  Future<void> copyHtmlToClipboard(String html) async {
    primaryHTMLClipbaord = html;
  }

  Uint8List? primaryImageClipboard;

  @override
  Future<void> copyImageToClipboard(Uint8List imageBytes) async {
    primaryImageClipboard = imageBytes;
  }

  @override
  Future<Uint8List?> getClipboardImage() async {
    return Uint8List.fromList([0, 2, 1]);
  }

  @override
  Future<Uint8List?> getClipboardGif() async {
    return Uint8List.fromList([0, 1, 0]);
  }

  @override
  Future<List<String>> getClipboardFiles() async {
    return ['/path/to/file.html', 'path/to/file.md'];
  }

  GalleryImageSaveOptions? galleryImageSaveOptions;
  Uint8List? savedGalleryImageBytes;

  Uint8List? savedImageBytes;
  ImageSaveOptions? imageSaveOptions;

  @override
  Future<void> saveImageToGallery(
    Uint8List imageBytes, {
    required GalleryImageSaveOptions options,
  }) async {
    savedGalleryImageBytes = imageBytes;
    galleryImageSaveOptions = options;
  }

  @override
  Future<ImageSaveResult> saveImage(
    Uint8List imageBytes, {
    required ImageSaveOptions options,
  }) async {
    savedImageBytes = imageBytes;
    imageSaveOptions = options;
    return const ImageSaveResult(
      filePath: '/path/to/file',
      blobUrl:
          'blob:http://localhost:64030/e58f63d4-2890-469c-9c8e-69e839da6a93',
    );
  }

  var _galleryAppOpened = false;

  @override
  Future<void> openGalleryApp() async {
    _galleryAppOpened = true;
  }
}

void main() {
  final initialPlatform = QuillNativeBridgePlatform.instance;

  test('$PlaceholderImplementation is the default instance', () {
    expect(initialPlatform, isInstanceOf<PlaceholderImplementation>());
  });

  final fakePlatform = MockQuillNativeBridgePlatform();
  QuillNativeBridgePlatform.instance = fakePlatform;

  test('isIOSSimulator', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    expect(await QuillNativeBridgePlatform.instance.isIOSSimulator(), false);
  });

  test('getClipboardHtml()', () async {
    expect(
      await QuillNativeBridgePlatform.instance.getClipboardHtml(),
      '<center>Invalid HTML</center>',
    );
  });

  test('copyImageToClipboard()', () async {
    final imageBytes = Uint8List.fromList([]);
    expect(
      fakePlatform.primaryImageClipboard,
      null,
    );
    await QuillNativeBridgePlatform.instance.copyImageToClipboard(imageBytes);
    expect(
      fakePlatform.primaryImageClipboard,
      imageBytes,
    );
  });

  test('copyHtmlToClipboard()', () async {
    const html = '<pre>HTML</pre>';
    expect(
      fakePlatform.primaryHTMLClipbaord,
      null,
    );
    await QuillNativeBridgePlatform.instance.copyHtmlToClipboard(html);
    expect(
      fakePlatform.primaryHTMLClipbaord,
      html,
    );
  });

  test('getClipboardImage()', () async {
    expect(
      await QuillNativeBridgePlatform.instance.getClipboardImage(),
      Uint8List.fromList([0, 2, 1]),
    );
  });

  test('getClipboardGif()', () async {
    expect(
      await QuillNativeBridgePlatform.instance.getClipboardGif(),
      Uint8List.fromList([0, 1, 0]),
    );
  });
  test('getClipboardFiles()', () async {
    expect(
      await QuillNativeBridgePlatform.instance.getClipboardFiles(),
      ['/path/to/file.html', 'path/to/file.md'],
    );
  });
  test(
    'saveImage',
    () async {
      const options =
          ImageSaveOptions(name: 'image name', fileExtension: 'png');
      final result = await QuillNativeBridgePlatform.instance.saveImage(
        Uint8List.fromList([9, 3, 5]),
        options: options,
      );
      expect(
        result,
        const ImageSaveResult(
          filePath: '/path/to/file',
          blobUrl:
              'blob:http://localhost:64030/e58f63d4-2890-469c-9c8e-69e839da6a93',
        ),
      );
      expect(fakePlatform.savedImageBytes, [9, 3, 5]);
      expect(fakePlatform.imageSaveOptions, options);
    },
  );
  test(
    'saveImageToGallery',
    () async {
      const galleryImageSaveOptions = GalleryImageSaveOptions(
        name: 'image name',
        fileExtension: 'png',
        albumName: 'example album',
      );
      await QuillNativeBridgePlatform.instance.saveImageToGallery(
        Uint8List.fromList([9, 3, 5]),
        options: galleryImageSaveOptions,
      );
      expect(fakePlatform.savedGalleryImageBytes, [9, 3, 5]);
      expect(fakePlatform.galleryImageSaveOptions, galleryImageSaveOptions);
    },
  );

  test(
    'openGalleryApp',
    () async {
      await QuillNativeBridgePlatform.instance.openGalleryApp();

      expect(fakePlatform._galleryAppOpened, true);
    },
  );
}
