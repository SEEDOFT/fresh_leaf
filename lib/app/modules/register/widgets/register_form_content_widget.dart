import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fresh_leaf/app/modules/register/controllers/register_controller.dart';
import 'package:fresh_leaf/app/modules/register/widgets/register_input_field_widget.dart';
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
    final scale = (constraints.maxHeight / 805).clamp(0.76, 1.0);
    final compact = constraints.maxHeight < 720;

    final verticalPadding = (keyboardVisible ? 11 : 18 * scale)
        .clamp(11, 18)
        .toDouble();
    final topGap = compact ? 5 : (12 * scale).clamp(5, 12).toDouble();
    final eyebrowSize = (11 * scale).clamp(9, 11).toDouble();
    final headingSpacing = (6 * scale).clamp(4, 9).toDouble();
    final headingSize = (33 * scale).clamp(27, 37).toDouble();
    final subtitleGap = (10 * scale).clamp(8, 12).toDouble();
    final subtitleSize = (14 * scale).clamp(12.8, 15).toDouble();
    final showHero = constraints.maxHeight >= 620;
    final blockGap = (showHero ? 15 * scale : 11 * scale)
        .clamp(9, 15)
        .toDouble();
    final heroHeight = (150 * scale).clamp(96, 146).toDouble();
    final heroRadius = (20 * scale).clamp(16, 22).toDouble();
    final heroGap = (13 * scale).clamp(10, 18).toDouble();
    final fieldGap = (14 * scale).clamp(10, 15).toDouble();
    final actionGap = (17 * scale).clamp(13, 20).toDouble();
    final buttonHeight = (54 * scale).clamp(49, 58).toDouble();
    final footerGap = (11 * scale).clamp(8, 13).toDouble();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: verticalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: topGap.toDouble()),
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
                        return Container(color: scheme.surfaceContainerHighest);
                      },
                      errorBuilder: (context, error, stackTrace) {
                        final imageScheme = Theme.of(context).colorScheme;
                        return ColoredBox(
                          color: imageScheme.surfaceContainerHighest,
                          child: Center(
                            child: Icon(
                              Icons.broken_image_rounded,
                              color: imageScheme.onSurfaceVariant,
                              size: 28,
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
                    child: RegisterWidget.buildInputField(
                      context: context,
                      label: 'first_name'.tr.toUpperCase(),
                      hint: 'Jane',
                      textController: controller.firstNameController,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: RegisterWidget.buildInputField(
                      context: context,
                      label: 'last_name'.tr.toUpperCase(),
                      hint: 'Doe',
                      textController: controller.lastNameController,
                    ),
                  ),
                ],
              ),
              SizedBox(height: fieldGap),
              RegisterWidget.buildInputField(
                context: context,
                label: 'phone_number'.tr.toUpperCase(),
                hint: '012 345 678',
                textController: controller.phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              SizedBox(height: fieldGap),
              Obx(
                () => RegisterWidget.buildInputField(
                  context: context,
                  label: 'password'.tr.toUpperCase(),
                  hint: '••••••••',
                  textController: controller.passwordController,
                  obscureText: !controller.isPasswordVisible.value,
                  isPassword: true,
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
              SizedBox(height: fieldGap),
              Obx(
                () => RegisterWidget.buildInputField(
                  context: context,
                  label: 'password_confirmation'.tr.toUpperCase(),
                  hint: '••••••••',
                  textController: controller.passwordConfirmController,
                  obscureText: !controller.isPasswordConfirmVisible.value,
                  isPassword: true,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordConfirmVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: scheme.onSurfaceVariant,
                      size: 20,
                    ),
                    onPressed: controller.togglePasswordConfirmVisibility,
                  ),
                ),
              ),
              SizedBox(height: actionGap),
              Obx(
                () => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: scheme.primary,
                    minimumSize: Size(
                      media.size.width,
                      buttonHeight,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  child: controller.isLoading.value
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              scheme.onPrimary,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'sign_up'.tr.toUpperCase(),
                              style: TextStyle(
                                color: scheme.onPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.arrow_upward,
                              color: scheme.onPrimary,
                            ),
                          ],
                        ),
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
                        fontSize: 14,
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
