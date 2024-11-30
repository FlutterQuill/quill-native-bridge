/// An internal plugin for [`flutter_quill`](https://pub.dev/packages/flutter_quill)
/// package to access platform-specific APIs.
library;

import 'package:flutter/foundation.dart';

import 'package:quill_native_bridge_platform_interface/quill_native_bridge_platform_interface.dart';

export 'package:quill_native_bridge_platform_interface/quill_native_bridge_platform_interface.dart'
    show
        QuillNativeBridgeFeature,
        ImageSaveOptions,
        GalleryImageSaveOptions,
        ImageSaveResult;

/// An internal plugin for [`flutter_quill`](https://pub.dev/packages/flutter_quill)
/// package to access platform-specific APIs.
///
/// Use [QuillNativeBridge.isSupported] to check whether a feature is supported.
class QuillNativeBridge {
  /// The platform interface that drives this plugin.
  static QuillNativeBridgePlatform get _platform =>
      QuillNativeBridgePlatform.instance;

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
      _platform.isSupported(feature);

  /// Checks if the app runs on [iOS Simulator](https://developer.apple.com/documentation/xcode/running-your-app-in-simulator-or-on-a-device).
  ///
  /// Should be called only on an iOS app.
  Future<bool> isIOSSimulator() => _platform.isIOSSimulator();

  /// Returns a HTML from the system clipboard. The HTML can be platform-dependent.
  ///
  /// **Important for web**: If [Clipboard API](https://developer.mozilla.org/en-US/docs/Web/API/Clipboard_API)
  /// is not supported on the web browser, should fallback to [Clipboard Events](https://developer.mozilla.org/en-US/docs/Web/API/ClipboardEvent)
  /// such as the [paste_event](https://developer.mozilla.org/en-US/docs/Web/API/Element/paste_event).
  ///
  /// Returns `null` if the HTML content is not available or if the user has not granted
  /// permission for pasting on iOS.
  @Category(['Clipboard'])
  Future<String?> getClipboardHtml() => _platform.getClipboardHtml();

  /// Copies an HTML to the system clipboard to be pasted on other apps.
  ///
  /// **Important for web**: Should fallback to [Clipboard Events](https://developer.mozilla.org/en-US/docs/Web/API/ClipboardEvent)
  /// if [Clipboard API](https://developer.mozilla.org/en-US/docs/Web/API/Clipboard_API) is unsupported,
  /// not available or restricted (the case for Firefox and Safari). See [copy_event](https://developer.mozilla.org/en-US/docs/Web/API/Element/copy_event).
  @Category(['Clipboard'])
  Future<void> copyHtmlToClipboard(String html) =>
      _platform.copyHtmlToClipboard(html);

  /// Copies an image to the system clipboard to be pasted on other apps.
  ///
  /// Requires modifying `AndroidManifest.xml` to work on **Android**.
  /// See [Copying images to the system clipboard](https://pub.dev/packages/quill_native_bridge#-copying-images-to-the-system-clipboard).
  ///
  /// **Important for web**: If [Clipboard API](https://developer.mozilla.org/en-US/docs/Web/API/Clipboard_API)
  /// is not supported on the web browser, should fallback to [Clipboard Events](https://developer.mozilla.org/en-US/docs/Web/API/ClipboardEvent)
  /// such as the [copy_event](https://developer.mozilla.org/en-US/docs/Web/API/Element/copy_event).
  ///
  /// Currently, it's not supported on **Windows**.
  @Category(['Clipboard'])
  Future<void> copyImageToClipboard(Uint8List imageBytes) =>
      _platform.copyImageToClipboard(imageBytes);

  /// Returns the copied image from the system clipboard.
  ///
  /// **Important for web**: If [Clipboard API](https://developer.mozilla.org/en-US/docs/Web/API/Clipboard_API)
  /// is not supported on the web browser, should fallback to [Clipboard Events](https://developer.mozilla.org/en-US/docs/Web/API/ClipboardEvent)
  /// such as the [paste_event](https://developer.mozilla.org/en-US/docs/Web/API/Element/paste_event).
  ///
  /// Currently, it's not supported on **Windows**.
  @Category(['Clipboard'])
  Future<Uint8List?> getClipboardImage() => _platform.getClipboardImage();

  /// Returns the copied GIF image from the system clipboard.
  ///
  /// **Supports Android and iOS only.**
  @Category(['Clipboard'])
  Future<Uint8List?> getClipboardGif() => _platform.getClipboardGif();

  /// Returns the file paths from the system clipboard.
  ///
  /// Supports **macOS** and **Linux**.
  /// **Windows** and the web are currently unsupported.
  @Category(['Clipboard'])
  Future<List<String>> getClipboardFiles() => _platform.getClipboardFiles();

