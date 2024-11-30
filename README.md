# 🪶 Flutter quill_native_bridge plugin

An internal Flutter plugin for [`flutter_quill`](https://pub.dev/packages/flutter_quill) package to access platform-specific APIs,
built following the [federated plugin architecture](https://docs.google.com/document/d/1LD7QjmzJZLCopUrFAAE98wOUQpjmguyGTN2wd_89Srs/).
A detailed explanation of the federated plugin concept can be found in the [Flutter documentation](https://docs.flutter.dev/packages-and-plugins/developing-packages#federated-plugins). 

This means the project is separated into the following packages:

1. [`quill_native_bridge`](https://pub.dev/packages/quill_native_bridge): The app-facing package that clients depend on to use the plugin. This package specifies the API used by the Flutter app.
2. [`quill_native_bridge_platform_interface`](https://pub.dev/packages/quill_native_bridge_platform_interface): The package that declares an interface that any platform package must implement to support the app-facing package.
3. The platform packages: One or more packages that contain the platform-specific implementation code. The app-facing package calls into these packages—they aren't included into an app, unless they contain platform-specific functionality:
    * [`quill_native_bridge_android`](https://pub.dev/packages/quill_native_bridge_android)
    * [`quill_native_bridge_ios`](https://pub.dev/packages/quill_native_bridge_ios)
    * [`quill_native_bridge_macos`](https://pub.dev/packages/quill_native_bridge_macos)
    * [`quill_native_bridge_linux`](https://pub.dev/packages/quill_native_bridge_linux)
    * [`quill_native_bridge_windows`](https://pub.dev/packages/quill_native_bridge_windows)
    * [`quill_native_bridge_web`](https://pub.dev/packages/quill_native_bridge_web)

For more details, refer to [quill_native_bridge README](./quill_native_bridge/README.md).
