import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/register/widgets/register_widget.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.backgroundCream,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: Get.back,
          ),
        ),
        backgroundColor: AppColors.bgCream,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double scale = (constraints.maxHeight / 780)
                  .clamp(0.82, 1.0)
                  .toDouble();

              final double verticalPadding = (20 * scale)
                  .clamp(14, 20)
                  .toDouble();
              final double topGap = (8 * scale).clamp(6, 10).toDouble();
              final double eyebrowSize = (11 * scale).clamp(9, 11).toDouble();
              final double headingSpacing = (6 * scale).clamp(4, 8).toDouble();
              final double headingSize = (36 * scale).clamp(30, 40).toDouble();
              final double subtitleGap = (10 * scale).clamp(8, 14).toDouble();
              final double subtitleSize = (14 * scale).clamp(13, 15).toDouble();
              final double blockGap = (18 * scale).clamp(14, 22).toDouble();
              final double heroHeight = (150 * scale)
                  .clamp(120, 190)
                  .toDouble();
              final double heroRadius = (22 * scale).clamp(18, 24).toDouble();
              final double heroGap = (20 * scale).clamp(16, 26).toDouble();
              final double fieldGap = (18 * scale).clamp(14, 22).toDouble();
              final double actionGap = (20 * scale).clamp(16, 28).toDouble();
              final double buttonHeight = (52 * scale).clamp(48, 56).toDouble();
              final double footerGap = (12 * scale).clamp(8, 16).toDouble();

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

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: RegisterWidget.buildInputField(
                                  label: 'FIRST NAME',
                                  hint: 'Jane',
                                  textController:
                                      controller.firstNameController,
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
                            hint: '+(855) 123 424 123',
                            textController: controller.phoneController,
                            keyboardType: TextInputType.phone,
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
                          SizedBox(height: actionGap),

                          const Spacer(),

                          ElevatedButton(
                            onPressed: controller.signUp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.darkGreen,
                              minimumSize: Size(double.infinity, buttonHeight),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'SIGN UP',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          SizedBox(height: footerGap),

                          Center(
                            child: GestureDetector(
                              onTap: () {
                                // Navigate to Login: Get.offNamed('/login');
                              },
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
                                        decoration: TextDecoration.underline,
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
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
