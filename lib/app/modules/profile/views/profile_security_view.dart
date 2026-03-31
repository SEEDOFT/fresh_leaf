import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/profile/widgets/profile_security_widget.dart';
import 'package:fresh_leaf/app/modules/profile/widgets/profile_widget.dart';
import 'package:get/get.dart';
import '../controllers/profile_security_controller.dart';

class SecuritySettingsView extends GetView<ProfileSecurityController> {
  const SecuritySettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: scaffoldBg,
        appBar: ProfileAppBar(title: 'security'.tr),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              Expanded(
                child: Obx(
                  () => ListView(
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
                          onToggle: () =>
                              controller.isConfirmPasswordVisible.value =
                                  !controller.isConfirmPasswordVisible.value,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              SafeArea(
                top: false,
                minimum: const EdgeInsets.only(bottom: 10),
                child: Obx(
                  () => SizedBox(
                    width: screenWidth,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.isPasswordVerified.value
                          ? controller.updatePassword
                          : controller.verifyPasswordFirst,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: scheme.primary,
                        minimumSize: Size(screenWidth, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: controller.isLoading.value
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: scheme.onPrimary,
                              ),
                            )
                          : Text(
                              controller.isPasswordVerified.value
                                  ? 'update_password'.tr
                                  : 'verify_password'.tr,
                              style: TextStyle(
                                color: scheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
