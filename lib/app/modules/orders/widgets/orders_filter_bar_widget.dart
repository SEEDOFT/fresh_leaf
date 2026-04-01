import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdersFilterBar extends StatelessWidget {
  const OrdersFilterBar({
    required this.filters,
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final List<String> filters;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final active = selected == filter;
          return GestureDetector(
            onTap: () => onChanged(filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: active ? scheme.primary : scheme.surface,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: active ? scheme.primary : scheme.outline,
                ),
              ),
              child: Text(
                _labelForFilter(filter),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: active ? scheme.onPrimary : scheme.onSurfaceVariant,
                ),
              ),
            ),
          );
        },
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemCount: filters.length,
      ),
    );
  }

  String _labelForFilter(String filter) {
    switch (filter) {
      case 'Processing':
        return 'processing'.tr;
      case 'Delivered':
        return 'delivered'.tr;
      default:
        return 'tag_all'.tr;
    }
  }
}
