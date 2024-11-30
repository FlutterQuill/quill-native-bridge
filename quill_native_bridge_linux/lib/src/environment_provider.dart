import 'dart:io';

import 'package:flutter/material.dart';

abstract class EnvironmentProvider {
  Map<String, String?> get environment;

  static EnvironmentProvider _instance = DefaultEnvironmentProvider();

  static EnvironmentProvider get instance => _instance;

  @visibleForTesting
  static void set instance(value) => _instance = value;

  static void setToDefault() => _instance = DefaultEnvironmentProvider();
}

class DefaultEnvironmentProvider implements EnvironmentProvider {
  @override
  Map<String, String?> get environment => Platform.environment;
}
