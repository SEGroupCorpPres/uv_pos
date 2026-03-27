import 'package:future_pos/core/core.dart';

/// TODO : REMOVE
class AccountMultiTileItem extends StatelessWidget {
  const AccountMultiTileItem({
    super.key,
    required this.params,
    required this.currentIndex,
    required this.itemLength,
  });

  final AccountTileParams params;
  final int currentIndex;
  final int itemLength;

  @override
  Widget build(BuildContext context) {
    return AppInkWell(
      onTap: params.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            const VerticalSpace(12),
            Row(
              children: [
                AppText(params.title, style: AppTextStyle.style16Regular),
                const Spacer(),
                Visibility(
                  visible: params.trailingSvgIcon != null,
                  replacement: Icon(
                    context.isArabic
                        ? Icons.keyboard_arrow_left_outlined
                        : Icons.keyboard_arrow_right_outlined,
                    color: AppColors.black,
                    size: 28,
                  ),
                  child: AppSvgImage(
                    path: params.trailingSvgIcon ?? '',
                    size: params.trailingSvgIconSize ?? 32,
                  ),
                ),
              ],
            ),
            const VerticalSpace(12),
            if (currentIndex != (itemLength - 1)) const AppDivider(),
          ],
        ),
      ),
    );
  }
}

class AccountTileParams extends Equatable {
  final String title;
  final String? trailingSvgIcon;
  final double? trailingSvgIconSize;

  final void Function()? onTap;

  const AccountTileParams({
    required this.title,
    this.trailingSvgIcon,
    this.trailingSvgIconSize,
    this.onTap,
  });

  @override
  List<Object?> get props => [
        title,
        trailingSvgIcon,
        trailingSvgIconSize,
        onTap,
      ];
}
