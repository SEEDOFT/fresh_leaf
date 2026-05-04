import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_controller.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
import 'package:get/get.dart';

class ProfileStatsCard extends StatelessWidget {
  const ProfileStatsCard({required this.controller, super.key});
  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(16.scaled),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(20.scaled),
      ),
      child: Row(
        children: [
          Container(
            width: 80.scaled,
            height: 80.scaled,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(40.scaled),
            ),
            child: Obx(
              () {
                final imageUrl = controller.image.value.trim();
                if (imageUrl.isEmpty) {
                  return Icon(
                    Icons.eco_rounded,
                    color: scheme.onSurface,
                    size: 28.scaled,
                  );
                }
                return ClipRRect(
                  borderRadius: BorderRadius.circular(40.scaled),
                  child: Image.network(
                    imageUrl,
                    width: 80.scaled,
                    height: 80.scaled,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        width: 80.scaled,
                        height: 80.scaled,
                        color: scheme.surfaceContainerHighest,
                        child: Center(
                          child: SizedBox(
                            width: 18.scaled,
                            height: 18.scaled,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.scaled,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 64.scaled,
                        height: 64.scaled,
                        color: scheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.broken_image_rounded,
                          color: scheme.onSurfaceVariant,
                          size: 22.scaled,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          SizedBox(width: 16.scaled),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    controller.userName.value.isEmpty
                        ? 'member_placeholder'.tr
                        : controller.userName.value,
                    style: TextStyle(
                      fontSize: 18.scaled,
                      fontWeight: FontWeight.w800,
                      color: scheme.onSurface,
                    ),
                  ),
                ),
                SizedBox(height: 4.scaled),
                Obx(
                  () => Text(
                    controller.phone.value.isEmpty
                        ? '—'
                        : controller.phone.value,
                    style: TextStyle(
                      color: scheme.onSurfaceVariant,
                      fontSize: 13.scaled,
                    ),
                  ),
                ),
                SizedBox(height: 8.scaled),
                Obx(
                  () => Text(
                    controller.memberSince.value.isEmpty
                        ? 'active_member'.tr
                        : 'member_since'.trParams({
                            'date': controller.memberSince.value,
                          }),
                    style: TextStyle(
                      color: scheme.onSurfaceVariant,
                      fontSize: 12.scaled,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Hide the Status Card for now
          // Container(
          //   padding: EdgeInsets.symmetric(
          //     horizontal: 12.scaled,
          //     vertical: 8.scaled,
          //   ),
          //   decoration: BoxDecoration(
          //     color: scheme.secondaryContainer,
          //     borderRadius: BorderRadius.circular(16.scaled),
          //   ),
          //   child: Text(
          //     'organic_club'.tr,
          //     style: TextStyle(
          //       fontWeight: FontWeight.w800,
          //       color: scheme.onSecondaryContainer,
          //       fontSize: 12.scaled,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
