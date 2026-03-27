import 'package:future_pos/core/core.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeChangedState(isDark: false)) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final isDark = PrefHelper.get(PrefKeys.currentTheme) ?? false;
    emit(const ThemeChangedState(isDark: true));
  }

  Future<void> changeTheme({required bool isDark}) async {
    // AppDynamicColors.isDark = null;
    await PrefHelper.save(PrefKeys.currentTheme, isDark.toString());
    emit(ThemeChangedState(isDark: isDark));
  }

  Future<void> toggleTheme() async {
    final currentTheme = state.isDark;
    await changeTheme(isDark: !currentTheme);
  }
}
