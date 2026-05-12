import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdersTabTitleWidget extends StatelessWidget {
  const OrdersTabTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'orders'.tr,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'orders_subtitle'.tr,
            style: TextStyle(
              color: scheme.onSurfaceVariant,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
