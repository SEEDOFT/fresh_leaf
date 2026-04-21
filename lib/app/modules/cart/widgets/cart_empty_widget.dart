import 'package:flutter/material.dart';
import 'package:fresh_leaf/shared/widgets/app_empty_state.dart';
import 'package:get/get.dart';

class CartEmptyWidget extends StatelessWidget {
  const CartEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppEmptyState(
      icon: Icons.shopping_cart_checkout_rounded,
      iconColor: scheme.primary,
      iconBackgroundColor: scheme.primaryContainer.withValues(alpha: 0.55),
      title: 'cart_empty_title'.tr,
      subtitle: 'cart_empty_subtitle'.tr,
    );
  }
}
