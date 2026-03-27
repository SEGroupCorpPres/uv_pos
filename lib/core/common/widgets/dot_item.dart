import 'package:future_pos/core/core.dart';

class DotItem extends StatelessWidget {
  const DotItem({super.key, this.isActive = false});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      height: 6,
      width: isActive ? 22 : 14,
      decoration: BoxDecoration(
        color: isActive ? AppColors.black : AppColors.black,
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}
