import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fresh_leaf/app/modules/register/controllers/register_controller.dart';
import 'package:fresh_leaf/shared/helpers/phone_input_formatter.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
import 'package:fresh_leaf/shared/widgets/app_text_field.dart';
import 'package:fresh_leaf/shared/widgets/glass_card.dart';
import 'package:fresh_leaf/shared/widgets/primary_button.dart';
import 'package:get/get.dart';

class RegisterFormContent extends StatelessWidget {
  const RegisterFormContent({
    required this.controller,
    super.key,
  });

  final RegisterController controller;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GlassCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'register_title'.tr,
            style: TextStyle(
              color: Colors.white,
              fontSize: 32.scaled,
              fontWeight: FontWeight.w900,
              height: 1.1,
              letterSpacing: -1,
            ),
          ),
          SizedBox(height: 8.scaled),
          Text(
            'register_subtitle'.tr,
            style: TextStyle(
              fontSize: 14.scaled,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 32.scaled),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  label: 'first_name'.tr,
                  hintText: 'Jane',
                  controller: controller.firstNameController,
                ),
              ),
              SizedBox(width: 16.scaled),
              Expanded(
                child: AppTextField(
                  label: 'last_name'.tr,
                  hintText: 'Doe',
                  controller: controller.lastNameController,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.scaled),
          AppTextField(
            label: 'phone_number'.tr,
            hintText: '012 345 678',
            controller: controller.phoneController,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              PhoneInputFormatter(),
            ],
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
              hintText: '••••••••',
              controller: controller.passwordController,
              obscureText: !controller.isPasswordVisible.value,
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
          SizedBox(height: 24.scaled),
          Obx(
            () => AppTextField(
              label: 'password_confirmation'.tr,
              hintText: '••••••••',
              controller: controller.passwordConfirmController,
              obscureText: !controller.isPasswordConfirmVisible.value,
              suffixIcon: IconButton(
                icon: Icon(
                  controller.isPasswordConfirmVisible.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Colors.white.withValues(alpha: 0.7),
                  size: 20.scaled,
                ),
                onPressed: controller.togglePasswordConfirmVisibility,
              ),
            ),
          ),
          SizedBox(height: 36.scaled),
          Obx(
            () => PrimaryButton(
              label: 'sign_up'.tr,
              onPressed: controller.isLoading.value ? null : controller.signUp,
              isLoading: controller.isLoading.value,
              icon: Icons.arrow_upward,
              height: 56.scaled,
              borderRadius: 16,
            ),
          ),
          SizedBox(height: 24.scaled),
          Center(
            child: GestureDetector(
              onTap: controller.nextPage,
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14.scaled,
                  ),
                  children: [
                    TextSpan(text: '${'already_have_account'.tr}  '),
                    TextSpan(
                      text: 'login_here'.tr,
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
