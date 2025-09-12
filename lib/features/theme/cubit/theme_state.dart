part of 'theme_cubit.dart';

class ThemeState {
  const ThemeState(this.themeMode);

  final ThemeMode themeMode;

  bool get isLight => themeMode == ThemeMode.light;
  bool get isDark => themeMode == ThemeMode.dark;
  bool get isSystem => themeMode == ThemeMode.system;

  String get themeName => switch (themeMode) {
    ThemeMode.light => 'Light',
    ThemeMode.dark => 'Dark', 
    ThemeMode.system => 'System',
  };
}