import 'package:flutter/widgets.dart';
import 'package:t_wear/core/theme/theme.dart';

Widget buildItem({
  required IconData icon,
  required String label,
  required String value,
  required CTheme themeMode,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: themeMode.secondaryTextColor, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "$label: ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: themeMode.primTextColor,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontSize: 16,
                    color: themeMode.primTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
