import 'package:flutter/material.dart';
import 'package:t_wear/core/theme/theme.dart';
import 'package:t_wear/core/utils/screen_size.dart';

class ImagesButton extends StatelessWidget {
  final VoidCallback onpress;
  final CTheme themeMode;
  const ImagesButton(
      {super.key, required this.onpress, required this.themeMode});

  @override
  Widget build(BuildContext context) {
    double width = getScreenSize(context).first;
    double height = getScreenSize(context).last;
    return InkWell(
      onTap: onpress,
      child: Container(
        decoration: BoxDecoration(
          color: themeMode.backgroundColor,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: themeMode.borderColor ?? Colors.red,
            width: 1,
          ),
        ),
        width: width * .12,
        height: height * .2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              size: 28,
              color: themeMode.iconColor,
            ),
            const SizedBox(
              height: 14,
            ),
            Icon(
              Icons.add_photo_alternate,
              size: 34,
              color: themeMode.iconColor,
            )
          ],
        ),
      ),
    );
  }
}
