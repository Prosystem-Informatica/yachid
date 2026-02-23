import 'package:flutter/material.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/section_card_header.dart';

class CardPartnerContact extends StatelessWidget {
  final void Function(bool isEditing)? setIsEditing;
  final Widget? icon;
  final Decoration? iconDecoration;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final List<Widget> widgets;
  final int crossAxisCount;
  final double childAspectRatio;
  final Widget? footer;
  final int columns;
  final VoidCallback? onEdit;
  final bool isEditing;
  final EdgeInsets padding;

  const CardPartnerContact({
    this.padding = const EdgeInsets.fromLTRB(20, 20, 20, 0),
    this.setIsEditing,
    this.onEdit,
    required this.widgets,
    super.key,
    this.icon,
    this.iconDecoration,
    required this.title,
    this.subtitle,
    this.trailing,
    this.crossAxisCount = 2,
    this.childAspectRatio = 6,
    this.footer,
    this.columns = 2,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Material(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SectionHeader(
              setIsEditing: setIsEditing,
              trailing: trailing,
              iconDecoration: iconDecoration,
              icon: icon ?? const SizedBox.shrink(),
              title: title,
              description: subtitle ?? '',
              isEditing: isEditing,
              onEdit: onEdit,
            ),
            ...widgets.map(
              (widget) =>
                  Padding(padding: EdgeInsetsGeometry.all(36), child: widget),
            ),
          ],
        ),
      ),
    );
  }
}
