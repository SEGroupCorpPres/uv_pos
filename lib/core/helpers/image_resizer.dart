import 'dart:io';
import 'package:image/image.dart' as img;

File resizeImage(File file, int width, int height) {
  final image = img.decodeImage(file.readAsBytesSync())!;
  final resizedImage = img.copyResize(image, width: width, height: height);
  final resizedFile = File('${file.path}_resized.png')..writeAsBytesSync(img.encodePng(resizedImage));
  return resizedFile;
}