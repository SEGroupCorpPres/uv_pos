import 'package:uv_pos/core/core.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage(
    this.imageUrl, {
    super.key,
    this.fit,
    this.width,
    this.height,
  });

  final String imageUrl;
  final BoxFit? fit;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit ?? BoxFit.contain,
      width: width ?? context.width,
      height: height ?? context.width,
      errorWidget: (context, url, error) => Image.asset(
        Assets.iconsGlobeError,
        fit: fit ?? BoxFit.contain,
        width: width ?? context.width,
        height: height ?? context.width,
      ),
      placeholder: (context, url) => Image.asset(
        Assets.iconsGlobeError,
        fit: fit ?? BoxFit.contain,
        width: width ?? context.width,
        height: height ?? context.width,
      ),
    );
  }
}
