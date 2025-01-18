import 'package:flutter/material.dart';
import 'package:t_wear/core/theme/theme.dart';
import 'package:t_wear/screens/global_widgets/glowing_container.dart';

class PrimeButton extends StatelessWidget {
  final Widget child;
  final VoidCallback action;
  final CTheme themeMode;
  final double width;
  final Color? fillColor;
  const PrimeButton(
      {super.key,
      required this.child,
      required this.action,
      required this.themeMode,
      required this.width,
      this.fillColor
      });

  @override
  Widget build(BuildContext context) {
    return glowingContainer(
        padding: 2,
        width: width,
        borders: true,
        fillColor: fillColor ?? themeMode.buttonColor,
        child: ElevatedButton(
          onPressed: action,
          style: ButtonStyle(
              shadowColor:
                  WidgetStateProperty.resolveWith((_) => Colors.transparent),
              backgroundColor: WidgetStateProperty.resolveWith(
                  (_) => fillColor ?? themeMode.buttonColor)),
          child: child,
        ),
        themeMode: themeMode);
  }
}
