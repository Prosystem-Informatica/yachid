import 'package:flutter/material.dart';
import 'package:yachid/app/core/ui/app_colors.dart';

class MenuCard extends StatelessWidget {
  final Widget? icon;
  final Decoration? iconDecoration;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Widget? trailing;

  const MenuCard({
    super.key,
    this.icon,
    this.iconDecoration,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                if (icon != null)
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
                          color: AppColors.secondaryColor,
                        ),
                      ),
                      if (subtitle != null) SizedBox(height: 4),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
                trailing != null
                    ? trailing!
                    : Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey[400],
                      size: 16,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
