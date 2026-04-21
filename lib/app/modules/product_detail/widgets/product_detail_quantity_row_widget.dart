import 'package:flutter/material.dart';
import 'package:fresh_leaf/shared/widgets/app_quantity_selector.dart';
import 'package:get/get.dart';

class QuantityRowWidget extends StatelessWidget {
  const QuantityRowWidget({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    super.key,
  });

  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Text(
          'quantity'.tr,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: scheme.onSurface,
          ),
        ),
        const Spacer(),
        AppQuantitySelector(
          quantity: quantity,
          onIncrement: onIncrement,
          onDecrement: onDecrement,
        ),
      ],
    );
  }
}
