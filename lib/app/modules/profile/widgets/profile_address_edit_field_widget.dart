import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileAddressEditField extends StatelessWidget {
  const ProfileAddressEditField({
    required this.label,
    required this.controller,
    super.key,
    this.hintText = '',
    this.keyboardType,
    this.inputFormatters,
    this.maxLines = 1,
  });

  final String label;
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: scheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: scheme.surfaceContainerHighest,
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}
