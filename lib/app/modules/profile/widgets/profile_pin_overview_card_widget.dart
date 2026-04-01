import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PinOverviewCard extends StatelessWidget {
  const PinOverviewCard({required this.hasPin, super.key});

  final bool hasPin;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.outline),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.pin_outlined, color: scheme.onSurface),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'pin_verification'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hasPin ? 'pin_active_update'.tr : 'set_pin_protect'.tr,
                  style: TextStyle(
                    fontSize: 12,
                    color: scheme.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
