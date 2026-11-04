import 'package:flutter/material.dart';

class StatusBadgeWidget extends StatelessWidget {
  final String text;
  final Color color;

  const StatusBadgeWidget({
    super.key,
    required this.text,
    this.color = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15), // Mengganti withOpacity
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}