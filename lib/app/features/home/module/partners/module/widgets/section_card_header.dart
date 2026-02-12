import 'package:flutter/material.dart';
import 'package:yachid/app/core/ui/app_colors.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.trailing,
    this.iconDecoration,
  });

  final Widget icon;
  final String title;
  final String description;
  final Decoration? iconDecoration;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: iconDecoration,
            child: icon,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Hind-Semi-Bold',
                    fontSize: 16,
                    color: AppColors.textOnPrimaryLight,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          trailing ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
