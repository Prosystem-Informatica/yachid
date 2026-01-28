import 'package:flutter/material.dart';

Widget SideBarItemWidget(IconData icon, String label) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Icon(icon, color: Colors.white70),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    ),
  );
}