  /// Opens the system gallery app.
  /// **Supports Android, iOS, Windows and macOS only.**
  ///
  /// Calling this on unsupported platforms will throw [UnimplementedError].
  @Category(['Gallery'])
  Future<void> openGalleryApp() => _platform.openGalleryApp();

  /// Saves an image to the gallery app on supported platforms.
  /// **Supports Android, iOS, and macOS**.
  ///
  /// **Requires Android, iOS and macOS setup.**
  /// See [Saving images to the gallery](https://pub.dev/packages/quill_native_bridge#-saving-images-to-the-gallery)
  /// for more details.
  ///
  /// Requests necessary permission if not
  /// already granted on Android 9 (API 28) and earlier, iOS, and macOS.
  /// On Android 10 (Api 29) and later, the plugin makes use
  /// of the [Android scoped storage](https://source.android.com/docs/core/storage/scoped).
  ///
  /// NOTE: On macOS, permission is denied if the app is running using
  /// sources other than Xcode or macOS terminal such as Android Studio or VS Code.
  /// However, this does not affect the final production app.
  ///
  /// The [GalleryImageSaveOptions.name] is the image's name without the extension (e.g., `image`).
  /// It doesn't need to be unique, as it's handled by the gallery/system.
  ///
  /// The [GalleryImageSaveOptions.fileExtension] is the image's file extension (e.g., `png`).
  /// This is silently ignored on macOS and iOS.
  ///
  /// The [GalleryImageSaveOptions.albumName] sets the album in the gallery app.
  /// A new album will be created if it doesn't exist.
  /// If `null`, the default album is used.
  /// **If not `null`, read-write access to the photos library is always
  /// required on iOS and macOS (even on newer versions where add-only is supported).**
  ///
  /// Calling this on unsupported platforms will throw [UnimplementedError].
  /// Calling this on **macOS 10.14 and earlier** will throw [UnsupportedError] (unsupported by the platform).
  ///
  /// Use [isSupported] to check before calling:
  ///
  /// ```dart
  /// if (await isSupported(QuillNativeBridgeFeature.saveImageToGallery)) {
  /// // The method saveImageToGallery() is both implemented and supported by the device / OS version.
  /// // Call saveImageToGallery()
  /// }
  /// ```
  ///
  /// See also [saveImage] to save the image on desktop and web platforms.
  @Category(['Gallery'])
  Future<void> saveImageToGallery(
    Uint8List imageBytes, {
    required GalleryImageSaveOptions options,
  }) =>
      _platform.saveImageToGallery(imageBytes, options: options);

  /// Saves an image to the user's device based on the platform:
  ///
  /// - **Web**: Downloads the image using the browser's download functionality.
  /// - **macOS**: Opens the native save dialog using [`NSSavePanel`](https://developer.apple.com/documentation/appkit/nssavepanel),
  /// defaulting to the user's `Pictures` directory.
  /// **Requires platform setup**. Refer to [Saving images](pub.dev/packages/quill_native_bridge#-saving-images).
  /// - **Linux** and **Windows**: Opens the native save dialog, defaulting to the user's `Pictures` directory.
  /// The plugin delegates to [file_selector_linux](https://pub.dev/packages/file_selector_linux) or
  /// [file_selector_windows](https://pub.dev/packages/file_selector_windows) with the appropriate file
  /// type set.
  ///
  /// Not supported on mobile platforms (use [saveImageToGallery] instead).
  /// Calling this on unsupported platforms will throw [UnimplementedError].
  ///
  /// The [ImageSaveOptions.name] represents the image name without the extension (e.g., `image`).
  /// On web, the browser handles name conflicts.
  /// On macOS and Windows, prompts the user to confirm file overwrite.
  /// On Linux, behavior depends on the desktop environment (e.g., Gnome, KDE),
  /// and **file overwrite confirmation may be skipped**.
  ///
  /// The [ImageSaveOptions.fileExtension] is the image's file extension (e.g., `png`).
  ///
  /// Returns [ImageSaveResult] where:
  ///
  /// * [ImageSaveResult.filePath]: For desktop platforms, `null` if the user
  /// cancels the operation while selecting the destination using the system file picker.
  /// Always `null` on web platforms.
  ///
  /// * [ImageSaveResult.blobUrl]: For web platforms, returns the blob object URL (e.g., `blob:http://localhost:64030/e58f63d4-2890-469c-9c8e-69e839da6a93`),
  /// **which will be revoked before returning it**. Always `null` on non-web platforms.
  ///
  /// See also [saveImageToGallery] for platforms with a native gallery app.
  Future<ImageSaveResult> saveImage(
    Uint8List imageBytes, {
    required ImageSaveOptions options,
  }) =>
      _platform.saveImage(imageBytes, options: options);
}
