import 'package:flutter/material.dart';
import 'package:t_wear/core/theme/cubit/theme_cubit.dart';
import 'package:t_wear/core/theme/theme.dart';

Widget buildKpiCard({
  required CTheme themeMode,
  required IconData icon,
  required String title,
  required String value,
  required Color color,
}) {
  return Container(
    width: 150,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: themeMode.backgroundColor,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          color.withValues(alpha: themeMode.getThemeType() is Dark ? 0.2 : 0.4),
          color.withValues(
              alpha: themeMode.getThemeType() is Dark ? 0.05 : 0.09)
        ],
      ),
    ),
    child: Column(
      children: [
        Icon(icon, size: 32, color: color),
        const SizedBox(height: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: themeMode.secondaryTextColor,
          ),
        ),
        const SizedBox(height: 8),
        Tooltip(
          message: value,
          child: Text(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: themeMode.primTextColor,
            ),
          ),
        ),
      ],
    ),
  );
}
