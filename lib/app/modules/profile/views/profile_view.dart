import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_controller.dart';
import 'package:fresh_leaf/app/modules/profile/widgets/profile_widget.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
import 'package:fresh_leaf/shared/widgets/app_divider.dart';
import 'package:fresh_leaf/shared/widgets/app_scaffold.dart';
import 'package:fresh_leaf/shared/widgets/app_tile.dart';
import 'package:get/get.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      safeAreaTop: false,
      onRefresh: controller.refreshProfile,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileHeader(controller: controller),
          SizedBox(height: 20.scaled),
          ProfileStatsCard(controller: controller),
          SizedBox(height: 20.scaled),
          ProfileSectionCard(
            title: 'account'.tr.toUpperCase(),
            children: [
              Obx(
                () => AppTile(
                  icon: Icons.person_outline,
                  title: 'personal_details'.tr,
                  subtitle: controller.email.value,
                  onTap: () async =>
                      await Get.toNamed<void>(AppRoutes.personalDetails),
                ),
              ),
              AppDivider(height: 16.scaled),
              AppTile(
                icon: Icons.lock_outline,
                title: 'security'.tr,
                subtitle: 'password'.tr,
                onTap: () async =>
                    await Get.toNamed<void>(AppRoutes.securitySettings),
              ),
              AppDivider(height: 16.scaled),
              AppTile(
                icon: Icons.pin_outlined,
                title: 'pin_security'.tr,
                subtitle: 'pin_security_subtitle'.tr,
                onTap: () async =>
                    await Get.toNamed<void>(AppRoutes.pinSecurity),
              ),
              AppDivider(height: 16.scaled),
              AppTile(
                icon: Icons.location_on_outlined,
                title: 'addresses'.tr,
                subtitle: 'addresses_subtitle'.tr,
                onTap: () async => await Get.toNamed(AppRoutes.addresses),
              ),
            ],
          ),
          ProfileSectionCard(
            title: 'wallet_payment'.tr.toUpperCase(),
            children: [
              AppTile(
                icon: Icons.account_balance_wallet_outlined,
                title: 'my_wallet'.tr,
                subtitle: 'wallet_subtitle'.tr,
                onTap: () async => await Get.toNamed<void>(AppRoutes.wallet),
              ),
              AppDivider(height: 16.scaled),
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
            title: 'support'.tr.toUpperCase(),
            children: [
              AppTile(
                icon: Icons.support_agent,
                title: 'help_center'.tr,
                subtitle: 'help_center_subtitle'.tr,
                onTap: () async =>
                    await Get.toNamed<void>(AppRoutes.helpCenter),
              ),
              AppDivider(height: 16.scaled),
              AppTile(
                icon: Icons.policy_outlined,
                title: 'privacy_terms'.tr,
                onTap: () async =>
                    await Get.toNamed<void>(AppRoutes.privacyTerms),
              ),
            ],
          ),
          SizedBox(height: 12.scaled),
          Obx(
            () => ProfileLogoutButton(
              onTap: controller.logout,
              isLoading: controller.isLoading.value,
            ),
          ),
          SizedBox(height: 24.scaled),
        ],
      ),
    );
  }
}
