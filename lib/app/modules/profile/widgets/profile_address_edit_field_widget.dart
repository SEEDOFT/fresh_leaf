import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fresh_leaf/shared/widgets/app_text_field.dart';

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
    return AppTextField(
      label: label,
      controller: controller,
      hintText: hintText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
    );
  }
}
