import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/dashboard/widgets/dashboard_widget.dart';
import 'package:fresh_leaf/core/constants/svg_assets.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => IndexedStack(
            index: controller.currentIndex.value,
            children: controller.pages,
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFFFEF8F3),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: const Color(0xFFFEF8F3),
                selectedItemColor: const Color(0xFF1A3C14),
                selectedIconTheme: const IconThemeData(
                  color: Color(0xFF1A3C14),
                ),
                unselectedItemColor: const Color(
                  0xFF1D1B19,
                ).withValues(alpha: 0.7),
                elevation: 0,
                currentIndex: controller.currentIndex.value,
                onTap: (index) => controller.changeIndex(index),
                items: [
                  BottomNavigationBarItem(
                    icon: BuildNavIcon(
                      svgAsset: SvgAssets.home,
                      isSelected: controller.currentIndex.value == 0,
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: BuildNavIcon(
                      svgAsset: SvgAssets.cart,
                      isSelected: controller.currentIndex.value == 1,
                    ),
                    label: 'Cart',
                  ),
                  BottomNavigationBarItem(
                    icon: BuildNavIcon(
                      svgAsset: SvgAssets.gemini,
                      isSelected: controller.currentIndex.value == 2,
                    ),
                    label: 'AI Assistant',
                  ),
                  BottomNavigationBarItem(
                    icon: BuildNavIcon(
                      svgAsset: SvgAssets.order,
                      isSelected: controller.currentIndex.value == 3,
                    ),
                    label: 'Orders',
                  ),
                  BottomNavigationBarItem(
                    icon: BuildNavIcon(
                      svgAsset: SvgAssets.profile,
                      isSelected: controller.currentIndex.value == 4,
                    ),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
