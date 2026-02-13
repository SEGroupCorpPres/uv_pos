import 'package:uv_pos/core/core.dart';

part 'localization_state.dart';

class LocalizationCubit extends Cubit<LocalizationState> {
  LocalizationCubit(BuildContext context) : super(const LocalizationChanged()) {
    _loadLanguage(context);
  }

  Future<void> _loadLanguage(BuildContext context) async {
    final languageCode = PrefHelper.get(PrefKeys.currentLanguage) ?? AppStrings.enLanguage;
    await AppMethods.changeLanguage(context, locale: Locale('uz'));
  }
}
