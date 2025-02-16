import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_wear/core/theme/dark/dt.dart';
import 'package:t_wear/core/theme/light/lt.dart';
import 'package:t_wear/core/theme/theme.dart';
import 'package:t_wear/core/utils/get_theme_state.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<CTheme> {
  List<ThemeChangeEvent> events = [];
  ThemeCubit() : super(ThemeMode.lT);

  void toggleTheme(ThemeType themeType) {
    for (var e in events) {
      e.onChange(themeType is Dark ? ThemeMode.dT : ThemeMode.lT);
    }
    emit(themeType is Dark ? ThemeMode.dT : ThemeMode.lT);
  }

  void registerEvent(ThemeChangeEvent event) {
    events.add(event);
    return;
  }

  void flushEvent(ThemeChangeEvent event) {
    events.remove(event);
    return;
  }
}
