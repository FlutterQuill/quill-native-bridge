// Autogenerated from Pigeon (v22.6.2), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import, unnecessary_parenthesis, unnecessary_import, no_leading_underscores_for_local_identifiers
// ignore_for_file: avoid_relative_lib_imports
import 'dart:async';
import 'dart:typed_data' show Float64List, Int32List, Int64List, Uint8List;
import 'package:flutter/foundation.dart' show ReadBuffer, WriteBuffer;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quill_native_bridge_ios/src/messages.g.dart';


class _PigeonCodec extends StandardMessageCodec {
  const _PigeonCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is int) {
      buffer.putUint8(4);
      buffer.putInt64(value);
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

abstract class TestQuillNativeBridgeApi {
  static TestDefaultBinaryMessengerBinding? get _testBinaryMessengerBinding => TestDefaultBinaryMessengerBinding.instance;
  static const MessageCodec<Object?> pigeonChannelCodec = _PigeonCodec();

  bool isIosSimulator();

  String? getClipboardHtml();

  void copyHtmlToClipboard(String html);

  Uint8List? getClipboardImage();

  void copyImageToClipboard(Uint8List imageBytes);

  Uint8List? getClipboardGif();

  Future<void> openGalleryApp();

  Future<void> saveImageToGallery(Uint8List imageBytes, {required String name, required String? albumName,});

  static void setUp(TestQuillNativeBridgeApi? api, {BinaryMessenger? binaryMessenger, String messageChannelSuffix = '',}) {
    messageChannelSuffix = messageChannelSuffix.isNotEmpty ? '.$messageChannelSuffix' : '';
    {
      final BasicMessageChannel<Object?> pigeonVar_channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.quill_native_bridge_ios.QuillNativeBridgeApi.isIosSimulator$messageChannelSuffix', pigeonChannelCodec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(pigeonVar_channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(pigeonVar_channel, (Object? message) async {
          try {
            final bool output = api.isIosSimulator();
            return <Object?>[output];
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          }          catch (e) {
            return wrapResponse(error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
    {
      final BasicMessageChannel<Object?> pigeonVar_channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.quill_native_bridge_ios.QuillNativeBridgeApi.getClipboardHtml$messageChannelSuffix', pigeonChannelCodec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(pigeonVar_channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(pigeonVar_channel, (Object? message) async {
          try {
            final String? output = api.getClipboardHtml();
            return <Object?>[output];
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          }          catch (e) {
            return wrapResponse(error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
    {
      final BasicMessageChannel<Object?> pigeonVar_channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.quill_native_bridge_ios.QuillNativeBridgeApi.copyHtmlToClipboard$messageChannelSuffix', pigeonChannelCodec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(pigeonVar_channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(pigeonVar_channel, (Object? message) async {
          assert(message != null,
          'Argument for dev.flutter.pigeon.quill_native_bridge_ios.QuillNativeBridgeApi.copyHtmlToClipboard was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final String? arg_html = (args[0] as String?);
          assert(arg_html != null,
              'Argument for dev.flutter.pigeon.quill_native_bridge_ios.QuillNativeBridgeApi.copyHtmlToClipboard was null, expected non-null String.');
          try {
            api.copyHtmlToClipboard(arg_html!);
            return wrapResponse(empty: true);
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          }          catch (e) {
            return wrapResponse(error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
    {
      final BasicMessageChannel<Object?> pigeonVar_channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.quill_native_bridge_ios.QuillNativeBridgeApi.getClipboardImage$messageChannelSuffix', pigeonChannelCodec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(pigeonVar_channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(pigeonVar_channel, (Object? message) async {
          try {
            final Uint8List? output = api.getClipboardImage();
            return <Object?>[output];
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          }          catch (e) {
            return wrapResponse(error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
    {
      final BasicMessageChannel<Object?> pigeonVar_channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.quill_native_bridge_ios.QuillNativeBridgeApi.copyImageToClipboard$messageChannelSuffix', pigeonChannelCodec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(pigeonVar_channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(pigeonVar_channel, (Object? message) async {
          assert(message != null,
          'Argument for dev.flutter.pigeon.quill_native_bridge_ios.QuillNativeBridgeApi.copyImageToClipboard was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final Uint8List? arg_imageBytes = (args[0] as Uint8List?);
          assert(arg_imageBytes != null,
              'Argument for dev.flutter.pigeon.quill_native_bridge_ios.QuillNativeBridgeApi.copyImageToClipboard was null, expected non-null Uint8List.');
          try {
            api.copyImageToClipboard(arg_imageBytes!);
            return wrapResponse(empty: true);
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          }          catch (e) {
            return wrapResponse(error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
    {
      final BasicMessageChannel<Object?> pigeonVar_channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.quill_native_bridge_ios.QuillNativeBridgeApi.getClipboardGif$messageChannelSuffix', pigeonChannelCodec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(pigeonVar_channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(pigeonVar_channel, (Object? message) async {
          try {
            final Uint8List? output = api.getClipboardGif();
            return <Object?>[output];
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          }          catch (e) {
            return wrapResponse(error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
    {
      final BasicMessageChannel<Object?> pigeonVar_channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.quill_native_bridge_ios.QuillNativeBridgeApi.openGalleryApp$messageChannelSuffix', pigeonChannelCodec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(pigeonVar_channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(pigeonVar_channel, (Object? message) async {
          try {
            await api.openGalleryApp();
            return wrapResponse(empty: true);
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          }          catch (e) {
            return wrapResponse(error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
    {
      final BasicMessageChannel<Object?> pigeonVar_channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.quill_native_bridge_ios.QuillNativeBridgeApi.saveImageToGallery$messageChannelSuffix', pigeonChannelCodec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(pigeonVar_channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(pigeonVar_channel, (Object? message) async {
          assert(message != null,
          'Argument for dev.flutter.pigeon.quill_native_bridge_ios.QuillNativeBridgeApi.saveImageToGallery was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final Uint8List? arg_imageBytes = (args[0] as Uint8List?);
          assert(arg_imageBytes != null,
              'Argument for dev.flutter.pigeon.quill_native_bridge_ios.QuillNativeBridgeApi.saveImageToGallery was null, expected non-null Uint8List.');
          final String? arg_name = (args[1] as String?);
          assert(arg_name != null,
              'Argument for dev.flutter.pigeon.quill_native_bridge_ios.QuillNativeBridgeApi.saveImageToGallery was null, expected non-null String.');
          final String? arg_albumName = (args[2] as String?);
          try {
            await api.saveImageToGallery(arg_imageBytes!, name: arg_name!, albumName: arg_albumName);
            return wrapResponse(empty: true);
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          }          catch (e) {
            return wrapResponse(error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
  }
}