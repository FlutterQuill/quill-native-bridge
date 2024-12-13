// ignore_for_file: avoid_print

import 'dart:io';

void main(List<String> args) {
  const swiftPackages = [
    'quill_native_bridge_ios/ios/quill_native_bridge_ios',
    'quill_native_bridge_macos/macos/quill_native_bridge_macos',
  ];
  for (final swiftPackageDirectory in swiftPackages) {
    final result = Process.runSync(
        'swift-format', ['format', '--recursive', '-i', swiftPackageDirectory]);
    print(result.stdout);
  }
}
