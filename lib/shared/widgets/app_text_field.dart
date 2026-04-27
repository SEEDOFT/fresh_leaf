import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.label,
    required this.controller,
    this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.suffixIcon,
    this.prefixIcon,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.textInputAction,
    super.key,
  });

  final String label;
  final TextEditingController controller;
  final String? hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.scaled,
            fontWeight: FontWeight.w600,
            color: scheme.onSurface.withValues(alpha: 0.8),
          ),
        ),
        SizedBox(height: 8.scaled),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
          textInputAction: textInputAction,
          style: TextStyle(
            color: scheme.onSurface,
            fontSize: 16.scaled,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: isDark 
                ? scheme.surfaceContainerHighest.withValues(alpha: 0.4)
                : scheme.surfaceContainerHighest.withValues(alpha: 0.6),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.scaled,
              vertical: 16.scaled,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.scaled),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.scaled),
              borderSide: BorderSide(
                color: scheme.primary.withValues(alpha: 0.5),
                width: 1.5.scaled,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
