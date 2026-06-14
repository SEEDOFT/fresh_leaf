import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fresh_leaf/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:fresh_leaf/app/modules/dashboard/widgets/dashboard_widget.dart';
import 'package:fresh_leaf/app/modules/orders/controllers/orders_controller.dart';
import 'package:fresh_leaf/core/constants/svg_assets.dart';
import 'package:fresh_leaf/core/services/notification_service.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
import 'package:fresh_leaf/shared/widgets/exit_confirmation_sheet.dart';
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

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await showExitConfirmationSheet(context);
        if (shouldExit && context.mounted) {
          await SystemNavigator.pop();
        }
      },
      child: Scaffold(
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
        bottomNavigationBar: MediaQuery.viewInsetsOf(context).bottom > 0
            ? const SizedBox.shrink()
            : Obx(
                () => DecoratedBox(
                  decoration: BoxDecoration(
                    color: navBackgroundColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24.scaled),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: scheme.shadow.withValues(alpha: 0.20),
                        blurRadius: 20.scaled,
                        offset: Offset(0, -4.scaled),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24.scaled),
                    ),
                    child: BottomNavigationBar(
                      type: BottomNavigationBarType.fixed,
                      backgroundColor: navBackgroundColor,
                      selectedItemColor: navSelectedColor,
                      selectedIconTheme: IconThemeData(color: navSelectedColor),
                      unselectedItemColor: navUnselectedColor,
                      selectedLabelStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12.scaled,
                      ),
                      unselectedLabelStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.scaled,
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
                            badgeCount: Get.find<NotificationService>()
                                .unreadCount
                                .value,
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
                            badgeCount: Get.find<NotificationService>()
                                .unreadChatCount
                                .value,
                          ),
                          label: 'ai_assistant'.tr,
                        ),
                        BottomNavigationBarItem(
                          icon: BuildNavIcon(
                            svgAsset: SvgAssets.order,
                            isSelected: controller.currentIndex == 3,
                            selectedColor: navSelectedColor,
                            unselectedColor: navUnselectedColor,
                            badgeCount:
                                Get.find<OrdersController>().activeOrderCount,
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
      ),
    );
  }
}
