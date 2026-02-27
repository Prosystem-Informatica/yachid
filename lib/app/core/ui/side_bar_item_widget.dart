import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SideBarItemWidget extends StatelessWidget {
  final IconData icon;
  final String label;

  final bool isSelected;
  final VoidCallback onTap;
  const SideBarItemWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white24 : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: MouseRegion(
            cursor: kIsWeb ? SystemMouseCursors.click : MouseCursor.defer,
            child: Row(
              children: [
                Icon(icon, color: Colors.white70),
                const SizedBox(width: 12),
                Text(label, style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
