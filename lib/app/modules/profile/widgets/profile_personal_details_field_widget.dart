import 'package:flutter/material.dart';

class PersonalDetailsField extends StatelessWidget {
  const PersonalDetailsField({
    required this.label,
    required this.icon,
    required this.controller,
    super.key,
    this.keyboard,
  });

  final String label;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType? keyboard;

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
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: scheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboard,
          decoration: InputDecoration(
            filled: true,
            fillColor: scheme.surfaceContainerHighest,
            prefixIcon: Icon(icon, size: 18, color: scheme.onSurfaceVariant),
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
