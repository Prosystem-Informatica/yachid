import 'package:flutter/material.dart';
import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/data_field.dart';

/// Card da seção "Contato" na tela de detalhe do parceiro.
class CardPartnerContact extends StatelessWidget {
  final Widget? icon;
  final Decoration? iconDecoration;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Widget? trailing;
  final List<DataField> dataFields;
  final int crossAxisCount;
  final double childAspectRatio;
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
              _SectionHeader(
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
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
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
