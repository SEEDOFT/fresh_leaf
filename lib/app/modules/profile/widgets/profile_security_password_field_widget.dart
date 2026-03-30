import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';

class SecurityPasswordField extends StatefulWidget {
  const SecurityPasswordField({
    super.key,
    required this.label,
    this.controller,
    this.obscureText,
    this.onToggle,
  });

  final String label;
  final TextEditingController? controller;
  final bool? obscureText;
  final VoidCallback? onToggle;

  @override
  State<SecurityPasswordField> createState() => _SecurityPasswordFieldState();
}

class _SecurityPasswordFieldState extends State<SecurityPasswordField> {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final currentObscure = widget.obscureText ?? obscure;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: scheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: widget.controller,
          obscureText: currentObscure,
          obscuringCharacter: '•',
          decoration: InputDecoration(
            hintText: '••••••••',
            filled: true,
            fillColor: scheme.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.grayBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: scheme.primary,
                width: 1.5,
              ),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                currentObscure ? Icons.visibility_off : Icons.visibility,
                color: scheme.onSurfaceVariant,
              ),
              onPressed: () {
                if (widget.onToggle != null) {
                  widget.onToggle!();
                  return;
                }
                setState(() => obscure = !obscure);
              },
            ),
          ),
        ),
      ],
    );
  }
}
