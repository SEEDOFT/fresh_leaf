import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/notifications/controllers/notification_detail_controller.dart';
import 'package:fresh_leaf/app/modules/notifications/controllers/notifications_controller.dart';
import 'package:fresh_leaf/shared/widgets/app_badge.dart';
import 'package:fresh_leaf/shared/widgets/custom_app_bar.dart';
import 'package:get/get.dart';

class NotificationDetailView extends GetView<NotificationDetailController> {
  const NotificationDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    final item = controller.item;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: const CustomAppBar(title: 'Notification'),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildTypeBadge(item, scheme),
                const Spacer(),
                Text(
                  item.timeAgo,
                  style: TextStyle(
                    color: scheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              item.title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: scheme.onSurface,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              item.body,
              style: TextStyle(
                fontSize: 14.5,
                height: 1.6,
                color: scheme.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            FilledButton.icon(
              onPressed: Get.back<void>,
              style: FilledButton.styleFrom(
                backgroundColor: scheme.primary,
                foregroundColor: scheme.onPrimary,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.check_rounded),
              label: const Text(
                'Got it',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeBadge(NotificationItem item, ColorScheme scheme) {
    final Color color;
    final IconData icon;

    switch (item.type) {
      case 'order':
        color = scheme.primary;
        icon = Icons.local_shipping_rounded;
      case 'promo':
        color = scheme.secondary;
        icon = Icons.loyalty_rounded;
      default:
        color = scheme.tertiary;
        icon = Icons.notifications_active_outlined;
    }

    return AppBadge(
      label: item.type.capitalizeFirst ?? item.type,
      icon: icon,
      backgroundColor: color.withValues(alpha: 0.16),
      foregroundColor: color,
    );
  }
}
