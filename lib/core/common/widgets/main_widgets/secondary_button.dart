import 'package:future_pos/core/core.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.text,
    this.textStyle,
    this.borderColor,
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

  const SecondaryButton.expand({
    super.key,
    required this.text,
    this.textStyle,
    this.borderColor,
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
  final Color? borderColor;
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

  Widget buildElevatedButton() {
    return ElevatedButton(
      style: buildButtonStyleFrom(),
      onPressed: isLoading ? () {} : onPressed,
      child: isLoading
          ? const Center(
              child: SpinKitThreeBounce(color: AppColors.mainColor, size: 35))
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(
                  text,
                  style: textStyle ??
                      AppTextStyle.style18Medium
                          .copyWith(color: textColor ?? AppColors.zn25),
                ),
                Visibility(
                  visible: svgIconPath != null,
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      AppSvgImage(
                        path: svgIconPath ?? '',
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  ButtonStyle buildButtonStyleFrom() {
    return ElevatedButton.styleFrom(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      fixedSize: fixedSize ?? const Size.fromHeight(48),
      foregroundColor: foregroundColor ?? AppColors.mainColor,
      backgroundColor: AppColors.primary,
      elevation: 0,
      disabledBackgroundColor: AppColors.primary,
      disabledForegroundColor: foregroundColor,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius:
            borderRadius ?? AppUtilConstants.borderRadiusCircularButton,
        side: BorderSide(color: borderColor ?? AppColors.mainColor, width: 1),
      ),
    );
  }
}
