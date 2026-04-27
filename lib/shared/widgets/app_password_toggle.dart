import 'package:flutter/material.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';

class AppPasswordToggle extends StatelessWidget {
  const AppPasswordToggle({
    required this.isVisible,
    required this.onPressed,
    super.key,
  });

  final bool isVisible;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return IconButton(
      icon: Icon(
        isVisible ? Icons.visibility : Icons.visibility_off,
        color: scheme.onSurfaceVariant,
        size: 20.scaled,
      ),
      onPressed: onPressed,
    );
  }
}
