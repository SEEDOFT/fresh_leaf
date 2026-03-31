import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fresh_leaf/app/modules/profile/widgets/profile_pin_widget.dart';
import 'package:fresh_leaf/app/modules/profile/widgets/profile_widget.dart';
import '../controllers/profile_pin_controller.dart';

class ProfilePinView extends GetView<ProfilePinController> {
  const ProfilePinView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: ProfileAppBar(title: 'pin_security'.tr),
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
                SizedBox(
                  width: screenWidth,
                  child: ElevatedButton.icon(
                    onPressed: controller.openSetPinWithPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: scheme.primary,
                      minimumSize: const Size(0, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    icon: Icon(
                      Icons.lock_person_rounded,
                      color: scheme.onPrimary,
                    ),
                    label: Text(
                      'verify_password_set_pin'.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: scheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ] else ...[
                PinTextField(
                  label: 'current_pin'.tr,
                  controller: controller.currentPinController,
                  inputFormatters: controller.pinInputFormatter,
                ),
                const SizedBox(height: 14),
                PinTextField(
                  label: 'new_pin'.tr,
                  controller: controller.newPinController,
                  inputFormatters: controller.pinInputFormatter,
                ),
                const SizedBox(height: 14),
                PinTextField(
                  label: 'confirm_pin'.tr,
                  controller: controller.confirmPinController,
                  inputFormatters: controller.pinInputFormatter,
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: screenWidth,
                  child: ElevatedButton(
                    onPressed: controller.isSaving.value
                        ? null
                        : controller.updateExistingPin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: scheme.primary,
                      minimumSize: const Size(0, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: controller.isSaving.value
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: scheme.onPrimary,
                            ),
                          )
                        : Text(
                            'update_pin'.tr,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: scheme.onPrimary,
                            ),
                          ),
                  ),
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
