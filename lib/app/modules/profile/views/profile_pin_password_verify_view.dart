import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_pin_password_verify_controller.dart';
import 'package:fresh_leaf/app/modules/profile/widgets/profile_pin_widget.dart';
import 'package:fresh_leaf/app/modules/profile/widgets/profile_widget.dart';
import 'package:get/get.dart';

class ProfilePinPasswordVerifyView
    extends GetView<ProfilePinPasswordVerifyController> {
  const ProfilePinPasswordVerifyView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scheme = Theme.of(context).colorScheme;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: scaffoldBg,
        appBar: ProfileAppBar(title: controller.screenTitle),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              Expanded(
                child: Obx(
                  () => ListView(
                    children: [
                      PinOverviewCard(
                        hasPin:
                            controller.isUpdateMode || controller.isResetMode,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        controller.isPasswordVerified.value
                            ? 'password_verified_continue_pin'.tr
                            : controller.subtitle,
                        style: TextStyle(
                          color: scheme.onSurfaceVariant,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (!controller.isPasswordVerified.value) ...[
                        TextField(
                          controller: controller.passwordController,
                          obscureText: !controller.isPasswordVisible.value,
                          decoration: InputDecoration(
                            labelText: 'password'.tr,
                            filled: true,
                            fillColor: scheme.surfaceContainerHighest,
                            prefixIcon: Icon(
                              Icons.lock_outline_rounded,
                              color: scheme.onSurfaceVariant,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () =>
                                  controller.isPasswordVisible.value =
                                      !controller.isPasswordVisible.value,
                              icon: Icon(
                                controller.isPasswordVisible.value
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded,
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                      ] else ...[
                        if (controller.isUpdateMode) ...[
                          PinTextField(
                            label: 'current_pin'.tr,
                            controller: controller.currentPinController,
                            inputFormatters: controller.pinInputFormatter,
                          ),
                          const SizedBox(height: 14),
                        ],
                        PinTextField(
                          label: 'new_pin'.tr,
                          controller: controller.pinController,
                          inputFormatters: controller.pinInputFormatter,
                        ),
                        const SizedBox(height: 14),
                        PinTextField(
                          label: 'confirm_pin'.tr,
                          controller: controller.confirmPinController,
                          inputFormatters: controller.pinInputFormatter,
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
                          ? controller.submit
                          : controller.verifyPasswordFirst,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: scheme.primary,
                        minimumSize: Size(screenWidth, 52),
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
                                  ? controller.actionTitle
                                  : 'verify_password'.tr,
                              style: TextStyle(
                                color: scheme.onPrimary,
                                fontWeight: FontWeight.w700,
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
