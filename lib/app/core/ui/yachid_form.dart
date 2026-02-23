import 'package:flutter/material.dart';
import 'package:yachid/app/core/ui/app_colors.dart';

class YachidFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String hint;
  final double width;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final int? maxLines;
  final TextCapitalization? textCapitalization;
  final bool enabled;

  const YachidFormField({
    this.textCapitalization,
    this.enabled = true,
    this.maxLines,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    super.key,
    this.controller,
    required this.label,
    required this.hint,
    this.width = double.infinity,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      controller: controller,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      enabled: enabled,
      decoration: _decoration(label, hint: hint),
    );
  }

  InputDecoration _decoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.gray300, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.error, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      filled: true,
      fillColor: Colors.white,
    );
  }
}
