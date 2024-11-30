import 'package:flutter/foundation.dart' show immutable;

@immutable
class GalleryImageSaveOptions {
  const GalleryImageSaveOptions({
    required this.name,
    required this.fileExtension,
    required this.albumName,
  });

  final String name;
  final String fileExtension;
  final String? albumName;

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! GalleryImageSaveOptions) return false;
    return other.name == name &&
        other.fileExtension == fileExtension &&
        other.albumName == albumName;
  }

  @override
  int get hashCode => Object.hash(name, fileExtension, albumName);

  @override
  String toString() =>
      'GalleryImageSaveOptions(name: $name, fileExtension: $fileExtension, albumName: $albumName)';
}

@immutable
class ImageSaveOptions {
  const ImageSaveOptions({
    required this.name,
    required this.fileExtension,
  });

  final String name;
  final String fileExtension;

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! ImageSaveOptions) return false;
    return other.name == name && other.fileExtension == fileExtension;
  }

  @override
  int get hashCode => Object.hash(name, fileExtension);

  @override
  String toString() =>
      'ImageSaveOptions(name: $name, fileExtension: $fileExtension)';
}
