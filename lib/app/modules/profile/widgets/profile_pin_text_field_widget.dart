import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PinTextField extends StatelessWidget {
  const PinTextField({
    required this.label,
    required this.controller,
    required this.inputFormatters,
    super.key,
  });

  final String label;
  final TextEditingController controller;
  final List<TextInputFormatter> inputFormatters;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: scheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: inputFormatters,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'enter_6_digits'.tr,
            hintStyle: TextStyle(color: scheme.onSurfaceVariant),
            filled: true,
            fillColor: scheme.surfaceContainerHighest,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: scheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: scheme.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
