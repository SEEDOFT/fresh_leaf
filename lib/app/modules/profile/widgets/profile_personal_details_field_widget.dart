import 'package:flutter/material.dart';
import 'package:fresh_leaf/shared/widgets/app_text_field.dart';

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
    return AppTextField(
      label: label,
      controller: controller,
      keyboardType: keyboard,
      prefixIcon: Icon(icon, size: 18),
    );
  }
}
