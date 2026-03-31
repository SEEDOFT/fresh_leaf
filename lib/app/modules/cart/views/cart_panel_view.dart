import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/cart/bindings/cart_binding.dart';
import 'package:fresh_leaf/app/modules/cart/controllers/cart_controller.dart';
import 'package:fresh_leaf/app/modules/cart/views/cart_view.dart';
import 'package:get/get.dart';

Future<void> showCartPanel() async {
  if (!Get.isRegistered<CartController>()) {
    CartBinding().dependencies();
  }

  await Get.generalDialog(
    barrierDismissible: true,
    barrierLabel: 'Cart',
    barrierColor: Get.theme.colorScheme.scrim.withValues(alpha: 0.5),
    transitionDuration: const Duration(milliseconds: 260),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Dismissible(
        key: const ValueKey('cart-panel-dismissible'),
        direction: DismissDirection.startToEnd,
        dismissThresholds: const <DismissDirection, double>{
          DismissDirection.startToEnd: 0.18,
        },
        movementDuration: const Duration(milliseconds: 220),
        resizeDuration: null,
        onDismissed: (_) => Get.back<void>(),
        child: const Align(
          alignment: Alignment.centerRight,
          child: FractionallySizedBox(
            widthFactor: 0.92,
            child: ClipRRect(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(26),
              ),
              child: CartView(asPanel: true),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      );
    },
  );
}
