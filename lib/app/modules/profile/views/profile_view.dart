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
                  title: 'Account',
                  children: [
                    ProfileTile(
                      icon: Icons.person_outline,
                      title: 'Personal Details',
                      subtitle: controller.email.value,
                      onTap: () => Get.toNamed(AppRoutes.personalDetails),
                    ),
                    const Divider(height: 16),
                    ProfileTile(
                      icon: Icons.lock_outline,
                      title: 'Security',
                      subtitle: 'Password',
                      onTap: () => Get.toNamed(AppRoutes.securitySettings),
                    ),
                    const Divider(height: 16),
                    ProfileTile(
                    icon: Icons.pin_outlined,
                    title: 'PIN Security',
                    subtitle: 'Set, update or reset PIN with password check',
                    onTap: () => Get.toNamed(AppRoutes.pinSecurity),
                  ),
                  ],
                ),
                ProfileSectionCard(
                  title: 'Orders & Payments',
                  children: [
                    ProfileTile(
                      icon: Icons.favorite_border,
                      title: 'Wishlist',
                      subtitle: 'Saved items for later',
                      onTap: () => Get.toNamed(AppRoutes.wishlist),
                    ),
                    const Divider(height: 16),
                    ProfileTile(
                      icon: Icons.shopping_bag_outlined,
                      title: 'Orders',
                      subtitle: 'Track and reorder',
                      onTap: controller.openOrders,
                    ),
                    const Divider(height: 16),
                    ProfileTile(
                      icon: Icons.location_on_outlined,
                      title: 'Addresses',
                      subtitle: 'Manage delivery locations',
                      onTap: () => Get.toNamed(AppRoutes.addresses),
                    ),
                    const Divider(height: 16),
                    ProfileTile(
                      icon: Icons.credit_card,
                      title: 'Payment Methods',
                      subtitle: 'Cards & wallets',
                      onTap: () {},
                    ),
                  ],
                ),
                const ProfileSectionCard(
                  title: 'Support',
                  children: [
                    ProfileTile(
                      icon: Icons.support_agent,
                      title: 'Help Center',
                      subtitle: 'FAQs & chat with support',
                    ),
                    Divider(height: 16),
                    ProfileTile(
                      icon: Icons.policy_outlined,
                      title: 'Privacy & Terms',
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
