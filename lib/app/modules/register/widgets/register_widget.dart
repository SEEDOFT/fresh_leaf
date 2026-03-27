import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:fresh_leaf/app/modules/register/controllers/register_controller.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';

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
    final double scale = (constraints.maxHeight / 780)
        .clamp(0.82, 1.0)
        .toDouble();

    final double verticalPadding = (20 * scale).clamp(14, 20).toDouble();
    final double topGap = (8 * scale).clamp(6, 10).toDouble();
    final double eyebrowSize = (11 * scale).clamp(9, 11).toDouble();
    final double headingSpacing = (6 * scale).clamp(4, 8).toDouble();
    final double headingSize = (36 * scale).clamp(30, 40).toDouble();
    final double subtitleGap = (10 * scale).clamp(8, 14).toDouble();
    final double subtitleSize = (14 * scale).clamp(13, 15).toDouble();
    final double blockGap = (18 * scale).clamp(14, 22).toDouble();
    final double heroHeight = (150 * scale).clamp(120, 190).toDouble();
    final double heroRadius = (22 * scale).clamp(18, 24).toDouble();
    final double heroGap = (20 * scale).clamp(16, 26).toDouble();
    final double fieldGap = (18 * scale).clamp(14, 22).toDouble();
    final double actionGap = (20 * scale).clamp(16, 28).toDouble();
    final double buttonHeight = (52 * scale).clamp(48, 56).toDouble();
    final double footerGap = (12 * scale).clamp(8, 16).toDouble();

    return SingleChildScrollView(
      child: Padding(
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
                color: AppColors.brownAccent,
                fontSize: eyebrowSize,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: headingSpacing),
            Text(
              'Join the\nOrganic Circle',
              style: TextStyle(
                color: AppColors.darkGreen,
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
                color: AppColors.textDark,
                height: 1.35,
              ),
            ),
            SizedBox(height: blockGap),
            ClipRRect(
              borderRadius: BorderRadius.circular(heroRadius),
              child: SizedBox(
                height: heroHeight,
                width: double.infinity,
                child: Image.network(
                  'https://images.unsplash.com/photo-1542838132-92c53300491e?q=80&w=1000',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: heroGap),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: RegisterWidget.buildInputField(
                        label: 'FIRST NAME',
                        hint: 'Jane',
                        textController: controller.firstNameController,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: RegisterWidget.buildInputField(
                        label: 'LAST NAME',
                        hint: 'Doe',
                        textController: controller.lastNameController,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: fieldGap),
                RegisterWidget.buildInputField(
                  label: 'PHONE NUMBER',
                  hint: '123 424 123',
                  prefixText: '+855',
                  textController: controller.phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                SizedBox(height: fieldGap),
                Obx(
                  () => RegisterWidget.buildInputField(
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
                        color: AppColors.textGrey,
                        size: 20,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                  ),
                ),
                SizedBox(height: fieldGap),
                Obx(
                  () => RegisterWidget.buildInputField(
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
                        color: AppColors.textGrey,
                        size: 20,
                      ),
                      onPressed: controller.togglePasswordConfirmVisibility,
                    ),
                  ),
                ),
                SizedBox(height: actionGap),
                Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.value ? null : controller.signUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkGreen,
                      minimumSize: Size(double.infinity, buttonHeight),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 0,
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'SIGN UP',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 1.2,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: footerGap),
                Center(
                  child: GestureDetector(
                    onTap: controller.nextPage,
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: 'Already have an account?  ',
                          ),
                          TextSpan(
                            text: 'Login to FreshLeaf',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: AppColors.darkGreen,
                              decorationColor: AppColors.darkGreen,
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
      ),
    );
  }
}

class RegisterWidget {
  // Build Input Field
  static Widget buildInputField({
    required String label,
    required String hint,
    required TextEditingController textController,
    String? prefixText,
    Widget? suffixIcon,
    bool obscureText = false,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.normal,
            letterSpacing: 1.5,
            color: AppColors.textDark,
          ),
        ),
        TextField(
          controller: textController,
          obscureText: obscureText,
          obscuringCharacter: '•',
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 16,
            // Add wide letter spacing ONLY if it's an obscured password field
            letterSpacing: (isPassword && obscureText) ? 4.0 : 0.0,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppColors.textGrey.withValues(alpha: 0.5),
              fontSize: 16,
              letterSpacing: isPassword ? 4.0 : 0.0,
            ),
            prefixText: prefixText,
            prefixStyle: const TextStyle(
              color: AppColors.textDark,
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
            suffixIcon: suffixIcon,
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black12),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.darkGreen, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ],
    );
  }
}
