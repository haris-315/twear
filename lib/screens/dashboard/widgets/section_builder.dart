import 'package:flutter/widgets.dart';
import 'package:t_wear/core/theme/theme.dart';

Widget buildSection({
    required CTheme themeMode,
    required String sectionTitle,
    required List<Widget> items,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sectionTitle,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: themeMode.primTextColor,
            ),
          ),
          const SizedBox(height: 10),
          ...items,
        ],
      ),
    );
  }