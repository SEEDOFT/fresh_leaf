import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:fresh_leaf/app/modules/register/controllers/register_controller.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import 'register_input_field_widget.dart';

class RegisterFormContent extends StatelessWidget {
  const RegisterFormContent({
    super.key,
    required this.controller,
    required this.constraints,
  });

  final RegisterController controller;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final scheme = Theme.of(context).colorScheme;
    final keyboardVisible = media.viewInsets.bottom > 0;
    final double scale = (constraints.maxHeight / 805)
        .clamp(0.76, 1.0)
        .toDouble();
    final bool compact = constraints.maxHeight < 720;

    final double verticalPadding = (keyboardVisible ? 11 : 18 * scale)
        .clamp(11, 18)
        .toDouble();
    final double topGap = compact ? 5 : (12 * scale).clamp(5, 12).toDouble();
    final double eyebrowSize = (11 * scale).clamp(9, 11).toDouble();
    final double headingSpacing = (6 * scale).clamp(4, 9).toDouble();
    final double headingSize = (33 * scale).clamp(27, 37).toDouble();
    final double subtitleGap = (10 * scale).clamp(8, 12).toDouble();
    final double subtitleSize = (14 * scale).clamp(12.8, 15).toDouble();
    final bool showHero = constraints.maxHeight >= 620;
    final double blockGap = (showHero ? 15 * scale : 11 * scale)
        .clamp(9, 15)
        .toDouble();
    final double heroHeight = (128 * scale).clamp(96, 146).toDouble();
    final double heroRadius = (20 * scale).clamp(16, 22).toDouble();
    final double heroGap = (13 * scale).clamp(10, 18).toDouble();
    final double fieldGap = (14 * scale).clamp(10, 15).toDouble();
    final double actionGap = (17 * scale).clamp(13, 20).toDouble();
    final double buttonHeight = (54 * scale).clamp(49, 58).toDouble();
    final double footerGap = (11 * scale).clamp(8, 13).toDouble();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: verticalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: topGap),
          Text(
            'WELCOME TO THE LARDER',
            style: TextStyle(
              color: scheme.secondary,
              fontSize: eyebrowSize,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: headingSpacing),
          Text(
            'Join the\nOrganic Circle',
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
            'Curated seasonal harvests from our fields directly to your kitchen.',
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
                child: Image.network(
                  'https://images.unsplash.com/photo-1542838132-92c53300491e?q=80&w=1000',
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(color: AppColors.cardLight);
                  },
                  errorBuilder: (context, error, stackTrace) {
                    final imageScheme = Theme.of(context).colorScheme;
                    return Container(
                      color: AppColors.cardLight,
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
                      label: 'FIRST NAME',
                      hint: 'Jane',
                      textController: controller.firstNameController,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: RegisterWidget.buildInputField(
                      context: context,
                      label: 'LAST NAME',
                      hint: 'Doe',
                      textController: controller.lastNameController,
                    ),
                  ),
                ],
              ),
              SizedBox(height: fieldGap),
              RegisterWidget.buildInputField(
                context: context,
                label: 'PHONE NUMBER',
                hint: '012 345 678',
                textController: controller.phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              SizedBox(height: fieldGap),
              Obx(
                () => RegisterWidget.buildInputField(
                  context: context,
                  label: 'PASSWORD',
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
                  label: 'PASSWORD CONFIRMATION',
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
                    backgroundColor: AppColors.darkGreen,
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
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'SIGN UP',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.arrow_upward,
                              color: Colors.white,
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
                        const TextSpan(
                          text: 'Already have an account?  ',
                        ),
                        TextSpan(
                          text: 'Login to FreshLeaf',
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
