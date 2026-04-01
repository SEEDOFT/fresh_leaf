import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:fresh_leaf/app/modules/dashboard/widgets/dashboard_widget.dart';
import 'package:fresh_leaf/core/constants/svg_assets.dart';
import 'package:get/get.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    final navBackgroundColor = scheme.surface;
    final navSelectedColor = scheme.primary;
    final navUnselectedColor = scheme.onSurfaceVariant.withValues(alpha: 0.78);

    return Scaffold(
      backgroundColor: scaffoldBg,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Obx(
          () => IndexedStack(
            index: controller.currentIndex,
            children: controller.pages,
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => DecoratedBox(
          decoration: BoxDecoration(
            color: navBackgroundColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: scheme.shadow.withValues(alpha: 0.20),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: navBackgroundColor,
              selectedItemColor: navSelectedColor,
              selectedIconTheme: IconThemeData(color: navSelectedColor),
              unselectedItemColor: navUnselectedColor,
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              showUnselectedLabels: true,
              elevation: 0,
              currentIndex: controller.currentIndex,
              onTap: (index) => controller.currentIndex = index,
              items: [
                BottomNavigationBarItem(
                  icon: BuildNavIcon(
                    svgAsset: SvgAssets.home,
                    isSelected: controller.currentIndex == 0,
                    selectedColor: navSelectedColor,
                    unselectedColor: navUnselectedColor,
                  ),
                  label: 'home'.tr,
                ),
                BottomNavigationBarItem(
                  icon: BuildNavIcon(
                    svgAsset: SvgAssets.search,
                    isSelected: controller.currentIndex == 1,
                    selectedColor: navSelectedColor,
                    unselectedColor: navUnselectedColor,
                  ),
                  label: 'search'.tr,
                ),
                BottomNavigationBarItem(
                  icon: BuildNavIcon(
                    svgAsset: SvgAssets.gemini,
                    isSelected: controller.currentIndex == 2,
                    selectedColor: navSelectedColor,
                    unselectedColor: navUnselectedColor,
                  ),
                  label: 'ai_assistant'.tr,
                ),
                BottomNavigationBarItem(
                  icon: BuildNavIcon(
                    svgAsset: SvgAssets.order,
                    isSelected: controller.currentIndex == 3,
                    selectedColor: navSelectedColor,
                    unselectedColor: navUnselectedColor,
                  ),
                  label: 'orders'.tr,
                ),
                BottomNavigationBarItem(
                  icon: BuildNavIcon(
                    svgAsset: SvgAssets.profile,
                    isSelected: controller.currentIndex == 4,
                    selectedColor: navSelectedColor,
                    unselectedColor: navUnselectedColor,
                  ),
                  label: 'profile'.tr,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
