import 'dart:io';

import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import 'package:file_selector_linux/file_selector_linux.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:quill_native_bridge_linux/quill_native_bridge_linux.dart';
import 'package:quill_native_bridge_linux/src/environment_provider.dart';
import 'package:quill_native_bridge_linux/src/image_saver.dart';
import 'package:quill_native_bridge_platform_interface/quill_native_bridge_platform_interface.dart';
import 'package:quill_native_bridge_platform_interface/src/image_mime_utils.dart';

@GenerateMocks([FileSelectorPlatform, EnvironmentProvider])
import 'quill_native_bridge_linux_test.mocks.dart';

final _fakeLinuxUserHomeDir = '/home/foo-bar/Pictures';

void main() {
  late QuillNativeBridgeLinux plugin;

  setUp(() {
    plugin = QuillNativeBridgeLinux();
  });

  test('registered instance', () {
    QuillNativeBridgeLinux.registerWith();
    expect(QuillNativeBridgePlatform.instance, isA<QuillNativeBridgeLinux>());
  });

  test('defaults image saver instance to $ImageSaver', () {
    expect(QuillNativeBridgeLinux.imageSaver, isA<ImageSaver>());
  });

  group('$ImageSaver', () {
    // A file that always exists during tests
    late File imageTestFile;
    late MockEnvironmentProvider mockEnvironmentProvider;
    late MockFileSelectorPlatform mockFileSelectorPlatform;
    late ImageSaver imageSaver;

    setUp(() async {
      mockFileSelectorPlatform = MockFileSelectorPlatform();

      imageSaver = ImageSaver();
      imageSaver.fileSelector = mockFileSelectorPlatform;

      QuillNativeBridgeLinux.imageSaver = imageSaver;

      mockEnvironmentProvider = MockEnvironmentProvider();
      EnvironmentProvider.instance = mockEnvironmentProvider;

      imageTestFile = File(
          '${Directory.systemTemp.path}/tempImageTest_${DateTime.now().millisecondsSinceEpoch}.png');
      await imageTestFile.create();

      when(mockFileSelectorPlatform.getSaveLocation(
        acceptedTypeGroups: anyNamed('acceptedTypeGroups'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => null);
      when(mockEnvironmentProvider.environment).thenReturn({});
    });

    tearDown(() async {
      await imageTestFile.delete();
    });

    test(
      'The Linux user home environment key should be correct',
      () {
        expect(ImageSaver.linuxUserHomeEnvKey, equals('HOME'));
      },
    );

    test('The pictures directory name should be correct', () {
      expect(ImageSaver.picturesDirectoryName, equals('Pictures'));
    });

    test(
      'saveImage should return null for file path when user cancels save dialog',
      () async {
        final filePath = (await plugin.saveImage(Uint8List.fromList([1, 0, 1]),
                options: ImageSaveOptions(
                  name: 'ExampleImage',
                  fileExtension: 'png',
                )))
            .filePath;
        expect(filePath, isNull);
      },
    );

    test(
      'file selector instance internally defaults to $FileSelectorLinux',
      () {
        expect(ImageSaver().fileSelector, isA<FileSelectorLinux>());
      },
    );

    test(
      'userHome delegates to Platform.environment with the correct key',
      () {
        when(mockEnvironmentProvider.environment).thenReturn(
            {ImageSaver.linuxUserHomeEnvKey: _fakeLinuxUserHomeDir});
        expect(imageSaver.userHome, equals(_fakeLinuxUserHomeDir));

        verify(mockEnvironmentProvider
                .environment[ImageSaver.linuxUserHomeEnvKey])
            .called(1);

        when(mockEnvironmentProvider.environment)
            .thenReturn({ImageSaver.linuxUserHomeEnvKey: ''});
        expect(imageSaver.userHome, equals(''));

        verify(mockEnvironmentProvider
                .environment[ImageSaver.linuxUserHomeEnvKey])
            .called(1);
      },
    );

    test(
      'picturesDirectoryPath returns null when userHome is empty or null',
      () {
        when(mockEnvironmentProvider.environment)
            .thenReturn({ImageSaver.linuxUserHomeEnvKey: ''});
        expect(imageSaver.picturesDirectoryPath, isNull);
        verify(imageSaver.userHome).called(1);

        when(mockEnvironmentProvider.environment)
            .thenReturn({ImageSaver.linuxUserHomeEnvKey: null});
        expect(imageSaver.picturesDirectoryPath, isNull);
        verify(imageSaver.userHome).called(1);
      },
    );

    test(
      'picturesDirectoryPath depends on userHome',
      () {
        when(mockEnvironmentProvider.environment)
            .thenReturn({ImageSaver.linuxUserHomeEnvKey: ''});
        imageSaver.picturesDirectoryPath;
        verify(mockEnvironmentProvider
            .environment[ImageSaver.linuxUserHomeEnvKey]);
      },
    );

    test(
      'picturesDirectoryPath correctly joins user home with pictures directory',
      () {
        when(mockEnvironmentProvider.environment).thenReturn(
            {ImageSaver.linuxUserHomeEnvKey: _fakeLinuxUserHomeDir});
        expect(
          imageSaver.picturesDirectoryPath,
          equals(
              '${_fakeLinuxUserHomeDir}/${ImageSaver.picturesDirectoryName}'),
        );
      },
    );

    test(
      'saveImage should return file path if save is successful',
      () async {
        final saveLocation = FileSaveLocation(imageTestFile.path);

        when(mockFileSelectorPlatform.getSaveLocation(
          acceptedTypeGroups: anyNamed('acceptedTypeGroups'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => saveLocation);

        final filePath = (await plugin.saveImage(Uint8List.fromList([1, 0, 1]),
                options: ImageSaveOptions(
                  name: 'ExampleImage',
                  fileExtension: 'png',
                )))
            .filePath;

        expect(filePath, equals(saveLocation.path));
      },
    );
    test(
      'saveImage passes the arguments correctly to fileSelector.getSaveLocation',
      () async {
        final imageBytes = Uint8List.fromList([1, 0, 1]);
        final options = ImageSaveOptions(
          name: 'ExampleImage',
          fileExtension: 'jpg',
        );

        when(mockFileSelectorPlatform.getSaveLocation(
          acceptedTypeGroups: anyNamed('acceptedTypeGroups'),
          options: anyNamed('options'),
        )).thenAnswer(
            (invocation) async => FileSaveLocation(imageTestFile.path));

        await plugin.saveImage(imageBytes, options: options);

        final capturedOptions = verify(mockFileSelectorPlatform.getSaveLocation(
          options: captureAnyNamed('options'),
          acceptedTypeGroups: captureAnyNamed('acceptedTypeGroups'),
        )).captured;

        SaveDialogOptions? passedOptions =
            capturedOptions[0] as SaveDialogOptions;
        List<XTypeGroup> passedAcceptedTypeGroups =
            capturedOptions[1] as List<XTypeGroup>;

        expect(passedOptions.suggestedName,
            '${options.name}.${options.fileExtension}');
        expect(
            passedOptions.initialDirectory, imageSaver.picturesDirectoryPath);
        expect(passedAcceptedTypeGroups.map((e) => e.toJSON()), [
          XTypeGroup(
            label: 'Images',
            extensions: [options.fileExtension],
            mimeTypes: [getImageMimeType(options.fileExtension)],
          ).toJSON()
        ]);
      },
    );

    test('saveImage calls fileSelector.getSaveLocation only once', () async {
      await plugin.saveImage(Uint8List.fromList([1, 0, 1]),
          options: ImageSaveOptions(
            name: 'ExampleImage',
            fileExtension: 'png',
          ));
      verify(mockFileSelectorPlatform.getSaveLocation(
        acceptedTypeGroups: anyNamed('acceptedTypeGroups'),
        options: anyNamed('options'),
      )).called(1);
    });

    test(
      'saveImage returns null when $FileSaveLocation from fileSelector.getSaveLocation is null',
      () async {
        when(mockFileSelectorPlatform.getSaveLocation(
          acceptedTypeGroups: anyNamed('acceptedTypeGroups'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => null);

        final imageFilePath =
            (await plugin.saveImage(Uint8List.fromList([1, 0, 1]),
                    options: ImageSaveOptions(
                      name: 'ExampleImage',
                      fileExtension: 'png',
                    )))
                .filePath;

        expect(imageFilePath, isNull);
      },
    );

    test(
      'saveImage passes the mimeTypes correctly to fileSelector.getSaveLocation',
      () async {
        when(mockFileSelectorPlatform.getSaveLocation(
          acceptedTypeGroups: anyNamed('acceptedTypeGroups'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => null);

        final options = ImageSaveOptions(
          name: 'ImageName',
          // IMPORTANT: Use jpg specifically instead of jpeg or png
          // since the "image/jpg" is invalid and it will verify behavior,
          // ensuring the mimeType is passed correctly.
          fileExtension: 'jpg',
        );
        await plugin.saveImage(Uint8List.fromList([]), options: options);

        final capturedOptions = verify(mockFileSelectorPlatform.getSaveLocation(
          acceptedTypeGroups: captureAnyNamed('acceptedTypeGroups'),
          options: anyNamed('options'),
        )).captured;
        expect((capturedOptions[0] as List<XTypeGroup>).first.mimeTypes,
            [getImageMimeType(options.fileExtension)]);
      },
    );

    test(
      'saveImage writes the bytes to the file on success',
      () async {
        when(mockFileSelectorPlatform.getSaveLocation(
          acceptedTypeGroups: anyNamed('acceptedTypeGroups'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => FileSaveLocation(imageTestFile.path));

        final imageBytes = Uint8List.fromList([1, 0, 1]);

        expect(imageTestFile.existsSync(), isTrue,
            reason: 'The $setUp should create the file');

        final filePath = (await plugin.saveImage(imageBytes,
                options: ImageSaveOptions(
                  name: 'ExampleImage',
                  fileExtension: 'png',
                )))
            .filePath;
        if (filePath == null) {
          fail('Expected the operation to succeed.');
        }

        expect(imageTestFile.readAsBytesSync(), imageBytes);
        expect(File(filePath).readAsBytesSync(), imageBytes);
      },
    );

    test(
      'saveImage always passes null to blob URL on non-web platforms',
      () async {
        when(mockFileSelectorPlatform.getSaveLocation(
          acceptedTypeGroups: anyNamed('acceptedTypeGroups'),
          options: anyNamed('acceptedTypeGroups'),
        )).thenAnswer((_) async => null);
        final result = await plugin.saveImage(Uint8List.fromList([1, 0, 1]),
            options: ImageSaveOptions(
              name: 'ExampleImage',
              fileExtension: 'png',
            ));
        expect(result.blobUrl, isNull);

        when(mockFileSelectorPlatform.getSaveLocation(
          acceptedTypeGroups: anyNamed('acceptedTypeGroups'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => FileSaveLocation(imageTestFile.path));

        final result2 = await plugin.saveImage(Uint8List.fromList([1, 0, 1]),
            options: ImageSaveOptions(
              name: 'ExampleImage',
              fileExtension: 'png',
            ));
        expect(result2.blobUrl, isNull);
        expect(result2.filePath, imageTestFile.path);
      },
    );
  });
}
