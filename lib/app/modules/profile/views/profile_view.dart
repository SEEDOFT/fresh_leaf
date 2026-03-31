import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../widgets/profile_widget.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 1500));

            return controller.refreshProfile();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileHeader(controller: controller),
                const SizedBox(height: 20),
                ProfileStatsCard(controller: controller),
                const SizedBox(height: 20),
                ProfileSectionCard(
                  title: 'account'.tr,
                  children: [
                    ProfileTile(
                      icon: Icons.person_outline,
                      title: 'personal_details'.tr,
                      subtitle: controller.email.value,
                      onTap: () => Get.toNamed(AppRoutes.personalDetails),
                    ),
                    const Divider(height: 16),
                    ProfileTile(
                      icon: Icons.lock_outline,
                      title: 'security'.tr,
                      subtitle: 'password'.tr,
                      onTap: () => Get.toNamed(AppRoutes.securitySettings),
                    ),
                    const Divider(height: 16),
                    ProfileTile(
                    icon: Icons.pin_outlined,
                    title: 'pin_security'.tr,
                    subtitle: 'pin_security_subtitle'.tr,
                    onTap: () => Get.toNamed(AppRoutes.pinSecurity),
                  ),
                  ],
                ),
                ProfileSectionCard(
                  title: 'orders_payments'.tr,
                  children: [
                    ProfileTile(
                      icon: Icons.favorite_border,
                      title: 'wishlist'.tr,
                      subtitle: 'wishlist_subtitle'.tr,
                      onTap: () => Get.toNamed(AppRoutes.wishlist),
                    ),
                    const Divider(height: 16),
                    ProfileTile(
                      icon: Icons.shopping_bag_outlined,
                      title: 'orders'.tr,
                      subtitle: 'orders_subtitle'.tr,
                      onTap: controller.openOrders,
                    ),
                    const Divider(height: 16),
                    ProfileTile(
                      icon: Icons.location_on_outlined,
                      title: 'addresses'.tr,
                      subtitle: 'addresses_subtitle'.tr,
                      onTap: () => Get.toNamed(AppRoutes.addresses),
                    ),
                    const Divider(height: 16),
                    ProfileTile(
                      icon: Icons.credit_card,
                      title: 'payment_methods'.tr,
                      subtitle: 'payment_methods_subtitle'.tr,
                      onTap: () {},
                    ),
                  ],
                ),
                ProfileSectionCard(
                  title: 'support'.tr,
                  children: [
                    ProfileTile(
                      icon: Icons.support_agent,
                      title: 'help_center'.tr,
                      subtitle: 'help_center_subtitle'.tr,
                    ),
                    const Divider(height: 16),
                    ProfileTile(
                      icon: Icons.policy_outlined,
                      title: 'privacy_terms'.tr,
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
          ),
        ),
      ),
    );
  }
}
