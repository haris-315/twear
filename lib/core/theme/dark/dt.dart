// ignore_for_file: overridden_fields

import 'package:flutter/material.dart';
import 'package:t_wear/core/theme/cubit/theme_cubit.dart';
import 'package:t_wear/core/theme/theme.dart';

class DarkTheme extends CTheme {
  @override
  Color? backgroundColor = Colors.grey[900];
  @override
  Color? buttonColor = Colors.grey[900];
  @override
  Color? borderColor = Colors.white;
  @override
  Color? borderColor2 = Colors.pink[600];

  @override
  Color? primTextColor = const Color.fromARGB(255, 255, 255, 255);
  @override
  Color? appBarColor = Colors.grey[900];
  @override
  Color? secondaryTextColor = Colors.white.withOpacity(.8);
  @override
  Color? oppositeTextColor = Colors.white;
  @override
  Color? shadowColor = Colors.white.withOpacity(.3);
  @override
  Color? iconColor = Colors.white.withOpacity(.8);
  @override
  Color? oppositeShimmerColor = Colors.white.withOpacity(.8);

  @override
  ThemeData getTheme() {
    return ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: AppBarTheme(backgroundColor: appBarColor),
        textTheme: TextTheme(
            bodyMedium: TextStyle(color: primTextColor, fontFamily: "arial")));
  }

  @override
  ThemeType getThemeType() => Dark();
}
