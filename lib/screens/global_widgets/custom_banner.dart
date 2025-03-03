import 'package:flutter/material.dart';


class CustomMaterialBanner extends StatelessWidget {
  final String text;

  const CustomMaterialBanner({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    return MaterialBanner(
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue, size: 24),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
          },
          child: Text(
            'DISMISS',
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ],
      backgroundColor: Colors.blue.shade50,
      elevation: 4,
      padding: EdgeInsets.all(16),
    );
  }
}
