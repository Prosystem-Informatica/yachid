import 'package:flutter/material.dart';
import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/data_field.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/section_card_header.dart';

class CardPartnerContact extends StatelessWidget {
  final Widget? icon;
  final Decoration? iconDecoration;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Widget? trailing;
  final List<Widget> dataFields;
  final int crossAxisCount;
  final double childAspectRatio;
  final Widget? footer;
  const CardPartnerContact({
    required this.dataFields,
    super.key,
    this.icon,
    this.iconDecoration,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.trailing,
    this.crossAxisCount = 2,
    this.childAspectRatio = 6,
    this.footer,
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
          onTap: () {},
          child: Column(
            children: [
              SectionHeader(
                trailing: trailing,
                iconDecoration: iconDecoration,
                icon: icon ?? const SizedBox.shrink(),
                title: title,
                description: subtitle ?? '',
              ),

              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                childAspectRatio: childAspectRatio,
                shrinkWrap: true,
                mainAxisSpacing: 16,
                crossAxisSpacing: 32,
                padding: EdgeInsets.all(24),
                children: [...dataFields],
              ),
              if (footer != null) ...[
                Padding(
                  padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: footer!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
