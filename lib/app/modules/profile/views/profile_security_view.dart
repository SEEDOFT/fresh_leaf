import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_security_controller.dart';
import 'package:fresh_leaf/app/modules/profile/widgets/profile_security_widget.dart';
import 'package:fresh_leaf/shared/widgets/app_scaffold.dart';
import 'package:fresh_leaf/shared/widgets/custom_app_bar.dart';
import 'package:fresh_leaf/shared/widgets/primary_button.dart';
import 'package:get/get.dart';

class SecuritySettingsView extends GetView<ProfileSecurityController> {
  const SecuritySettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: AppScaffold(
        appBar: CustomAppBar(title: 'security'.tr),
        bottomNavigationBar: SafeArea(
          top: false,
          minimum: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Obx(
            () => PrimaryButton(
              onPressed: controller.isLoading.value
                  ? null
                  : controller.isPasswordVerified.value
                  ? controller.updatePassword
                  : controller.verifyPasswordFirst,
              isLoading: controller.isLoading.value,
              label: controller.isPasswordVerified.value
                  ? 'update_password'.tr
                  : 'verify_password'.tr,
              borderRadius: 14,
              height: 50,
            ),
          ),
        ),
        body: Obx(
          () => Column(
            children: [
              const SecurityOverviewCard(),
              const SizedBox(height: 14),
              Text(
                controller.isPasswordVerified.value
                    ? 'password_verified_continue_new'.tr
                    : 'verify_current_password_first'.tr,
                style: TextStyle(
                  color: scheme.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 16),
              if (!controller.isPasswordVerified.value) ...[
                SecurityPasswordField(
                  label: 'current_password'.tr,
                  controller: controller.verifyPasswordController,
                  obscureText: !controller.isVerifyPasswordVisible.value,
                  onToggle: () => controller.isVerifyPasswordVisible.value =
                      !controller.isVerifyPasswordVisible.value,
                ),
              ] else ...[
                SecurityPasswordField(
                  label: 'new_password'.tr,
                  controller: controller.newPasswordController,
                  obscureText: !controller.isNewPasswordVisible.value,
                  onToggle: () => controller.isNewPasswordVisible.value =
                      !controller.isNewPasswordVisible.value,
                ),
                const SizedBox(height: 14),
                SecurityPasswordField(
                  label: 'confirm_new_password'.tr,
                  controller: controller.confirmPasswordController,
                  obscureText: !controller.isConfirmPasswordVisible.value,
                  onToggle: () => controller.isConfirmPasswordVisible.value =
                      !controller.isConfirmPasswordVisible.value,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
