import 'package:uv_pos/core/core.dart';

class AppPopIcon extends StatelessWidget {
  const AppPopIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => GoRouterHelper(context).pop(),
      icon: Transform.rotate(
        angle: context.isArabic ? 3.14 : 0,
        child: const Icon(Icons.arrow_back_ios),
      ),
    );
  }
}
