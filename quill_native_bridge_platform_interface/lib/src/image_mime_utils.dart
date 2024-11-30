String getImageMimeType(String imageFileExtension) {
  return switch (imageFileExtension.toLowerCase()) {
    'jpg' => 'image/jpeg',
    'jpeg' => 'image/jpeg',
    'png' => 'image/png',
    'gif' => 'image/gif',
    'bmp' => 'image/bmp',
    'webp' => 'image/webp',
    'svg' => 'image/svg+xml',
    String() => throw ArgumentError(
        'Unsupported image file extension: $imageFileExtension.',
      ),
  };
}
