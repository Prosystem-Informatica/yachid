import 'package:flutter/material.dart';
import 'package:yachid/app/core/ui/app_colors.dart';

class SectionHeader extends StatefulWidget {
  const SectionHeader({
    this.setIsEditing,
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.trailing,
    this.iconDecoration,
    this.onEdit,
    this.isEditing = false,
  });

  final Widget icon;

  final String title;
  final String description;
  final Decoration? iconDecoration;
  final Widget? trailing;
  final void Function()? onEdit;
  final bool isEditing;
  final void Function(bool isEditing)? setIsEditing;
  @override
  State<SectionHeader> createState() => _SectionHeaderState();
}

class _SectionHeaderState extends State<SectionHeader> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: widget.iconDecoration,
            child: widget.icon,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontFamily: 'Hind-Semi-Bold',
                    fontSize: 16,
                    color: AppColors.textOnPrimaryLight,
                  ),
                ),
                Text(
                  widget.description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          widget.trailing ?? const SizedBox.shrink(),
          if (widget.onEdit != null && !widget.isEditing)
            IconButton(
              highlightColor: AppColors.primaryColor,
              splashColor: AppColors.primaryColor,
              hoverColor: AppColors.primaryColor.withValues(alpha: 0.1),
              focusColor: AppColors.primaryColor,
              color: AppColors.primaryColor,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.hovered)) {
                    return AppColors.primaryColor.withValues(alpha: 0.1);
                  }
                  return AppColors.gray300.withValues(alpha: 0.4);
                }),
                foregroundColor: WidgetStateProperty.all(
                  AppColors.textOnPrimary,
                ),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                padding: WidgetStateProperty.all(EdgeInsets.all(12)),

                overlayColor: WidgetStateProperty.all(
                  AppColors.primaryColor.withValues(alpha: 0.1),
                ),
              ),
              icon: Icon(
                Icons.mode_edit_outline,
                size: 20,
                color: AppColors.primaryColor.withValues(alpha: 0.8),
              ),
              onPressed: () {
                widget.setIsEditing?.call(true);
              },
            ),
          const SizedBox(width: 6),
          // esse cara aqui é o que vai aparecer quando estiver editando e salvar os dados
          if (widget.isEditing) ...[
            IconButton(
              onPressed: () {
                setState(() {
                  widget.onEdit?.call();
                  widget.setIsEditing?.call(false);
                });
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.hovered)) {
                    return AppColors.primaryColor;
                  }
                  return AppColors.gray300.withValues(alpha: 0.4);
                }),
                foregroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.hovered)) {
                    return AppColors.textOnPrimary;
                  }
                  return AppColors.primaryColor;
                }),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                padding: WidgetStateProperty.all(EdgeInsets.all(12)),

                overlayColor: WidgetStateProperty.all(
                  AppColors.primaryColor.withValues(alpha: 0.1),
                ),
              ),
              icon: Icon(Icons.check_rounded, size: 20),
            ),
            const SizedBox(width: 6),
            IconButton(
              onPressed: () {
                widget.setIsEditing?.call(false);
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.hovered)) {
                    return AppColors.error;
                  }

                  return AppColors.gray300.withValues(alpha: 0.4);
                }),
                foregroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.hovered)) {
                    return AppColors.textOnPrimary;
                  }
                  return AppColors.primaryColor;
                }),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                padding: WidgetStateProperty.all(EdgeInsets.all(12)),

                overlayColor: WidgetStateProperty.all(
                  AppColors.primaryColor.withValues(alpha: 0.1),
                ),
              ),
              icon: Icon(Icons.close_rounded, size: 20),
            ),
          ],
        ],
      ),
    );
  }
}
