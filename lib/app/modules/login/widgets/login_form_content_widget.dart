import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fresh_leaf/app/modules/login/controllers/login_controller.dart';
import 'package:fresh_leaf/app/modules/login/widgets/login_background_hero_widget.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/shared/helpers/phone_input_formatter.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
import 'package:fresh_leaf/shared/widgets/app_password_toggle.dart';
import 'package:fresh_leaf/shared/widgets/app_phone_prefix.dart';
import 'package:fresh_leaf/shared/widgets/app_text_field.dart';
import 'package:fresh_leaf/shared/widgets/primary_button.dart';
import 'package:get/get.dart';

class LoginFormContent extends StatelessWidget {
  const LoginFormContent({
    required this.controller,
    required this.constraints,
    super.key,
  });

  final LoginController controller;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final scheme = Theme.of(context).colorScheme;
    final keyboardVisible = media.viewInsets.bottom > 0;

    final heroHeight = (constraints.maxHeight * 0.42).clamp(230.0, 360.0);
    final horizontalPadding = 24.scaled.clamp(20, 24).toDouble();
    final formTopPadding = 24.scaled.clamp(16, 24).toDouble();
    final formBottomPadding = keyboardVisible ? 16.0 : 24.0;

    const overlap = 32.0;

    return Stack(
      children: [
        SizedBox(
          width: media.size.width,
          height: heroHeight + overlap,
          child: const BackgroundHeroWidget(),
        ),
        Padding(
          padding: EdgeInsets.only(top: heroHeight),
          child: Material(
            color: scheme.surface,
            shadowColor: Colors.black.withValues(alpha: 0.1),
            elevation: 20,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(32),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Container(
              width: media.size.width,
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - heroHeight,
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  formTopPadding,
                  horizontalPadding,
                  formBottomPadding,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'welcome_back'.tr,
                      style: TextStyle(
                        fontSize: 28.scaled,
                        fontWeight: FontWeight.w800,
                        color: scheme.onSurface,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 8.scaled),
                    Text(
                      'login_subtitle'.tr,
                      style: TextStyle(
                        fontSize: 15.scaled,
                        color: scheme.onSurfaceVariant,
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
                      hintText: '012 234 567',
                      prefixIcon: const AppPhonePrefix(),
                    ),
                    SizedBox(height: 28.scaled),
                    Obx(
                      () => AppTextField(
                        label: 'password'.tr,
                        controller: controller.passwordController,
                        obscureText: !controller.isPasswordVisible.value,
                        hintText: '••••••••',
                        suffixIcon: AppPasswordToggle(
                          isVisible: controller.isPasswordVisible.value,
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
                    SizedBox(height: 20.scaled),
                    Center(
                      child: GestureDetector(
                        onTap: () async =>
                            await Get.toNamed<void>(AppRoutes.register),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: scheme.onSurfaceVariant,
                              fontSize: 14.scaled,
                            ),
                            children: [
                              TextSpan(text: '${'new_to_freshleaf'.tr} '),
                              TextSpan(
                                text: 'create_account'.tr,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: scheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
