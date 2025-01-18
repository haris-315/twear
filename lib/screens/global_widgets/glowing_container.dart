import 'package:flutter/material.dart';
import 'package:t_wear/core/theme/theme.dart';

Container glowingContainer(
    {required Widget child,
    Color? fillColor,
    double? width,
    double? height,
    BoxDecoration? decor,
    required CTheme themeMode,
    double radius = 8,
    double padding = 10,
    bool borders = false,
    BoxShape shape = BoxShape.rectangle}) {
  return Container(
      width: width,
      height: height,
      padding: shape == BoxShape.circle ? null : EdgeInsets.all(padding),
      decoration: decor ??
          BoxDecoration(
            border: borders ? Border.all(color: themeMode.borderColor ?? Colors.transparent, width: 1) : null,
            color: fillColor ?? Colors.blue.withOpacity(0.6),
            borderRadius:
                shape == BoxShape.circle ? null : BorderRadius.circular(radius),
            shape: shape,
            boxShadow: [
              BoxShadow(
                color: themeMode.shadowColor ?? Colors.black.withOpacity(.3),
                blurRadius: 12,
                spreadRadius: 4,
              ),
            ],
          ),
      child: child);
}
