import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_pin_password_verify_controller.dart';
import 'package:fresh_leaf/app/modules/profile/widgets/profile_pin_widget.dart';
import 'package:fresh_leaf/app/modules/profile/widgets/profile_widget.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
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
                            ? 'Password verified. Continue with PIN setup.'
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
                            labelText: 'Password',
                            filled: true,
                            fillColor: scheme.surface,
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
                            label: 'Current PIN',
                            controller: controller.currentPinController,
                            inputFormatters: controller.pinInputFormatter,
                          ),
                          const SizedBox(height: 14),
                        ],
                        PinTextField(
                          label: 'New PIN',
                          controller: controller.pinController,
                          inputFormatters: controller.pinInputFormatter,
                        ),
                        const SizedBox(height: 14),
                        PinTextField(
                          label: 'Confirm PIN',
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
                        backgroundColor: AppColors.darkGreen,
                        minimumSize: Size(screenWidth, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              controller.isPasswordVerified.value
                                  ? controller.actionTitle
                                  : 'Verify Password',
                              style: const TextStyle(
                                color: Colors.white,
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
