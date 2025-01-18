import 'package:flutter/material.dart';
import 'package:t_wear/core/theme/theme.dart';

// ignore: non_constant_identifier_names
AnalyticalTableRow(
    {required CTheme themeMode, required String key, required String val}) {
  return TableRow(children: [
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
          child: Text(key,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 19,
                  fontFeatures: const [FontFeature.swash(2)],
                  color: themeMode.primTextColor))),
    ),
    const VerticalDivider(),
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
          child: Text(
        val,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 19, color: themeMode.primTextColor),
      )),
    )
  ]);
}
