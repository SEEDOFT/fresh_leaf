import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';

class RegisterWidget {
  // Build Input Field
  static Widget buildInputField({
    required String label,
    required String hint,
    required TextEditingController textController,
    String? prefixText,
    Widget? suffixIcon,
    bool obscureText = false,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: AppColors.textDark,
          ),
        ),
        TextField(
          controller: textController,
          obscureText: obscureText,
          obscuringCharacter: '•',
          keyboardType: keyboardType,
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 16,
            // Add wide letter spacing ONLY if it's an obscured password field
            letterSpacing: (isPassword && obscureText) ? 4.0 : 0.0,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppColors.textGrey.withValues(alpha: 0.5),
              fontSize: 16,
              letterSpacing: isPassword ? 4.0 : 0.0,
            ),
            prefixText: prefixText,
            prefixStyle: const TextStyle(
              color: AppColors.textDark,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            suffixIcon: suffixIcon,
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black12),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.darkGreen, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ],
    );
  }
}
