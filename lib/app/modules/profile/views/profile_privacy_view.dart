import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_privacy_controller.dart';
import 'package:fresh_leaf/app/modules/profile/widgets/profile_widget.dart';
import 'package:get/get.dart';

class ProfilePrivacyView extends GetView<ProfilePrivacyController> {
  const ProfilePrivacyView({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: ProfileAppBar(title: 'privacy_terms'.tr),
      body: SafeArea(
        child: Obx(
          () => ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 22),
            physics: const BouncingScrollPhysics(),
            itemCount: controller.sections.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, index) {
              final section = controller.sections[index];
              return ProfilePrivacySection(section: section);
            },
          ),
        ),
      ),
    );
  }
}
