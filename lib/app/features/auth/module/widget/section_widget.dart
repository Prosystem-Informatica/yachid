import 'package:flutter/material.dart';

Widget sectionDropdown({
  required String keyName,
  required String title,
  required List<Widget> children,
  required Map<String, bool> openSections,
  required void Function(String key) toggle,
}) {
  final isOpen = openSections[keyName]!;

  return Card(
    elevation: 2,
    margin: const EdgeInsets.symmetric(vertical: 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => toggle(keyName),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: isOpen ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(Icons.expand_more),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 250),
          crossFadeState:
              isOpen ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(children: children),
          ),
          secondChild: const SizedBox.shrink(),
        ),
      ],
    ),
  );
}
