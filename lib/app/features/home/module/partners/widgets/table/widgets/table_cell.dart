import 'package:flutter/material.dart';
import 'package:yachid/app/core/ui/app_colors.dart';

class PartnersTableCell extends StatelessWidget {
  final String? text;
  final double width;
  final bool bold;
  final Widget? child;

  const PartnersTableCell({
    super.key,
    this.text,
    required this.width,
    this.bold = false,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child:
          child ??
          Text(
            text ?? '—',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
              color: AppColors.gray800,
            ),
          ),
    );
  }
}
