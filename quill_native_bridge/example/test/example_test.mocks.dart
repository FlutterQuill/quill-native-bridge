// Mocks generated by Mockito 5.4.4 from annotations
// in quill_native_bridge_example/test/example_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;
import 'dart:typed_data' as _i6;

import 'package:mockito/mockito.dart' as _i1;
import 'package:quill_native_bridge_platform_interface/quill_native_bridge_platform_interface.dart'
    as _i3;
import 'package:quill_native_bridge_platform_interface/src/platform_feature.dart'
    as _i5;
import 'package:quill_native_bridge_platform_interface/src/types/image_save_options.dart'
    as _i7;
import 'package:quill_native_bridge_platform_interface/src/types/image_save_result.dart'
    as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeImageSaveResult_0 extends _i1.SmartFake
    implements _i2.ImageSaveResult {
  _FakeImageSaveResult_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [QuillNativeBridgePlatform].
///
/// See the documentation for Mockito's code generation for more information.
class MockQuillNativeBridgePlatform extends _i1.Mock
    implements _i3.QuillNativeBridgePlatform {
  MockQuillNativeBridgePlatform() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<bool> isSupported(_i5.QuillNativeBridgeFeature? feature) =>
      (super.noSuchMethod(
        Invocation.method(
          #isSupported,
          [feature],
        ),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);

  @override
  _i4.Future<bool> isIOSSimulator() => (super.noSuchMethod(
        Invocation.method(
          #isIOSSimulator,
          [],
        ),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);

  @override
  _i4.Future<String?> getClipboardHtml() => (super.noSuchMethod(
        Invocation.method(
          #getClipboardHtml,
          [],
        ),
        returnValue: _i4.Future<String?>.value(),
      ) as _i4.Future<String?>);

  @override
  _i4.Future<void> copyHtmlToClipboard(String? html) => (super.noSuchMethod(
        Invocation.method(
          #copyHtmlToClipboard,
          [html],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> copyImageToClipboard(_i6.Uint8List? imageBytes) =>
      (super.noSuchMethod(
        Invocation.method(
          #copyImageToClipboard,
          [imageBytes],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<_i6.Uint8List?> getClipboardImage() => (super.noSuchMethod(
        Invocation.method(
          #getClipboardImage,
          [],
        ),
        returnValue: _i4.Future<_i6.Uint8List?>.value(),
      ) as _i4.Future<_i6.Uint8List?>);

  @override
  _i4.Future<_i6.Uint8List?> getClipboardGif() => (super.noSuchMethod(
        Invocation.method(
          #getClipboardGif,
          [],
        ),
        returnValue: _i4.Future<_i6.Uint8List?>.value(),
      ) as _i4.Future<_i6.Uint8List?>);

  @override
  _i4.Future<List<String>> getClipboardFiles() => (super.noSuchMethod(
        Invocation.method(
          #getClipboardFiles,
          [],
        ),
        returnValue: _i4.Future<List<String>>.value(<String>[]),
      ) as _i4.Future<List<String>>);

  @override
  _i4.Future<void> openGalleryApp() => (super.noSuchMethod(
        Invocation.method(
          #openGalleryApp,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> saveImageToGallery(
    _i6.Uint8List? imageBytes, {
    required _i7.GalleryImageSaveOptions? options,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #saveImageToGallery,
          [imageBytes],
          {#options: options},
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<_i2.ImageSaveResult> saveImage(
    _i6.Uint8List? imageBytes, {
    required _i7.ImageSaveOptions? options,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #saveImage,
          [imageBytes],
          {#options: options},
        ),
        returnValue:
            _i4.Future<_i2.ImageSaveResult>.value(_FakeImageSaveResult_0(
          this,
          Invocation.method(
            #saveImage,
            [imageBytes],
            {#options: options},
          ),
        )),
      ) as _i4.Future<_i2.ImageSaveResult>);
}
