import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fresh_leaf/app/modules/login/controllers/login_controller.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/shared/helpers/phone_input_formatter.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
import 'package:fresh_leaf/shared/widgets/app_text_field.dart';
import 'package:fresh_leaf/shared/widgets/glass_card.dart';
import 'package:fresh_leaf/shared/widgets/primary_button.dart';
import 'package:get/get.dart';

class LoginFormContent extends StatelessWidget {
  const LoginFormContent({
    required this.controller,
    super.key,
  });

  final LoginController controller;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    
    return GlassCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'welcome_back'.tr,
            style: TextStyle(
              fontSize: 28.scaled,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 8.scaled),
          Text(
            'login_subtitle'.tr,
            style: TextStyle(
              fontSize: 15.scaled,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 32.scaled),
          AppTextField(
            label: 'phone_number'.tr,
            controller: controller.phoneController,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              PhoneInputFormatter(),
            ],
            hintText: '012 345 678',
            prefixIcon: Container(
              margin: EdgeInsets.only(right: 8.scaled),
              padding: EdgeInsets.symmetric(horizontal: 12.scaled),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '🇰🇭',
                    style: TextStyle(fontSize: 18.scaled),
                  ),
                  SizedBox(width: 4.scaled),
                  Text(
                    '+855',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.scaled,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.scaled),
          Obx(
            () => AppTextField(
              label: 'password'.tr,
              controller: controller.passwordController,
              obscureText: !controller.isPasswordVisible.value,
              hintText: '••••••••',
              suffixIcon: IconButton(
                icon: Icon(
                  controller.isPasswordVisible.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Colors.white.withValues(alpha: 0.7),
                  size: 20.scaled,
                ),
                onPressed: controller.togglePasswordVisibility,
              ),
            ),
          ),
          SizedBox(height: 36.scaled),
          Obx(
            () => PrimaryButton(
              label: 'login'.tr,
              onPressed: controller.login,
              isLoading: controller.isLoading.value,
              icon: Icons.arrow_forward,
              borderRadius: 16,
              height: 56.scaled,
            ),
          ),
          SizedBox(height: 24.scaled),
          Center(
            child: GestureDetector(
              onTap: () async =>
                  await Get.toNamed<void>(AppRoutes.register),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14.scaled,
                  ),
                  children: [
                    TextSpan(text: '${'new_to_freshleaf'.tr} '),
                    TextSpan(
                      text: 'create_account'.tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
