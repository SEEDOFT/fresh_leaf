import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notifications_controller.dart';

class NotificationTypeChip extends StatelessWidget {
  const NotificationTypeChip({
    super.key,
    required this.item,
    required this.scheme,
  });

  final NotificationItem item;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final color = _chipColor();
    final icon = _icon();
    final label = item.type.capitalizeFirst ?? item.type;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Color _chipColor() {
    switch (item.type) {
      case 'order':
        return scheme.primary;
      case 'promo':
        return scheme.secondary;
      case 'system':
      default:
        return scheme.tertiary;
    }
  }

  IconData _icon() {
    switch (item.type) {
      case 'order':
        return Icons.local_shipping_rounded;
      case 'promo':
        return Icons.loyalty_rounded;
      case 'system':
      default:
        return Icons.notifications_active_outlined;
    }
  }
}
