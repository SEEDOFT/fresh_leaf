import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdersHeader extends StatelessWidget {
  const OrdersHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: isDark
              ? <Color>[
                  scheme.primaryContainer,
                  scheme.surfaceContainerHighest,
                ]
              : const <Color>[
                  Color(0xFF2E5321),
                  Color(0xFF1F3C16),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'order_history'.tr,
            style: TextStyle(
              color: isDark ? scheme.onPrimaryContainer : Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'order_history_subtitle'.tr,
            style: TextStyle(
              color: isDark
                  ? scheme.onPrimaryContainer.withValues(alpha: 0.78)
                  : const Color(0xFFDAE7D0),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
