import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/profile/widgets/profile_personal_widget.dart';
import 'package:fresh_leaf/app/modules/profile/widgets/profile_widget.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import 'package:get/get.dart';
import '../controllers/profile_personal_controller.dart';

class PersonalDetailsView extends GetView<ProfilePersonalController> {
  const PersonalDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundCream,
      appBar: const ProfileAppBar(title: 'Personal Details'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PersonalDetailsField(label: 'First Name', hint: 'Sophy'),
            const SizedBox(height: 16),
            const PersonalDetailsField(label: 'Last Name', hint: 'Im'),
            const SizedBox(height: 16),
            const PersonalDetailsField(
              label: 'Email',
              hint: 'you@example.com',
              keyboard: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            const PersonalDetailsField(
              label: 'Phone',
              hint: '+855 12 345 678',
              keyboard: TextInputType.phone,
            ),
            const Spacer(),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkGreen,
                  minimumSize: Size(
                    MediaQuery.of(context).size.width,
                    52,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
