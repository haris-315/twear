import 'package:flutter/material.dart';

class Discount extends StatelessWidget {
  final dynamic discount;
  final double size;
  final Color color;
  const Discount({super.key, required this.discount, this.size = 16, this.color = Colors.lightGreen});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        "$discount",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
          fontSize: size,
        ),
      ),
    );
  }
}
