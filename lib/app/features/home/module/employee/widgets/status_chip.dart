import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  final String status;
  final Color color;
  const StatusChip({super.key, required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontFamily: 'Hind-Semi-Bold',
        ),
      ),
    );
  }
}
