import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundCream,
        body: SafeArea(
          child: Stack(
            children: [
              // 1. Background Hero Image & Logo
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.45,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Replace with your local asset or actual network image
                    Image.network(
                      'https://images.unsplash.com/photo-1597362925123-77861d3fbac7?q=80&w=1000',
                      fit: BoxFit.cover,
                    ),
                    // Dark gradient overlay to make text pop
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColors.backgroundCream.withValues(alpha: 0.2),
                            AppColors.backgroundCream.withValues(alpha: 0.9),
                          ],
                          stops: const [0.5, 0.8, 1.0],
                        ),
                      ),
                    ),
                    // Logo Text overlay
                    Positioned(
                      bottom: 60,
                      left: 24,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'FreshLeaf',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primaryDarkGreen,
                              letterSpacing: -1,
                            ),
                          ),
                          Text(
                            'THE DIGITAL LARDER',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                              color: AppColors.primaryDarkGreen.withValues(
                                alpha: 0.8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 2. White Form Card (Overlapping)
              Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.4,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.backgroundCream,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      // Headings
                      const Text(
                        'Welcome back',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111111),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Sign in to access your curated selection.',
                        style: TextStyle(fontSize: 15, color: Colors.black87),
                      ),
                      const SizedBox(height: 40),

                      // Phone Number Input
                      const Text(
                        'PHONE NUMBER',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          color: Colors.black87,
                        ),
                      ),
                      TextField(
                        controller: controller.phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: '+(855) 123 345 332',
                          hintStyle: TextStyle(
                            color: AppColors.inputHintColor,
                            fontSize: 16,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.primaryDarkGreen,
                              width: 2,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Password Input Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'PASSWORD',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              color: Colors.black87,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'FORGOT PASSWORD?',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                                color: AppColors.linkColor,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Password Input Field with Obx toggle
                      Obx(
                        () => TextField(
                          controller: controller.passwordController,
                          obscureText: !controller.isPasswordVisible.value,
                          obscuringCharacter: '•',
                          style: const TextStyle(
                            letterSpacing: 4,
                          ), // Spreads out the dots
                          decoration: InputDecoration(
                            hintText: '••••••••',
                            hintStyle: const TextStyle(
                              color: AppColors.inputHintColor,
                              letterSpacing: 4,
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.primaryDarkGreen,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isPasswordVisible.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: AppColors.inputHintColor,
                                size: 20,
                              ),
                              onPressed: controller.togglePasswordVisibility,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),

                      // Login Button
                      ElevatedButton(
                        onPressed: controller.login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryDarkGreen,
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Row(
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
                      const SizedBox(height: 24),

                      // Create Account Link
                      Center(
                        child: GestureDetector(
                          onTap: () => Get.toNamed('/register'),
                          child: RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                              ),
                              children: [
                                TextSpan(text: 'New to FreshLeaf? '),
                                TextSpan(
                                  text: 'Create an account',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryDarkGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
