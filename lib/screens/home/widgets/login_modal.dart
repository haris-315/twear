import 'package:flutter/material.dart';
import 'package:t_wear/core/theme/theme.dart';
import 'package:t_wear/screens/dashboard/widgets/input_decor.dart';

void loginModal(BuildContext context, CTheme themeMode) {
  bool showPass = false; 
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: StatefulBuilder(
          builder: (context, setStateDialog) { 
            return SizedBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  TextField(
                    obscureText: !showPass,
                    obscuringCharacter: "*",
                    decoration: inputDecor(
                      ht: "Email",
                      hit: "Email",
                      icon: Icons.email,
                      themeMode: themeMode,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    obscureText: !showPass,
                    decoration: InputDecoration(
                      labelText: "Password",
                      suffixIcon: IconButton(
                        onPressed: () {
                          setStateDialog(() { 
                            showPass = !showPass;
                          });

                        },
                        icon: Icon(showPass ? Icons.visibility : Icons.visibility_off_outlined),
                      ),
                      prefixIcon: Icon(Icons.lock, color: themeMode.iconColor),
                      contentPadding: const EdgeInsets.all(8),
                      helperStyle: TextStyle(color: themeMode.primTextColor),
                      labelStyle: TextStyle(color: themeMode.primTextColor, fontSize: 12),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: themeMode.borderColor ?? Colors.red),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: themeMode.borderColor2 ?? Colors.red),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: themeMode.borderColor ?? Colors.red),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
