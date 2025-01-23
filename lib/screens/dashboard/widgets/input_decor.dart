import 'package:flutter/material.dart';
import 'package:t_wear/core/theme/theme.dart';

InputDecoration inputDecor(
        {required String ht,
        required String hit,
        required IconData icon,
        required CTheme themeMode}) =>
    InputDecoration(
      labelText: hit,
      prefixIcon: Icon(
        icon,
        color: themeMode.iconColor,
      ),
      
      contentPadding: const EdgeInsets.all(8),
      helperStyle: TextStyle(color: themeMode.primTextColor),
      labelStyle: TextStyle(
        color: themeMode.primTextColor,
        fontSize: 12,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 2,
          color: themeMode.borderColor ?? Colors.red,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 2,
          color: themeMode.borderColor2 ?? Colors.red,
        ),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          width: 2,
          color: themeMode.borderColor ?? Colors.red,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
    );
