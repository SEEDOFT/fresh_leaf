import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterWidget {
  static Widget buildInputField({
    required BuildContext context,
    required String label,
    required String hint,
    required TextEditingController textController,
    String? prefixText,
    Widget? suffixIcon,
    bool obscureText = false,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = scheme.onSurfaceVariant;
    final borderColor = isDark
        ? scheme.outline.withValues(alpha: 0.95)
        : scheme.outline.withValues(alpha: 0.65);
    final fillColor = isDark
        ? scheme.surfaceContainerHighest.withValues(alpha: 0.65)
        : scheme.surface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: labelColor,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: textController,
          obscureText: obscureText,
          obscuringCharacter: '•',
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          cursorColor: scheme.primary,
          style: TextStyle(
            color: scheme.onSurface,
            fontSize: 16,
            letterSpacing: (isPassword && obscureText) ? 4.0 : 0.0,
          ),
          decoration: InputDecoration(
            hintText: hint,
            isDense: true,
            hintStyle: TextStyle(
              color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
              fontSize: 15,
              letterSpacing: isPassword ? 4.0 : 0.0,
            ),
            filled: true,
            fillColor: fillColor,
            prefixText: prefixText,
            prefixStyle: TextStyle(
              color: scheme.primary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
            suffixIcon: suffixIcon,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: scheme.primary, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}
