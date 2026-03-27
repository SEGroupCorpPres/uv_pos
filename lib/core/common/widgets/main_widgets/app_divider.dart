import 'package:future_pos/core/core.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({
    super.key,
    this.color,
    this.height,
    this.endIndent,
    this.indent,
    this.thickness,
  });

  final Color? color;
  final double? height;
  final double? endIndent;
  final double? indent;
  final double? thickness;

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: color ?? AppColors.divider,
      height: height ?? 0,
      endIndent: endIndent,
      indent: indent,
      thickness: thickness,
    );
  }
}
