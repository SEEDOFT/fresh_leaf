import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppQuantitySelector extends StatelessWidget {
  const AppQuantitySelector({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.onChanged,
    this.allowDecimal = false,
    this.borderRadius = 16,
    this.backgroundColor,
    super.key,
  });

  final num quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final ValueChanged<num>? onChanged;
  final bool allowDecimal;
  final double borderRadius;
  final Color? backgroundColor;

  void _showInputDialog(BuildContext context) {
    final textController = TextEditingController(
      text: quantity.toString().replaceAll(RegExp(r'\.0$'), ''),
    );

    unawaited(
      showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
          title: Text('enter_quantity'.tr),
          content: TextField(
            controller: textController,
            keyboardType: TextInputType.numberWithOptions(
              decimal: allowDecimal,
            ),
            decoration: InputDecoration(
              hintText: 'quantity'.tr,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                allowDecimal ? RegExp(r'^\d*\.?\d*') : RegExp(r'^\d+'),
              ),
            ],
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('cancel'.tr),
            ),
            ElevatedButton(
              onPressed: () {
                final val = double.tryParse(textController.text);
                if (val != null && val > 0) {
                  onChanged?.call(allowDecimal ? val : val.toInt());
                }
                Navigator.pop(context);
              },
              child: Text('ok'.tr),
            ),
          ],
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QtyButton(
            icon: Icons.remove_rounded,
            onTap: onDecrement,
          ),
          GestureDetector(
            onTap: onChanged == null ? null : () => _showInputDialog(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                quantity.toString().replaceAll(RegExp(r'\.0$'), ''),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: scheme.onSurface,
                ),
              ),
            ),
          ),
          _QtyButton(
            icon: Icons.add_rounded,
            onTap: onIncrement,
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: scheme.outline.withValues(alpha: 0.2)),
        ),
        child: Icon(
          icon,
          size: 18,
          color: scheme.onSurface,
        ),
      ),
    );
  }
}
