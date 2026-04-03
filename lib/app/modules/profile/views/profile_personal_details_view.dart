import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_personal_details_controller.dart';
import 'package:fresh_leaf/app/modules/profile/widgets/profile_personal_widget.dart';
import 'package:fresh_leaf/app/modules/profile/widgets/profile_widget.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePersonalDetailsView
    extends GetView<ProfilePersonalDetailsController> {
  const ProfilePersonalDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: scaffoldBg,
        appBar: ProfileAppBar(title: 'personal_details'.tr),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: controller.refreshProfile,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      children: [
                        _AvatarBlock(controller: controller),
                        const SizedBox(height: 16),
                        const PersonalDetailsIntroCard(),
                        const SizedBox(height: 16),
                        PersonalDetailsField(
                          label: 'first_name'.tr,
                          controller: controller.firstNameController,
                          icon: Icons.badge_outlined,
                        ),
                        const SizedBox(height: 16),
                        PersonalDetailsField(
                          label: 'last_name'.tr,
                          controller: controller.lastNameController,
                          icon: Icons.badge_outlined,
                        ),
                        const SizedBox(height: 16),
                        PersonalDetailsField(
                          label: 'email'.tr,
                          controller: controller.emailController,
                          keyboard: TextInputType.emailAddress,
                          icon: Icons.alternate_email_rounded,
                        ),
                        const SizedBox(height: 16),
                        PersonalDetailsField(
                          label: 'phone'.tr,
                          controller: controller.phoneController,
                          keyboard: TextInputType.phone,
                          icon: Icons.phone_outlined,
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  top: false,
                  minimum: const EdgeInsets.only(bottom: 10),
                  child: Obx(
                    () => ProfilePrimaryActionButton(
                      label: 'save_changes'.tr,
                      onPressed: controller.saveChanges,
                      isLoading: controller.isSaving.value,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AvatarBlock extends StatelessWidget {
  const _AvatarBlock({required this.controller});
  final ProfilePersonalDetailsController controller;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Obx(
      () {
        ImageProvider? avatar;
        if (controller.pickedImagePath.isNotEmpty) {
          avatar = FileImage(File(controller.pickedImagePath.value));
        } else if (controller.image.value.isNotEmpty) {
          avatar = NetworkImage(controller.image.value);
        }

        return Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 54,
                  backgroundColor: scheme.surfaceContainerHighest,
                  backgroundImage: avatar,
                  child: avatar == null
                      ? Icon(
                          Icons.person_rounded,
                          size: 46,
                          color: scheme.onSurfaceVariant,
                        )
                      : null,
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Material(
                    color: scheme.primary,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => _showPickerSheet(context),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          Icons.edit_rounded,
                          size: 18,
                          color: scheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (controller.pickedImagePath.isNotEmpty)
              TextButton.icon(
                onPressed: controller.clearPickedImage,
                icon: const Icon(Icons.close_rounded, size: 16),
                label: Text(
                  'Remove',
                  style: TextStyle(color: scheme.onSurfaceVariant),
                ),
              ),
          ],
        );
      },
    );
  }

  Future<void> _showPickerSheet(BuildContext context) async {
    final scheme = Theme.of(context).colorScheme;
    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.photo_library_rounded,
                color: scheme.onSurfaceVariant,
              ),
              title: Text(
                'Pick from gallery',
                style: TextStyle(color: scheme.onSurface),
              ),
              onTap: () async {
                Get.back<void>();
                await controller.pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.photo_camera_rounded,
                color: scheme.onSurfaceVariant,
              ),
              title: Text(
                'Take a photo',
                style: TextStyle(color: scheme.onSurface),
              ),
              onTap: () async {
                Get.back<void>();
                await controller.pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }
}
