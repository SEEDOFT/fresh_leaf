import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/profile/widgets/profile_personal_widget.dart';
import 'package:fresh_leaf/app/modules/profile/widgets/profile_widget.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../controllers/profile_personal_details_controller.dart';

class ProfilePersonalDetailsView
    extends GetView<ProfilePersonalDetailsController> {
  const ProfilePersonalDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    final scheme = Theme.of(context).colorScheme;

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
                    onRefresh: () async {
                      await Future.delayed(const Duration(milliseconds: 1500));

                      return controller.refreshProfile();
                    },
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
                    () => SizedBox(
                      width: screenWidth,
                      child: ElevatedButton(
                        onPressed: controller.isSaving.value
                            ? null
                            : controller.saveChanges,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: scheme.primary,
                          minimumSize: Size(screenWidth, 52),
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
                                  strokeWidth: 2.2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    scheme.onPrimary,
                                  ),
                                ),
                              )
                            : Text(
                                'save_changes'.tr,
                                style: TextStyle(
                                  color: scheme.onPrimary,
                                  fontWeight: FontWeight.bold,
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
                  backgroundColor: scheme.surfaceVariant,
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

  void _showPickerSheet(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library_rounded,
                  color: scheme.onSurfaceVariant),
              title: Text('Pick from gallery', style: TextStyle(color: scheme.onSurface)),
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading:
                  Icon(Icons.photo_camera_rounded, color: scheme.onSurfaceVariant),
              title: Text('Take a photo', style: TextStyle(color: scheme.onSurface)),
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }
}
