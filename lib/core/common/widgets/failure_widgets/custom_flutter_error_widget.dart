import 'package:future_pos/core/core.dart';

class CustomFlutterErrorWidget extends StatelessWidget {
  const CustomFlutterErrorWidget({super.key, required this.errorDetails});

  final FlutterErrorDetails errorDetails;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppUtilConstants.horizontalPaddingEdge,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Icon(Icons.error_outline, color: Colors.red, size: 100.sp),
            ),
            const VerticalSpace(16),
            AppText(
              kDebugMode
                  ? errorDetails.summary.toString()
                  : 'Oops! Something went wrong!',
              style: AppTextStyle.style18SemiBold,
              maxLines: 30,
            ),
          ],
        ),
      ),
    );
  }
}
