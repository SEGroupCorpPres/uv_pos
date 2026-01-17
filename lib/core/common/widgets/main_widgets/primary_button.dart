import 'package:uv_pos/core/core.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    this.textStyle,
    this.backgroundColor,
    this.foregroundColor,
    this.textColor,
    this.borderRadius,
    required this.onPressed,
    this.isExpand = false,
    this.padding,
    this.isLoading = false,
    this.fixedSize,
    this.svgIconPath,
  });

  const PrimaryButton.expand({
    super.key,
    required this.text,
    this.textStyle,
    this.backgroundColor,
    this.foregroundColor,
    this.textColor,
    this.borderRadius,
    required this.onPressed,
    this.isExpand = true,
    this.padding,
    this.isLoading = false,
    this.fixedSize,
    this.svgIconPath,
  });

  final String text;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? textColor;
  final Size? fixedSize;
  final bool isExpand;
  final bool isLoading;
  final BorderRadiusGeometry? borderRadius;
  final void Function()? onPressed;
  final String? svgIconPath;

  @override
  Widget build(BuildContext context) {
    if (isExpand) {
      return Row(
        children: [
          Expanded(
            child: buildElevatedButton(),
          ),
        ],
      );
    } else {
      return buildElevatedButton();
    }
  }

  ElevatedButton buildElevatedButton() {
    return ElevatedButton(
      style: buildButtonStyleFrom(),
      onPressed: isLoading ? () {} : onPressed,
      child: isLoading
          ? const Center(
              child: SpinKitThreeBounce(
                color: AppColors.primary,
                size: 35,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(
                  text,
                  style: textStyle ??
                      AppTextStyle.style18Medium.copyWith(
                        color: textColor ?? Colors.black,
                      ),
                ),
                const HorizontalSpace(8),
                if (svgIconPath != null)
                  AppSvgImage(
                    color: AppColors.white,
                    path: svgIconPath!,
                  ),
              ],
            ),
    );
  }

  ButtonStyle buildButtonStyleFrom() {
    return ElevatedButton.styleFrom(
      padding: padding,
      fixedSize: fixedSize ?? const Size.fromHeight(48),
      foregroundColor: foregroundColor ?? AppColors.primary,
      backgroundColor: backgroundColor ?? AppColors.mainColor,
      disabledBackgroundColor: backgroundColor ?? AppColors.zn300,
      disabledForegroundColor: foregroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? AppUtilConstants.borderRadiusCircularButton,
      ),
    );
  }
}
