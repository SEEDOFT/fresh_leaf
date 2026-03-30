import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';

class CartHeaderWidget extends StatelessWidget {
  const CartHeaderWidget({
    super.key,
    required this.itemCount,
    required this.onClear,
  });

  final int itemCount;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final hasItems = itemCount > 0;
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Cart',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: scheme.onSurface,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.grayBorder),
                ),
                child: Text(
                  '$itemCount item${itemCount == 1 ? '' : 's'} selected',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: hasItems ? onClear : null,
                icon: const Icon(Icons.delete_outline_rounded, size: 18),
                label: const Text(
                  'Clear',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.accentBrown,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
