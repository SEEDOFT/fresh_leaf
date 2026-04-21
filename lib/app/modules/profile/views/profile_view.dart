import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_controller.dart';
import 'package:fresh_leaf/app/modules/profile/widgets/profile_widget.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/shared/widgets/app_divider.dart';
import 'package:fresh_leaf/shared/widgets/app_scaffold.dart';
import 'package:fresh_leaf/shared/widgets/app_tile.dart';
import 'package:get/get.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      onRefresh: controller.refreshProfile,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileHeader(controller: controller),
          const SizedBox(height: 20),
          ProfileStatsCard(controller: controller),
          const SizedBox(height: 20),
          ProfileSectionCard(
            title: 'account'.tr,
            children: [
              AppTile(
                icon: Icons.person_outline,
                title: 'personal_details'.tr,
                subtitle: controller.email.value,
                onTap: () async =>
                    await Get.toNamed<void>(AppRoutes.personalDetails),
              ),
              const AppDivider(height: 16),
              AppTile(
                icon: Icons.lock_outline,
                title: 'security'.tr,
                subtitle: 'password'.tr,
                onTap: () async =>
                    await Get.toNamed<void>(AppRoutes.securitySettings),
              ),
              const AppDivider(height: 16),
              AppTile(
                icon: Icons.pin_outlined,
                title: 'pin_security'.tr,
                subtitle: 'pin_security_subtitle'.tr,
                onTap: () async =>
                    await Get.toNamed<void>(AppRoutes.pinSecurity),
              ),
            ],
          ),
          ProfileSectionCard(
            title: 'orders_payments'.tr,
            children: [
              AppTile(
                icon: Icons.favorite_border,
                title: 'wishlist'.tr,
                subtitle: 'wishlist_subtitle'.tr,
                onTap: () async => await Get.toNamed(AppRoutes.wishlist),
              ),
              const AppDivider(height: 16),
              AppTile(
                icon: Icons.shopping_bag_outlined,
                title: 'orders'.tr,
                subtitle: 'orders_subtitle'.tr,
                onTap: controller.openOrders,
              ),
              const AppDivider(height: 16),
              AppTile(
                icon: Icons.location_on_outlined,
                title: 'addresses'.tr,
                subtitle: 'addresses_subtitle'.tr,
                onTap: () async => await Get.toNamed(AppRoutes.addresses),
              ),
              const AppDivider(height: 16),
              AppTile(
                icon: Icons.credit_card,
                title: 'payment_methods'.tr,
                subtitle: 'payment_methods_subtitle'.tr,
                onTap: () async =>
                    await Get.toNamed<void>(AppRoutes.paymentMethods),
              ),
            ],
          ),
          ProfileSectionCard(
            title: 'support'.tr,
            children: [
              AppTile(
                icon: Icons.support_agent,
                title: 'help_center'.tr,
                subtitle: 'help_center_subtitle'.tr,
                onTap: () async =>
                    await Get.toNamed<void>(AppRoutes.helpCenter),
              ),
              const AppDivider(height: 16),
              AppTile(
                icon: Icons.policy_outlined,
                title: 'privacy_terms'.tr,
                onTap: () async =>
                    await Get.toNamed<void>(AppRoutes.privacyTerms),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(
            () => ProfileLogoutButton(
              onTap: controller.logout,
              isLoading: controller.isLoading.value,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
