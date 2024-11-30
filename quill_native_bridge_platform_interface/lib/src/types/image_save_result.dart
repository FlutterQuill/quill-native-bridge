import 'package:flutter/foundation.dart';

@immutable
class ImageSaveResult {
  const ImageSaveResult({
    required this.filePath,
    required this.blobUrl,
  });

  factory ImageSaveResult.io({required String? filePath}) =>
      ImageSaveResult(filePath: filePath, blobUrl: null);

  factory ImageSaveResult.web({required String blobUrl}) =>
      ImageSaveResult(filePath: null, blobUrl: blobUrl);

  final String? filePath;
  final String? blobUrl;

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! ImageSaveResult) return false;
    return other.filePath == filePath && other.blobUrl == blobUrl;
  }

  @override
  int get hashCode => Object.hash(filePath, blobUrl);

  @override
  String toString() =>
      'ImageSaveResult(filePath: $filePath, blobUrl: $blobUrl)';
}
