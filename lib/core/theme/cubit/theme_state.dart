part of 'theme_cubit.dart';

sealed class ThemeMode {
  static DarkTheme dT = DarkTheme();
  static LightTheme lT = LightTheme();
}

class ThemeType {}

class Light extends ThemeType {}

class Dark extends ThemeType {}
