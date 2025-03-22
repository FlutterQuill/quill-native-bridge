import 'package:flutter/foundation.dart' show Uint8List;
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'src/placeholder_implementation.dart';
import 'src/platform_feature.dart';
import 'src/types/image_save_options.dart';
import 'src/types/image_save_result.dart';

export 'src/platform_feature.dart';
export 'src/types/image_save_options.dart';
export 'src/types/image_save_result.dart';

/// Platform implementations should extend this class rather than implement it
/// as newly added methods are not considered to be breaking
/// changes. Extending this class (using `extends`) ensures that the subclass
/// will get the default implementation, while platform implementations that
/// `implements` this interface will be broken by newly added
/// [QuillNativeBridgePlatform] methods.
///
/// See [Flutter #127396](https://github.com/flutter/flutter/issues/127396)
/// and [plugin_platform_interface](https://pub.dev/packages/plugin_platform_interface)
/// for more details.
abstract class QuillNativeBridgePlatform extends PlatformInterface {
  /// Constructs a [QuillNativeBridgePlatform].
  QuillNativeBridgePlatform() : super(token: _token);

  // Avoid using `const` when creating the [Object] for [_token].
  static final Object _token = Object();

  static QuillNativeBridgePlatform _instance = PlaceholderImplementation();

  /// The default instance of [QuillNativeBridgePlatform] to use.
  ///
  /// Defaults to [PlaceholderImplementation].
  static QuillNativeBridgePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [QuillNativeBridgePlatform] when
  /// they register themselves.
  static set instance(QuillNativeBridgePlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Checks if the specified [feature] is supported in the current implementation.
  ///
  /// Will verify if the platform supports this feature, the platform
  /// implementation of the plugin, and the current running OS version.
  ///
  /// For example if [feature] is:
  ///
  /// - Supported on **Android API 21** (as an example) and the
  /// current Android API is `19` then will return `false`.
  ///
  /// - Supported on the web if Clipboard API (as another example)
  /// available in the current browser, and the current browser doesn't support it,
  /// will return `false` too. For this specific example, you will need
  /// to fallback to **Clipboard events** on **Firefox** or browsers that doesn't
  /// support **Clipboard API**.
  ///
  /// - Supported by the platform itself but the plugin currently implements it,
  /// then return `false`.
  ///
  /// Always review the doc comment of a method before use for special notes.
  ///
  /// See also: [QuillNativeBridgeFeature]
  Future<bool> isSupported(QuillNativeBridgeFeature feature) =>
      throw UnimplementedError('isSupported() has not been implemented.');

  /// Checks if the app is running on [iOS Simulator](https://developer.apple.com/documentation/xcode/running-your-app-in-simulator-or-on-a-device).
  Future<bool> isIOSSimulator() =>
      throw UnimplementedError('isIOSSimulator() has not been implemented.');

  /// Returns HTML from the system clipboard.
  Future<String?> getClipboardHtml() =>
      throw UnimplementedError('getClipboardHtml() has not been implemented.');

  /// Copies an HTML to the system clipboard to be pasted on other apps.
  Future<void> copyHtmlToClipboard(String html) => throw UnimplementedError(
      'copyHtmlToClipboard() has not been implemented.');

  /// Copies an image to the system clipboard to be pasted on other apps.
  Future<void> copyImageToClipboard(Uint8List imageBytes) =>
      throw UnimplementedError(
        'copyImageToClipboard() has not been implemented.',
      );

  /// Returns the copied image from the system clipboard.
  Future<Uint8List?> getClipboardImage() =>
      throw UnimplementedError('getClipboardImage() has not been implemented.');

  /// Returns the copied GIF from the system clipboard.
  Future<Uint8List?> getClipboardGif() =>
      throw UnimplementedError('getClipboardGif() has not been implemented.');

  /// Returns the file paths from the system clipboard.
  Future<List<String>> getClipboardFiles() =>
      throw UnimplementedError('getClipboardFiles() has not been implemented.');

  /// Opens the system gallery app.
  Future<void> openGalleryApp() => throw UnimplementedError(
        'openGalleryApp() has not been implemented.',
      );

  /// Saves an image to the gallery app.
  Future<void> saveImageToGallery(
    Uint8List imageBytes, {
    required GalleryImageSaveOptions options,
  }) =>
      throw UnimplementedError(
        'saveImageToGallery() has not been implemented.',
      );

  /// Saves an image to the device.
  ///
  /// Returns [ImageSaveResult] with `null` to [ImageSaveResult.filePath]
  /// if the operation was canceled and always `null` on web platforms.
  Future<ImageSaveResult> saveImage(
    Uint8List imageBytes, {
    required ImageSaveOptions options,
  }) =>
      throw UnimplementedError(
        'saveImage() has not been implemented.',
      );

  /// Returns whether the current browser is Safari on the web.
  bool isAppleSafari() => false;
}
