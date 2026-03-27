import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/onboarding/widgets/onboarding_widget.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final pageHeight = media.size.height * 0.52; // keep content comfortably centered

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8F2),
      body: SafeArea(
        child: Stack(
          children: [
            // Skip
            Positioned(
              top: 12,
              right: 16,
              child: TextButton(
                onPressed: () => controller.skip(),
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    color: Color(0xFF1E3616),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            // Background Image
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * 0.6,
              child: ShaderMask(
                shaderCallback: (rect) => const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Colors.transparent],
                ).createShader(rect),
                blendMode: BlendMode.dstIn,
                child: Image.network(
                  'https://images.unsplash.com/photo-1540420773420-3366772f4999?q=80&w=1000',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 28),
                  const OnboardingLogo(),

                  // 1. PageView for the text content
                  SizedBox(
                    height: pageHeight,
                    child: PageView.builder(
                      controller: controller.pageController,
                      onPageChanged: controller.currentPage.call,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return OnboardingTextContent(index: index);
                      },
                    ),
                  ),
                  const SizedBox(height: 18),
                  // 2. Action Button controlled by GetX (closer to content)
                  Obx(
                    () => SizedBox(
                      height: 68,
                      child: ElevatedButton(
                        onPressed: controller.nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A3C14),
                          minimumSize: const Size(double.infinity, 64),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              controller.isLastPage ? 'Get Started' : 'Next',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Info Card
                  const OnboardingInfoCard(),
                  const SizedBox(height: 16),

                  // 3. Smooth Page Indicator
                  Center(
                    child: SmoothPageIndicator(
                      controller: controller.pageController,
                      count: 3,
                      effect: const ExpandingDotsEffect(
                        activeDotColor: Color(0xFF1E3616),
                        dotColor: Colors.black12,
                        dotHeight: 8,
                        dotWidth: 8,
                        expansionFactor: 4,
                        spacing: 8,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
