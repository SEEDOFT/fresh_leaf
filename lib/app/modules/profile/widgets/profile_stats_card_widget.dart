import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_controller.dart';
import 'package:get/get.dart';

class ProfileStatsCard extends StatelessWidget {
  const ProfileStatsCard({required this.controller, super.key});
  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Obx(
              () {
                final imageUrl = controller.image.value.trim();
                if (imageUrl.isEmpty) {
                  return Icon(
                    Icons.eco_rounded,
                    color: scheme.onSurface,
                    size: 28,
                  );
                }

                return ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    imageUrl,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        width: 64,
                        height: 64,
                        color: scheme.surfaceContainerHighest,
                        child: Center(
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 64,
                        height: 64,
                        color: scheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.broken_image_rounded,
                          color: scheme.onSurfaceVariant,
                          size: 22,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
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
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: scheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Obx(
                  () => Text(
                    controller.phone.value.isEmpty
                        ? '—'
                        : controller.phone.value,
                    style: TextStyle(
                      color: scheme.onSurfaceVariant,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Obx(
                  () => Text(
                    controller.memberSince.value.isEmpty
                        ? 'active_member'.tr
                        : 'member_since'.trParams({
                            'date': controller.memberSince.value,
                          }),
                    style: TextStyle(
                      color: scheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: scheme.secondaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'organic_club'.tr,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: scheme.onSecondaryContainer,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
