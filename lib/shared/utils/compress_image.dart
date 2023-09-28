import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<File> compressImage(XFile originalImageFile) async {
  final result = await FlutterImageCompress.compressWithFile(
    originalImageFile.path,
    quality: 70,
    format: CompressFormat.webp,
  );

  if (result != null &&
      result.length < File(originalImageFile.path).lengthSync()) {
    final compressedImageFile =
        File(originalImageFile.path.replaceAll('.jpg', '_compressed.jpg'));

    await compressedImageFile.writeAsBytes(result);

    return compressedImageFile;
  } else {
    return File(originalImageFile.path);
  }
}
