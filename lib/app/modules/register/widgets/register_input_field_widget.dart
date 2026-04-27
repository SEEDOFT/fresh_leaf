import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fresh_leaf/shared/widgets/app_text_field.dart';

class RegisterWidget {
  static Widget buildInputField({
    required BuildContext context,
    required String label,
    required String hint,
    required TextEditingController textController,
    Widget? prefixIcon,
    String? prefixText,
    Widget? suffixIcon,
    bool obscureText = false,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return AppTextField(
      label: label,
      controller: textController,
      hintText: hint,
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
    );
  }
}
