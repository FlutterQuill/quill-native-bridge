// ignore_for_file: avoid_print

import 'dart:io';

import 'packages.dart';

void main(List<String> args) {
  for (final package in packages) {
    final result = Process.runSync('flutter', ['test', '--reporter', 'github'],
        workingDirectory: package);
    print(result.stdout);
  }
}
