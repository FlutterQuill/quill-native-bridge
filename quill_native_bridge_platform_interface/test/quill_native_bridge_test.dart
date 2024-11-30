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

  Uint8List? savedImageBytes;
  String? savedImageName;
  String? savedImageExtension;
  String? savedImageAlbumName;

  @override
  Future<void> saveImageToGallery(
    Uint8List imageBytes, {
    required String name,
    required String extension,
    required String? albumName,
  }) async {
    savedImageBytes = imageBytes;
    savedImageName = name;
    savedImageExtension = extension;
    savedImageAlbumName = albumName;
  }

  @override
  Future<String> saveImage(
    Uint8List imageBytes, {
    required String name,
    required String extension,
  }) async {
    savedImageBytes = imageBytes;
    savedImageName = name;
    savedImageExtension = extension;
    return '/path/to/image.png';
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
      final imagePath = await QuillNativeBridgePlatform.instance.saveImage(
        Uint8List.fromList([9, 3, 5]),
        name: 'image name',
        extension: 'png',
      );
      expect(imagePath, '/path/to/image.png');
      expect(fakePlatform.savedImageBytes, [9, 3, 5]);
      expect(fakePlatform.savedImageName, 'image name');
      expect(fakePlatform.savedImageExtension, 'png');
    },
  );
  test(
    'saveImageToGallery',
    () async {
      await QuillNativeBridgePlatform.instance.saveImageToGallery(
        Uint8List.fromList([9, 3, 5]),
        name: 'image name',
        extension: 'png',
        albumName: 'example album',
      );
      expect(fakePlatform.savedImageBytes, [9, 3, 5]);
      expect(fakePlatform.savedImageName, 'image name');
      expect(fakePlatform.savedImageExtension, 'png');
      expect(fakePlatform.savedImageAlbumName, 'example album');
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
