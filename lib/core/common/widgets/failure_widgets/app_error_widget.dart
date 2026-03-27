import 'package:future_pos/core/core.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    super.key,
    this.failure,
    this.onPressed,
    this.isEmpty = false,
    this.image,
    this.errorButtonMessage,
  });

  final Failure? failure;
  final void Function()? onPressed;
  final bool isEmpty;
  final Widget? image;
  final String? errorButtonMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(),
        Column(
          children: [
            (image != null)
                ? image!
                : (isEmpty)
                    ? AppAssetsImage(Assets.iconsErrorcircle,
                        fit: BoxFit.contain)
                    : AppAssetsImage(
                        failure?.code == '404'
                            ? Assets.iconsErrorcircle
                            : Assets.iconsErrorcircle,
                        fit: BoxFit.contain,
                      ),
            const Gap(10),
            AppText(
              failure?.message ?? '',
              textAlign: TextAlign.center,
              maxLines: 3,
              style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            const Gap(30),
          ],
        ),
        if (onPressed == null)
          Visibility(
            visible: false,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppSizesConstants.defaultHorizontalP.w),
              child: PrimaryButton.expand(
                text: errorButtonMessage ?? 'Reload Screen',
                onPressed: () {},
              ),
            ),
          ),
        if (onPressed != null)
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: AppSizesConstants.defaultHorizontalP.w),
                child: PrimaryButton.expand(
                  text: errorButtonMessage ?? 'Reload Screen',
                  onPressed: onPressed,
                ),
              ),
              Gap(kBottomNavigationBarHeight.h + 24.h),
            ],
          ),
      ],
    );
  }
}
