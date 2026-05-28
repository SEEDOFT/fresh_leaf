import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_pin_controller.dart';
import 'package:fresh_leaf/app/modules/profile/widgets/profile_pin_widget.dart';
import 'package:fresh_leaf/shared/widgets/custom_app_bar.dart';
import 'package:fresh_leaf/shared/widgets/primary_button.dart';
import 'package:get/get.dart';

class ProfilePinView extends GetView<ProfilePinController> {
  const ProfilePinView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: CustomAppBar(title: 'pin_security'.tr),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Obx(
          () => ListView(
            children: [
              PinOverviewCard(hasPin: controller.hasPin.value),
              const SizedBox(height: 14),
              Text(
                controller.hasPin.value
                    ? 'use_current_pin_update'.tr
                    : 'verify_password_before_pin'.tr,
                style: TextStyle(
                  color: scheme.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 18),
              if (!controller.hasPin.value) ...[
                PrimaryButton(
                  onPressed: controller.openSetPinWithPassword,
                  icon: Icons.lock_person_rounded,
                  label: 'verify_password_set_pin'.tr,
                  borderRadius: 14,
                  height: 50,
                ),
              ] else ...[
                PrimaryButton(
                  onPressed: controller.openUpdatePinFlow,
                  icon: Icons.edit_rounded,
                  label: 'update_pin'.tr,
                  borderRadius: 14,
                  height: 50,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: screenWidth,
                  child: OutlinedButton.icon(
                    onPressed: controller.openResetPinWithPassword,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: scheme.secondary,
                      side: BorderSide(color: scheme.secondary),
                      minimumSize: const Size(0, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.lock_reset_rounded),
                    label: Text(
                      'forgot_pin_reset'.tr,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
