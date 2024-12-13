// Autogenerated from Pigeon (v22.6.2), do not edit directly.
// See also: https://pub.dev/packages/pigeon

import Foundation

#if os(iOS)
  import Flutter
#elseif os(macOS)
  import FlutterMacOS
#else
  #error("Unsupported platform.")
#endif

/// Error class for passing custom error details to Dart side.
final class PigeonError: Error {
  let code: String
  let message: String?
  let details: Any?

  init(code: String, message: String?, details: Any?) {
    self.code = code
    self.message = message
    self.details = details
  }

  var localizedDescription: String {
    return
      "PigeonError(code: \(code), message: \(message ?? "<nil>"), details: \(details ?? "<nil>")"
  }
}

private func wrapResult(_ result: Any?) -> [Any?] {
  return [result]
}

private func wrapError(_ error: Any) -> [Any?] {
  if let pigeonError = error as? PigeonError {
    return [
      pigeonError.code,
      pigeonError.message,
      pigeonError.details,
    ]
  }
  if let flutterError = error as? FlutterError {
    return [
      flutterError.code,
      flutterError.message,
      flutterError.details,
    ]
  }
  return [
    "\(error)",
    "\(type(of: error))",
    "Stacktrace: \(Thread.callStackSymbols)",
  ]
}

private func isNullish(_ value: Any?) -> Bool {
  return value is NSNull || value == nil
}

private func nilOrValue<T>(_ value: Any?) -> T? {
  if value is NSNull { return nil }
  return value as! T?
}

private class MessagesPigeonCodecReader: FlutterStandardReader {
}

private class MessagesPigeonCodecWriter: FlutterStandardWriter {
}

private class MessagesPigeonCodecReaderWriter: FlutterStandardReaderWriter {
  override func reader(with data: Data) -> FlutterStandardReader {
    return MessagesPigeonCodecReader(data: data)
  }

  override func writer(with data: NSMutableData) -> FlutterStandardWriter {
    return MessagesPigeonCodecWriter(data: data)
  }
}

class MessagesPigeonCodec: FlutterStandardMessageCodec, @unchecked Sendable {
  static let shared = MessagesPigeonCodec(readerWriter: MessagesPigeonCodecReaderWriter())
}

/// Generated protocol from Pigeon that represents a handler of messages from Flutter.
protocol QuillNativeBridgeApi {
  func getClipboardHtml() throws -> String?
  func copyHtmlToClipboard(html: String) throws
  func getClipboardImage() throws -> FlutterStandardTypedData?
  func copyImageToClipboard(imageBytes: FlutterStandardTypedData) throws
  func getClipboardGif() throws -> FlutterStandardTypedData?
  func getClipboardFiles() throws -> [String]
  func openGalleryApp() throws
  /// Supports macOS 10.15 and later.
  func supportsGallerySave() throws -> Bool
  func saveImageToGallery(
    imageBytes: FlutterStandardTypedData, name: String, albumName: String?,
    completion: @escaping (Result<Void, Error>) -> Void)
  func saveImage(
    imageBytes: FlutterStandardTypedData, name: String, fileExtension: String,
    completion: @escaping (Result<String?, Error>) -> Void)
}

