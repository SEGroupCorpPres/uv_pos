import 'package:future_pos/core/core.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.children,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
  });

  final List<Widget> children;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(4),
        ),
        child: Padding(
          padding: padding ??
              const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        ),
      ),
    );
  }
}
