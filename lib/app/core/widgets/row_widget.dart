import 'package:flutter/material.dart';

Widget row(List<Widget> children) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = ((constraints.maxWidth - 12 * (children.length - 1)) /
                children.length)
            .clamp(200.0, double.infinity);

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children:
              children
                  .map((e) => SizedBox(width: itemWidth, child: e))
                  .toList(),
        );
      },
    ),
  );
}