/// Generated setup class from Pigeon to handle messages through the `binaryMessenger`.
class QuillNativeBridgeApiSetup {
  static var codec: FlutterStandardMessageCodec { MessagesPigeonCodec.shared }
  /// Sets up an instance of `QuillNativeBridgeApi` to handle messages through the `binaryMessenger`.
  static func setUp(
    binaryMessenger: FlutterBinaryMessenger, api: QuillNativeBridgeApi?,
    messageChannelSuffix: String = ""
  ) {
    let channelSuffix = messageChannelSuffix.count > 0 ? ".\(messageChannelSuffix)" : ""
    let getClipboardHtmlChannel = FlutterBasicMessageChannel(
      name:
        "dev.flutter.pigeon.quill_native_bridge_macos.QuillNativeBridgeApi.getClipboardHtml\(channelSuffix)",
      binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getClipboardHtmlChannel.setMessageHandler { _, reply in
        do {
          let result = try api.getClipboardHtml()
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      getClipboardHtmlChannel.setMessageHandler(nil)
    }
    let copyHtmlToClipboardChannel = FlutterBasicMessageChannel(
      name:
        "dev.flutter.pigeon.quill_native_bridge_macos.QuillNativeBridgeApi.copyHtmlToClipboard\(channelSuffix)",
      binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      copyHtmlToClipboardChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let htmlArg = args[0] as! String
        do {
          try api.copyHtmlToClipboard(html: htmlArg)
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      copyHtmlToClipboardChannel.setMessageHandler(nil)
    }
    let getClipboardImageChannel = FlutterBasicMessageChannel(
      name:
        "dev.flutter.pigeon.quill_native_bridge_macos.QuillNativeBridgeApi.getClipboardImage\(channelSuffix)",
      binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getClipboardImageChannel.setMessageHandler { _, reply in
        do {
          let result = try api.getClipboardImage()
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      getClipboardImageChannel.setMessageHandler(nil)
    }
    let copyImageToClipboardChannel = FlutterBasicMessageChannel(
      name:
        "dev.flutter.pigeon.quill_native_bridge_macos.QuillNativeBridgeApi.copyImageToClipboard\(channelSuffix)",
      binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      copyImageToClipboardChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let imageBytesArg = args[0] as! FlutterStandardTypedData
        do {
          try api.copyImageToClipboard(imageBytes: imageBytesArg)
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      copyImageToClipboardChannel.setMessageHandler(nil)
    }
    let getClipboardGifChannel = FlutterBasicMessageChannel(
      name:
        "dev.flutter.pigeon.quill_native_bridge_macos.QuillNativeBridgeApi.getClipboardGif\(channelSuffix)",
      binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getClipboardGifChannel.setMessageHandler { _, reply in
        do {
          let result = try api.getClipboardGif()
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      getClipboardGifChannel.setMessageHandler(nil)
    }
    let getClipboardFilesChannel = FlutterBasicMessageChannel(
      name:
        "dev.flutter.pigeon.quill_native_bridge_macos.QuillNativeBridgeApi.getClipboardFiles\(channelSuffix)",
      binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getClipboardFilesChannel.setMessageHandler { _, reply in
        do {
          let result = try api.getClipboardFiles()
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      getClipboardFilesChannel.setMessageHandler(nil)
    }
    let openGalleryAppChannel = FlutterBasicMessageChannel(
      name:
        "dev.flutter.pigeon.quill_native_bridge_macos.QuillNativeBridgeApi.openGalleryApp\(channelSuffix)",
      binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      openGalleryAppChannel.setMessageHandler { _, reply in
        do {
          try api.openGalleryApp()
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      openGalleryAppChannel.setMessageHandler(nil)
    }
    /// Supports macOS 10.15 and later.
    let supportsGallerySaveChannel = FlutterBasicMessageChannel(
      name:
        "dev.flutter.pigeon.quill_native_bridge_macos.QuillNativeBridgeApi.supportsGallerySave\(channelSuffix)",
      binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      supportsGallerySaveChannel.setMessageHandler { _, reply in
        do {
          let result = try api.supportsGallerySave()
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      supportsGallerySaveChannel.setMessageHandler(nil)
    }
    let saveImageToGalleryChannel = FlutterBasicMessageChannel(
      name:
        "dev.flutter.pigeon.quill_native_bridge_macos.QuillNativeBridgeApi.saveImageToGallery\(channelSuffix)",
      binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      saveImageToGalleryChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let imageBytesArg = args[0] as! FlutterStandardTypedData
        let nameArg = args[1] as! String
        let albumNameArg: String? = nilOrValue(args[2])
        api.saveImageToGallery(imageBytes: imageBytesArg, name: nameArg, albumName: albumNameArg) {
          result in
          switch result {
          case .success:
            reply(wrapResult(nil))
          case .failure(let error):
            reply(wrapError(error))
          }
        }
      }
    } else {
      saveImageToGalleryChannel.setMessageHandler(nil)
    }
    let saveImageChannel = FlutterBasicMessageChannel(
      name:
        "dev.flutter.pigeon.quill_native_bridge_macos.QuillNativeBridgeApi.saveImage\(channelSuffix)",
      binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      saveImageChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let imageBytesArg = args[0] as! FlutterStandardTypedData
        let nameArg = args[1] as! String
        let fileExtensionArg = args[2] as! String
        api.saveImage(imageBytes: imageBytesArg, name: nameArg, fileExtension: fileExtensionArg) {
          result in
          switch result {
          case .success(let res):
            reply(wrapResult(res))
          case .failure(let error):
            reply(wrapError(error))
          }
        }
      }
    } else {
      saveImageChannel.setMessageHandler(nil)
    }
  }
}
