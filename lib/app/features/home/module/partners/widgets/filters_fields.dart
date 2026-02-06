import 'package:flutter/material.dart';

class FilterField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final double width;
  final int? maxLength;
  final ValueChanged<String> onChanged;
  final InputDecoration decoration;

  const FilterField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.width,
    this.maxLength,
    required this.onChanged,
    required this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        maxLength: maxLength,
        decoration: decoration.copyWith(labelText: label, hintText: hint),
      ),
    );
  }
}
