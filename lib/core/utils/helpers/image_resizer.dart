import 'package:image/image.dart' as img;
import 'package:future_pos/core/core.dart';

File resizeImage(File file, int width, int height) {
  final image = img.decodeImage(file.readAsBytesSync())!;
  final resizedImage = img.copyResize(image, width: width, height: height);
  final resizedFile = File('${file.path}_resized.png')
    ..writeAsBytesSync(img.encodePng(resizedImage));
  return resizedFile;
}
