import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_personal_details_controller.dart';
import 'package:fresh_leaf/shared/widgets/app_avatar.dart';
import 'package:get/get.dart';

class PersonalDetailsIntroCard extends StatelessWidget {
  const PersonalDetailsIntroCard({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final controller = Get.find<ProfilePersonalDetailsController>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.outline),
      ),
      child: Row(
        children: [
          Obx(
            () => AppAvatar(
              imageUrl: controller.image.value,
              name:
                  '${controller.firstNameController.text}'
                  ' ${controller.lastNameController.text}',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'personal_information'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'personal_information_subtitle'.tr,
                  style: TextStyle(
                    fontSize: 12,
                    color: scheme.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
