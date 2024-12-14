// ignore_for_file: avoid_print

import 'dart:io';

void main(List<String> args) {
  final result = Process.runSync('ktlint', ['--format']);
  print(result.stdout);
}
