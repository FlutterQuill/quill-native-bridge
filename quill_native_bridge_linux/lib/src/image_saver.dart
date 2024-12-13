import 'package:file_selector_linux/file_selector_linux.dart';
import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import 'environment_provider.dart';

class ImageSaver {
  /// The file selector that's used to prompt the user to choose a directory
  /// for saving an image.
  FileSelectorPlatform fileSelector = FileSelectorLinux();

  static const String linuxUserHomeEnvKey = 'HOME';

  static const String picturesDirectoryName = 'Pictures';

  String? get userHome =>
      EnvironmentProvider.instance.environment[linuxUserHomeEnvKey];

  String? get picturesDirectoryPath {
    final userHome = this.userHome;
    if (userHome == null) return null;
    if (userHome.isEmpty) return null;
    return '$userHome/$picturesDirectoryName';
  }
}
