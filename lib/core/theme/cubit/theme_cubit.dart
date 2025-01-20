import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_wear/core/theme/dark/dt.dart';
import 'package:t_wear/core/theme/light/lt.dart';
import 'package:t_wear/core/theme/theme.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<CTheme> {
  ThemeCubit() : super(ThemeMode.lT);

  void toggleTheme(ThemeType themeType) {
    emit(themeType is Dark ? ThemeMode.dT : ThemeMode.lT);
  }
}
