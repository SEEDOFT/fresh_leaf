import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fresh_leaf/app/modules/profile/widgets/profile_pin_widget.dart';
import 'package:fresh_leaf/app/modules/profile/widgets/profile_widget.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
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
      appBar: const ProfileAppBar(title: 'PIN Security'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Obx(
          () => ListView(
            children: [
              PinOverviewCard(hasPin: controller.hasPin.value),
              const SizedBox(height: 14),
              Text(
                controller.hasPin.value
                    ? 'Use your current PIN to update it.'
                    : 'Verify your password first before setting a new PIN.',
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
                      backgroundColor: AppColors.darkGreen,
                      minimumSize: const Size(0, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.lock_person_rounded),
                    label: const Text(
                      'Verify Password & Set PIN',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ] else ...[
                PinTextField(
                  label: 'Current PIN',
                  controller: controller.currentPinController,
                  inputFormatters: controller.pinInputFormatter,
                ),
                const SizedBox(height: 14),
                PinTextField(
                  label: 'New PIN',
                  controller: controller.newPinController,
                  inputFormatters: controller.pinInputFormatter,
                ),
                const SizedBox(height: 14),
                PinTextField(
                  label: 'Confirm PIN',
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
                      backgroundColor: AppColors.darkGreen,
                      minimumSize: const Size(0, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: controller.isSaving.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Update PIN',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: screenWidth,
                  child: OutlinedButton.icon(
                    onPressed: controller.openResetPinWithPassword,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.accentBrown,
                      side: const BorderSide(color: AppColors.accentBrown),
                      minimumSize: const Size(0, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.lock_reset_rounded),
                    label: const Text(
                      'Forgot PIN? Reset via Password',
                      style: TextStyle(fontWeight: FontWeight.w700),
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
