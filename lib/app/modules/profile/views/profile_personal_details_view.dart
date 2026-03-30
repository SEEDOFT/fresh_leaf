import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/profile/widgets/profile_personal_widget.dart';
import 'package:fresh_leaf/app/modules/profile/widgets/profile_widget.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import 'package:get/get.dart';
import '../controllers/profile_personal_details_controller.dart';

class ProfilePersonalDetailsView
    extends GetView<ProfilePersonalDetailsController> {
  const ProfilePersonalDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: scaffoldBg,
        appBar: const ProfileAppBar(title: 'Personal Details'),
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
                        const PersonalDetailsIntroCard(),
                        const SizedBox(height: 16),
                        PersonalDetailsField(
                          label: 'First Name',
                          controller: controller.firstNameController,
                          icon: Icons.badge_outlined,
                        ),
                        const SizedBox(height: 16),
                        PersonalDetailsField(
                          label: 'Last Name',
                          controller: controller.lastNameController,
                          icon: Icons.badge_outlined,
                        ),
                        const SizedBox(height: 16),
                        PersonalDetailsField(
                          label: 'Email',
                          controller: controller.emailController,
                          keyboard: TextInputType.emailAddress,
                          icon: Icons.alternate_email_rounded,
                        ),
                        const SizedBox(height: 16),
                        PersonalDetailsField(
                          label: 'Phone',
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
                          backgroundColor: AppColors.darkGreen,
                          minimumSize: Size(screenWidth, 52),
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
                                  strokeWidth: 2.2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Save Changes',
                                style: TextStyle(
                                  color: Colors.white,
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
