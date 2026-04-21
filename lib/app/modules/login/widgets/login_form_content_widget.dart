import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fresh_leaf/app/modules/login/controllers/login_controller.dart';
import 'package:fresh_leaf/app/modules/login/widgets/login_background_hero_widget.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final keyboardVisible = media.viewInsets.bottom > 0;
    final scale = (constraints.maxHeight / 780).clamp(0.82, 1.0);
    final heroHeight = (constraints.maxHeight * 0.42).clamp(230.0, 360.0);
    final horizontalPadding = (24 * scale).clamp(20, 24).toDouble();
    final formTopPadding = (24 * scale).clamp(16, 24).toDouble();
    final formBottomPadding = keyboardVisible ? 16.0 : 24.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: media.size.width,
          height: heroHeight,
          child: const BackgroundHeroWidget(),
        ),
        Expanded(
          child: Material(
            color: scheme.surface,
            shadowColor: isDark ? Colors.transparent : const Color(0x14000000),
            elevation: isDark ? 0 : 2,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(32),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              width: media.size.width,
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
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: scheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'login_subtitle'.tr,
                      style: TextStyle(
                        fontSize: 15,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),
                    AppTextField(
                      label: 'phone_number'.tr,
                      controller: controller.phoneController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      hintText: '012 345 678',
                    ),
                    const SizedBox(height: 28),
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
                            color: scheme.onSurfaceVariant,
                            size: 20,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),
                    Obx(
                      () => PrimaryButton(
                        label: 'login'.tr,
                        onPressed: controller.login,
                        isLoading: controller.isLoading.value,
                        icon: Icons.arrow_forward,
                        borderRadius: 12,
                        height: 56,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: GestureDetector(
                        onTap: () async =>
                            await Get.toNamed<void>(AppRoutes.register),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: scheme.onSurfaceVariant,
                              fontSize: 14,
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
