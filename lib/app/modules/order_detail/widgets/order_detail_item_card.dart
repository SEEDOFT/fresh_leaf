import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';

class OrderDetailItemCard extends StatelessWidget {
  const OrderDetailItemCard({
    super.key,
    required this.item,
    required this.width,
    required this.onOpenProduct,
  });

  final Map<String, dynamic> item;
  final double width;
  final VoidCallback onOpenProduct;

  @override
  Widget build(BuildContext context) {
    final quantity = (item['quantity'] as num?)?.toInt() ?? 1;
    final unitPrice = (item['price'] as num?)?.toDouble() ?? 0.0;
    final total = unitPrice * quantity;

    return Container(
      width: width,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grayBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item['name'] as String? ?? 'Product',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDarkGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '$quantity x \$${unitPrice.toStringAsFixed(2)}',
            style: const TextStyle(
              color: AppColors.textLight,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: width - 28,
            child: OutlinedButton.icon(
              onPressed: onOpenProduct,
              icon: const Icon(Icons.open_in_new, size: 15),
              label: const Text(
                'Open Product',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.darkGreen,
                side: const BorderSide(color: AppColors.darkGreen),
                minimumSize: Size(width - 28, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
