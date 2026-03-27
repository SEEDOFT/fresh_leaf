import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import '../controllers/profile_controller.dart';
import '../widgets/profile_widget.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
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
                    onTap: () {},
                  ),
                  const Divider(height: 16),
                  ProfileTile(
                    icon: Icons.lock_outline,
                    title: 'Security',
                    subtitle: 'Password & 2FA',
                    onTap: () {},
                  ),
                ],
              ),
              ProfileSectionCard(
                title: 'Orders & Payments',
                children: [
                  ProfileTile(
                    icon: Icons.shopping_bag_outlined,
                    title: 'Orders',
                    subtitle: 'Track and reorder',
                    onTap: () => Get.toNamed('/orders'),
                  ),
                  const Divider(height: 16),
                  ProfileTile(
                    icon: Icons.location_on_outlined,
                    title: 'Addresses',
                    subtitle: 'Manage delivery locations',
                    onTap: () {},
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
              ProfileSectionCard(
                title: 'Support',
                children: const [
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
    );
  }
}
