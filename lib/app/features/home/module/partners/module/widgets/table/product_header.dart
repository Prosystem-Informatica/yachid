import 'package:flutter/material.dart';
import 'package:yachid/app/core/ui/app_colors.dart';

class PartnersTableHeaderCell extends StatelessWidget {
  final String label;
  final double width;

  const PartnersTableHeaderCell({
    super.key,
    required this.label,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
          color: AppColors.gray700,
        ),
      ),
    );
  }
}
