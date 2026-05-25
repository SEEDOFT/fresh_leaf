import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/product_detail/controllers/product_detail_controller.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';
import 'package:get/get.dart';

class AddButtonWidget extends StatelessWidget {
  const AddButtonWidget({
    required this.total,
    required this.onPressed,
    required this.controller,
    super.key,
  });

  final double total;
  final VoidCallback onPressed;
  final ProductDetailController controller;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final scheme = Theme.of(context).colorScheme;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        minimumSize: Size(media.size.width, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${'add_to_cart'.tr} '
                    '${controller.quantity.value.toString().replaceAll(RegExp(r'\.0$'), '')}'
                    ' ${controller.product.unitSymbol ?? ''}'
                .trim(),
            style: TextStyle(
              color: scheme.onPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            '${controller.product.currencySymbol ?? r'$'}${formatPrice(total)}',
            style: TextStyle(
              color: scheme.onPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
