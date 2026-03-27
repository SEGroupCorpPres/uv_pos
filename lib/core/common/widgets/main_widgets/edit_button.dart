import 'package:future_pos/core/core.dart';

class EditButton extends StatelessWidget {
  const EditButton({super.key, this.onTap});

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return AppInkWell(
      borderRadius: BorderRadius.circular(5.r),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r)),
        child: AppText(
          LocaleKeys.edit.tr(context: context),
          style: AppTextStyle.style14Medium.copyWith(color: AppColors.zn300),
        ),
      ),
    );
  }
}
