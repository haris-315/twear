import 'package:flutter/material.dart';
import 'package:t_wear/core/theme/theme.dart';

Future<bool> showConfirmationDialog(
    BuildContext context, CTheme themeMode, {String msg = "You want to delete this product!",String b1 = "Cancel", String b2 = "Delete"}) async {
  return await showDialog(
      context: context,
      builder: (context) => SizedBox(
            child: AlertDialog(
              title: Text(
                "Are you sure?",
                style: TextStyle(color: themeMode.primTextColor),
              ),
              content: Text(
                msg,
                style: TextStyle(color: themeMode.primTextColor),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(b1),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(b2),
                ),
              ],
            ),
          ));
}
