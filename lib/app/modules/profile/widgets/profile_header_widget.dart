import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_controller.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:get/get.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({required this.controller, super.key});
  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'profile'.tr,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Obx(
              () => Text(
                controller.email.value.isEmpty ? '—' : controller.email.value,
                style: TextStyle(
                  color: scheme.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        InkWell(
          onTap: () async => await Get.toNamed<void>(AppRoutes.settings),
          borderRadius: BorderRadius.circular(999),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.settings, color: scheme.onSurface),
          ),
        ),
      ],
    );
  }
}
