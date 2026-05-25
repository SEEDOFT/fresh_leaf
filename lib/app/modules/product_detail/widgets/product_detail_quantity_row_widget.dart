import 'package:flutter/material.dart';
import 'package:fresh_leaf/shared/widgets/app_quantity_selector.dart';
import 'package:get/get.dart';

class QuantityRowWidget extends StatelessWidget {
  const QuantityRowWidget({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.onChanged,
    this.allowDecimal = false,
    this.unitSymbol,
    super.key,
  });

  final num quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final ValueChanged<num>? onChanged;
  final bool allowDecimal;
  final String? unitSymbol;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Text(
          '${'quantity'.tr}${unitSymbol != null && unitSymbol!.isNotEmpty ? ' ($unitSymbol)' : ''}',
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
          onChanged: onChanged,
          allowDecimal: allowDecimal,
        ),
      ],
    );
  }
}
