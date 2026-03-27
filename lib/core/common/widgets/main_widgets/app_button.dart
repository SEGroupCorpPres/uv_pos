import 'package:future_pos/core/core.dart';

class AppButton extends StatelessWidget {
  const AppButton({
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
  });

  const AppButton.expand({
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
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    if (isExpand) {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: padding,
                fixedSize: fixedSize ?? const Size.fromHeight(50),
                foregroundColor: foregroundColor ?? Colors.white,
                backgroundColor: backgroundColor ?? AppColors.blue,
                disabledBackgroundColor: backgroundColor ?? AppColors.blue,
                disabledForegroundColor: foregroundColor ?? Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      borderRadius ?? AppUtilConstants.borderRadiusCircular,
                ),
              ),
              onPressed: isLoading ? () {} : onPressed,
              child: isLoading
                  ? const Center(
                      child: SpinKitThreeBounce(
                        color: AppColors.white,
                        size: 35,
                      ),
                    )
                  : AppText(
                      text,
                      style: textStyle ??
                          AppTextStyle.style18SemiBold.copyWith(
                            color: textColor ?? Colors.white,
                          ),
                    ),
            ),
          ),
        ],
      );
    } else {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: padding,
          fixedSize: fixedSize ?? const Size.fromHeight(50),
          foregroundColor: foregroundColor ?? Colors.white,
          backgroundColor: backgroundColor ?? AppColors.blue,
          disabledBackgroundColor: backgroundColor ?? AppColors.blue,
          disabledForegroundColor: foregroundColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? AppUtilConstants.borderRadiusCircular,
          ),
        ),
        onPressed: isLoading ? () {} : onPressed,
        child: isLoading
            ? const SpinKitThreeBounce(
                color: AppColors.white,
                size: 35,
              )
            : AppText(
                text,
                style: textStyle ??
                    AppTextStyle.style18SemiBold.copyWith(
                      color: textColor ?? Colors.white,
                    ),
              ),
      );
    }
  }
}
