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
  /// Will verify if this is supported in the platform itself:
  ///
  /// - If [feature] is supported on **Android API 21** (as an example) and the
  /// current Android API is `19` then will return `false`
  /// - If [feature] is supported on the web if Clipboard API (as another example)
  /// available in the current browser, and the current browser doesn't support it,
  /// will return `false` too. For this specific example, you will need
  /// to fallback to **Clipboard events** on **Firefox** or browsers that doesn't
  /// support **Clipboard API**.
  ///
  /// Always check the docs of the method you're calling to see if there
  /// are special notes.
  Future<bool> isSupported(QuillNativeBridgeFeature feature) =>
      throw UnimplementedError('isSupported() has not been implemented.');

  /// Check if the app is running on [iOS Simulator](https://developer.apple.com/documentation/xcode/running-your-app-in-simulator-or-on-a-device).
  Future<bool> isIOSSimulator() =>
      throw UnimplementedError('isIOSSimulator() has not been implemented.');

  /// Return HTML from the system clipboard.
  Future<String?> getClipboardHtml() =>
      throw UnimplementedError('getClipboardHtml() has not been implemented.');

  /// Copy the [html] to the system clipboard to be pasted on other apps.
  Future<void> copyHtmlToClipboard(String html) => throw UnimplementedError(
      'copyHtmlToClipboard() has not been implemented.');

  /// Copy the [imageBytes] to system clipboard to be pasted on other apps.
  Future<void> copyImageToClipboard(Uint8List imageBytes) =>
      throw UnimplementedError(
        'copyImageToClipboard() has not been implemented.',
      );

  /// Return the copied image from the system clipboard.
  Future<Uint8List?> getClipboardImage() =>
      throw UnimplementedError('getClipboardImage() has not been implemented.');

  /// Return the copied gif from the system clipboard.
  Future<Uint8List?> getClipboardGif() =>
      throw UnimplementedError('getClipboardGif() has not been implemented.');

  /// Return the file paths from the system clipboard.
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

  /// Saves an image to the user's device.
  /// Returns `null` if the operation was cancelled.
  Future<ImageSaveResult> saveImage(
    Uint8List imageBytes, {
    required ImageSaveOptions options,
  }) =>
      throw UnimplementedError(
        'saveImage() has not been implemented.',
      );
}
