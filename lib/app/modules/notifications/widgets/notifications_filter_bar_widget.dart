import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notifications_controller.dart';

class NotificationsFilterBar extends StatelessWidget {
  const NotificationsFilterBar({super.key, required this.controller});
  final NotificationsController controller;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final filters = const [
      {'label': 'All', 'value': 'all', 'icon': Icons.inbox_outlined},
      {'label': 'Orders', 'value': 'order', 'icon': Icons.local_shipping_outlined},
      {'label': 'Promos', 'value': 'promo', 'icon': Icons.local_offer_outlined},
      {'label': 'System', 'value': 'system', 'icon': Icons.settings_suggest_outlined},
    ];
    return Obx(
      () => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((f) {
            final selected = controller.activeFilter.value == f['value'];
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      f['icon'] as IconData,
                      size: 16,
                      color:
                          selected ? scheme.onPrimary : scheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      f['label'] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: selected
                            ? scheme.onPrimary
                            : scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                selected: selected,
                onSelected: (_) => controller.setFilter(f['value'] as String),
                selectedColor: scheme.primary,
                backgroundColor: scheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(
                    color: selected
                        ? scheme.primary
                        : scheme.outline.withValues(alpha: 0.25),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
