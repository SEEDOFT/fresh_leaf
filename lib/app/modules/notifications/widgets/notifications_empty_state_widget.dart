import 'package:flutter/material.dart';
import 'package:fresh_leaf/shared/widgets/app_empty_state.dart';

class NotificationsEmptyState extends StatelessWidget {
  const NotificationsEmptyState({required this.scheme, super.key});
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.notifications_none_rounded,
      title: 'all_caught_up'.tr,
      subtitle: 'updates_placeholder'.tr,
    );
  }
}
}
