import 'package:flutter/material.dart';
import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/core/ui/yachid_form.dart';

class DataField extends StatelessWidget {
  final TextEditingController? controller;
  final bool isEditing;
  final bool enabled;
  const DataField({
    super.key,
    this.isEditing = false,
    this.enabled = true,
    required this.label,
    this.value,
    this.icon,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.controller,
  });

  final String label;

  final Object? value;
  final Widget? icon;

  final CrossAxisAlignment crossAxisAlignment;

  static String displayValue(Object? value) {
    if (value == null) return '—';
    if (value is String && value.isEmpty) return '—';
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final display = displayValue(value);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            letterSpacing: 1.2,
            fontFamily: 'Frutiger_bold',
            color: AppColors.gray600,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          spacing: 8,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              DefaultTextStyle(
                style: TextStyle(fontSize: 14, color: AppColors.gray600),
                child: icon!,
              ),
              const SizedBox(width: 8),
            ],
            Expanded(
              flex: 1,
              child:
                  isEditing
                      ? YachidFormField(
                        enabled: enabled,
                        label: label,
                        textCapitalization: null,
                        keyboardType: null,
                        textInputAction: null,
                        validator: null,
                        controller: controller,
                        hint: '',
                      )
                      : Text(
                        display,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.gray600,
                        ),
                      ),
            ),
          ],
        ),
      ],
    );
  }
}
