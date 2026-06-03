import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_pin_password_verify_controller.dart';
import 'package:fresh_leaf/app/modules/profile/widgets/profile_pin_widget.dart';
import 'package:fresh_leaf/shared/widgets/custom_app_bar.dart';
import 'package:fresh_leaf/shared/widgets/dialpad_widget.dart';
import 'package:fresh_leaf/shared/widgets/pin_display_widget.dart';
import 'package:fresh_leaf/shared/widgets/primary_button.dart';
import 'package:get/get.dart';

class ProfilePinPasswordVerifyView
    extends GetView<ProfilePinPasswordVerifyController> {
  const ProfilePinPasswordVerifyView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: scaffoldBg,
        appBar: CustomAppBar(title: controller.screenTitle),
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
                        controller.requiresPasswordVerification &&
                                controller.isPasswordVerified.value
                            ? 'password_verified_continue_pin'.tr
                            : controller.subtitle,
                        style: TextStyle(
                          color: scheme.onSurfaceVariant,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (controller.requiresPasswordVerification &&
                          !controller.isPasswordVerified.value) ...[
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
                        const SizedBox(height: 24),
                        Obx(() {
                          return Column(
                            children: [
                              PinDisplayWidget(
                                pinLength: controller.pinLength.value,
                                hasError: controller.hasError.value,
                              ),
                              const SizedBox(height: 48),
                              DialpadWidget(
                                onKeyPressed: controller.onDialpadKeyPressed,
                                onDeletePressed:
                                    controller.onDialpadDeletePressed,
                              ),
                            ],
                          );
                        }),
                      ],
                    ],
                  ),
                ),
              ),
              if (controller.requiresPasswordVerification &&
                  !controller.isPasswordVerified.value)
                SafeArea(
                  top: false,
                  minimum: const EdgeInsets.only(bottom: 10),
                  child: Obx(
                    () => PrimaryButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.verifyPasswordFirst,
                      isLoading: controller.isLoading.value,
                      label: 'verify_password'.tr,
                      borderRadius: 14,
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
