import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fresh_leaf/app/modules/register/controllers/register_controller.dart';
import 'package:fresh_leaf/shared/helpers/phone_input_formatter.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
import 'package:fresh_leaf/shared/widgets/app_password_toggle.dart';
import 'package:fresh_leaf/shared/widgets/app_phone_prefix.dart';
import 'package:fresh_leaf/shared/widgets/app_text_field.dart';
import 'package:fresh_leaf/shared/widgets/primary_button.dart';
import 'package:get/get.dart';

class RegisterFormContent extends StatelessWidget {
  const RegisterFormContent({
    required this.controller,
    required this.constraints,
    super.key,
  });

  final RegisterController controller;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final keyboardVisible = media.viewInsets.bottom > 0;

    final verticalPadding = (keyboardVisible ? 11.0 : 18.scaled).clamp(
      11.0,
      18.0,
    );
    final topGap = constraints.maxHeight < 720
        ? 5.0
        : 12.scaled.clamp(5.0, 12.0);
    final eyebrowSize = 11.scaled.clamp(9.0, 11.0);
    final headingSpacing = 6.scaled.clamp(4.0, 9.0);
    final headingSize = 33.scaled.clamp(27.0, 37.0);
    final subtitleGap = 10.scaled.clamp(8.0, 12.0);
    final subtitleSize = 14.scaled.clamp(12.8, 15.0);
    final showHero = constraints.maxHeight >= 620;
    final blockGap = (showHero ? 15.scaled : 11.scaled).clamp(9.0, 15.0);
    final heroHeight = 150.scaled.clamp(96.0, 146.0);
    final heroRadius = 20.scaled.clamp(16.0, 22.0);
    final heroGap = 13.scaled.clamp(10.0, 18.0);
    final fieldGap = 14.scaled.clamp(10.0, 15.0);
    final actionGap = 17.scaled.clamp(13.0, 20.0);
    final buttonHeight = 54.scaled.clamp(49.0, 58.0);
    final footerGap = 11.scaled.clamp(8.0, 13.0);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 24.scaled,
        vertical: verticalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: topGap),
          Text(
            'register_eyebrow'.tr,
            style: TextStyle(
              color: scheme.secondary,
              fontSize: eyebrowSize,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: headingSpacing),
          Text(
            'register_title'.tr,
            style: TextStyle(
              color: scheme.primary,
              fontSize: headingSize,
              fontWeight: FontWeight.w900,
              height: 1.05,
              letterSpacing: -1,
            ),
          ),
          SizedBox(height: subtitleGap),
          Text(
            'register_subtitle'.tr,
            style: TextStyle(
              fontSize: subtitleSize,
              color: scheme.onSurfaceVariant,
              height: 1.25,
            ),
          ),
          SizedBox(height: blockGap),
          if (showHero) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(heroRadius),
              child: SizedBox(
                height: heroHeight,
                width: media.size.width,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      'https://images.unsplash.com/photo-1542838132-92c53300491e?q=80&w=1000',
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          color: scheme.surfaceContainerHighest,
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        final imageScheme = Theme.of(context).colorScheme;
                        return ColoredBox(
                          color: imageScheme.surfaceContainerHighest,
                          child: Center(
                            child: Icon(
                              Icons.broken_image_rounded,
                              color: imageScheme.onSurfaceVariant,
                              size: 28.scaled,
                            ),
                          ),
                        );
                      },
                    ),
                    if (isDark)
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              Colors.transparent,
                              const Color(0x4D000000),
                              scheme.surface.withValues(alpha: 0.7),
                            ],
                            stops: const <double>[0.35, 0.7, 1],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: heroGap),
          ],
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'first_name'.tr,
                      hintText: 'first_name_hint'.tr,
                      controller: controller.firstNameController,
                    ),
                  ),
                  SizedBox(width: 16.scaled),
                  Expanded(
                    child: AppTextField(
                      label: 'last_name'.tr,
                      hintText: 'last_name_hint'.tr,
                      controller: controller.lastNameController,
                    ),
                  ),
                ],
              ),
              SizedBox(height: fieldGap),
              AppTextField(
                label: 'phone'.tr,
                hintText: 'placeholder_phone'.tr,
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  PhoneInputFormatter(),
                ],
                prefixIcon: const AppPhonePrefix(),
              ),
              SizedBox(height: fieldGap),
              Obx(
                () => AppTextField(
                  label: 'password'.tr,
                  hintText: '••••••••',
                  controller: controller.passwordController,
                  obscureText: !controller.isPasswordVisible.value,
                  suffixIcon: AppPasswordToggle(
                    isVisible: controller.isPasswordVisible.value,
                    onPressed: controller.togglePasswordVisibility,
                  ),
                ),
              ),
              SizedBox(height: fieldGap),
              Obx(
                () => AppTextField(
                  label: 'password_confirmation'.tr,
                  hintText: '••••••••',
                  controller: controller.passwordConfirmController,
                  obscureText: !controller.isPasswordConfirmVisible.value,
                  suffixIcon: AppPasswordToggle(
                    isVisible: controller.isPasswordConfirmVisible.value,
                    onPressed: controller.togglePasswordConfirmVisibility,
                  ),
                ),
              ),
              SizedBox(height: actionGap),
              Obx(
                () => PrimaryButton(
                  label: 'sign_up'.tr,
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.signUp,
                  isLoading: controller.isLoading.value,
                  icon: Icons.arrow_upward,
                  height: buttonHeight,
                  borderRadius: 16,
                ),
              ),
              SizedBox(height: footerGap),
              Center(
                child: GestureDetector(
                  onTap: controller.nextPage,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: scheme.onSurface,
                        fontSize: 14.scaled,
                      ),
                      children: [
                        TextSpan(text: '${'already_have_account'.tr}  '),
                        TextSpan(
                          text: 'login_here'.tr,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: scheme.primary,
                            decorationColor: scheme.primary,
                            decorationThickness: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
