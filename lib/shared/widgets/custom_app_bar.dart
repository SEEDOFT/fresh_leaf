import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/cart/bindings/cart_binding.dart';
import 'package:fresh_leaf/app/modules/cart/controllers/cart_controller.dart';
import 'package:fresh_leaf/app/modules/cart/views/cart_panel_view.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    required this.title,
    this.showBackButton = true,
    this.actions,
    this.backgroundColor,
    this.onBack,
    this.centerTitle = false,
    this.showCartButton = false,
    super.key,
  });

  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final VoidCallback? onBack;
  final bool centerTitle;
  final bool showCartButton;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight.scaled);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppBar(
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: 0,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: 18.scaled,
                color: scheme.onSurface,
              ),
              onPressed: onBack ?? Get.back<void>,
            )
          : null,
      title: Text(
        title,
        style: TextStyle(
          color: scheme.onSurface,
          fontWeight: FontWeight.w800,
          fontSize: 18.scaled,
        ),
      ),
      actions: [
        ...?actions,
        if (showCartButton)
          Builder(
            builder: (context) {
              if (!Get.isRegistered<CartController>()) {
                CartBinding().dependencies();
              }
              final cartController = Get.find<CartController>();
              return Obx(() {
                final count = cartController.items.length;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.shopping_cart_outlined,
                        color: scheme.onSurface,
                      ),
                      onPressed: showCartPanel,
                    ),
                    if (count > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: scheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            count > 99 ? '99+' : count.toString(),
                            style: TextStyle(
                              color: scheme.onPrimary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              });
            },
          ),
      ],
    );
  }
}
