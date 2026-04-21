import 'package:flutter/material.dart';
import 'package:fresh_leaf/shared/widgets/app_text_field.dart';

class SecurityPasswordField extends StatefulWidget {
  const SecurityPasswordField({
    required this.label,
    super.key,
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

    return AppTextField(
      label: widget.label,
      controller: widget.controller ?? TextEditingController(),
      obscureText: currentObscure,
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
    );
  }
}
