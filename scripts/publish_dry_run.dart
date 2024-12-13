import 'dart:io';

import 'packages.dart';

void main(List<String> args) {
  for (final package in packages) {
    Process.runSync('flutter', ['pub', 'publish', '--dry-run'],
        workingDirectory: package);
  }
}
