import 'package:flutter/material.dart';
import 'package:t_wear/core/theme/theme.dart';

Future<bool> showConfirmationDialog(
    BuildContext context, CTheme themeMode) async {
  return await showDialog(
      context: context,
      builder: (context) => SizedBox(
            child: AlertDialog(
              title: Text(
                "Are you sure?",
                style: TextStyle(color: themeMode.primTextColor),
              ),
              content: Text(
                "You want to delete this product!",
                style: TextStyle(color: themeMode.primTextColor),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text("Delete"),
                ),
              ],
            ),
          ));
}
