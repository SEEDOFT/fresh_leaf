import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import '../controllers/login_controller.dart';
import 'login_background_hero_widget.dart';

class LoginFormContent extends StatelessWidget {
  const LoginFormContent({
    super.key,
    required this.controller,
    required this.constraints,
  });

  final LoginController controller;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final scheme = Theme.of(context).colorScheme;
    final keyboardVisible = media.viewInsets.bottom > 0;
    final double scale = (constraints.maxHeight / 780)
        .clamp(0.82, 1.0)
        .toDouble();
    final double heroHeight = (constraints.maxHeight * 0.42)
        .clamp(230.0, 360.0)
        .toDouble();
    final double horizontalPadding = (24 * scale).clamp(20, 24).toDouble();
    final double formTopPadding = (24 * scale).clamp(16, 24).toDouble();
    final double formBottomPadding = keyboardVisible ? 16 : 24;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: media.size.width,
          height: heroHeight,
          child: const BackgroundHeroWidget(),
        ),
        Container(
          width: media.size.width,
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
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
                'Welcome back',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to access your curated selection.',
                style: TextStyle(fontSize: 15, color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 32),
              Text(
                'PHONE NUMBER',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
                cursorColor: scheme.primary,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: '012 345 678',
                  isDense: true,
                  hintStyle: TextStyle(
                    color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
                    fontSize: 15,
                  ),
                  filled: true,
                  fillColor: scheme.surface,
                  prefixStyle: TextStyle(
                    color: scheme.primary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: scheme.outline.withValues(alpha: 0.65),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: scheme.primary, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'PASSWORD',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 6),
              Obx(
                () => TextField(
                  controller: controller.passwordController,
                  obscureText: !controller.isPasswordVisible.value,
                  obscuringCharacter: '•',
                  cursorColor: scheme.primary,
                  style: TextStyle(
                    color: scheme.onSurface,
                    fontSize: 16,
                    letterSpacing: 4,
                  ),
                  decoration: InputDecoration(
                    hintText: '••••••••',
                    isDense: true,
                    hintStyle: TextStyle(
                      color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
                      fontSize: 15,
                      letterSpacing: 4,
                    ),
                    filled: true,
                    fillColor: scheme.surface,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: scheme.outline.withValues(alpha: 0.65),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: scheme.primary, width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
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
              ),
              const SizedBox(height: 36),
              Obx(
                () => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDarkGreen,
                    minimumSize: Size(media.size.width, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.register),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: scheme.onSurfaceVariant,
                        fontSize: 14,
                      ),
                      children: [
                        const TextSpan(text: 'New to FreshLeaf? '),
                        TextSpan(
                          text: 'Create an account',
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
      ],
    );
  }
}
