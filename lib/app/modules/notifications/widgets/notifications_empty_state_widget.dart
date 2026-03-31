import 'package:flutter/material.dart';

class NotificationsEmptyState extends StatelessWidget {
  const NotificationsEmptyState({super.key, required this.scheme});
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      children: [
        const SizedBox(height: 120),
        Icon(
          Icons.notifications_none_rounded,
          size: 56,
          color: scheme.onSurfaceVariant,
        ),
        const SizedBox(height: 12),
        Text(
          'You’re all caught up',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 16,
            color: scheme.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'We’ll drop your updates here.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: scheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
