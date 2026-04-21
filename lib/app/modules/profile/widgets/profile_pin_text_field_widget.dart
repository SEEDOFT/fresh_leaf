import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fresh_leaf/shared/widgets/app_text_field.dart';
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
    return AppTextField(
      label: label,
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: inputFormatters,
      obscureText: true,
      hintText: 'enter_6_digits'.tr,
    );
  }
}
