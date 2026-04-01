import 'package:flutter/material.dart';

class SettingsSectionTitle extends StatelessWidget {
  const SettingsSectionTitle({
    required this.title,
    required this.subtitle,
    super.key,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: scheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: scheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
