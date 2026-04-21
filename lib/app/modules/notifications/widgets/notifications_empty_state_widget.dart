import 'package:flutter/material.dart';
import 'package:fresh_leaf/shared/widgets/app_empty_state.dart';

class NotificationsEmptyState extends StatelessWidget {
  const NotificationsEmptyState({required this.scheme, super.key});
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return const AppEmptyState(
      icon: Icons.notifications_none_rounded,
      title: 'You’re all caught up',
      subtitle: 'We’ll drop your updates here.',
    );
  }
}
