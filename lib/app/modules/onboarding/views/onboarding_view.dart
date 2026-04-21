import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:fresh_leaf/app/modules/onboarding/widgets/onboarding_widget.dart';
import 'package:fresh_leaf/shared/widgets/primary_button.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    final pageHeight = media.size.height * 0.52;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: Stack(
          children: [
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
                          size: 34,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Skip
            Positioned(
              top: 8,
              right: 16,
              child: Obx(
                () => controller.isLastPage
                    ? const SizedBox.shrink()
                    : TextButton(
                        onPressed: controller.skip,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          backgroundColor: scheme.surface.withValues(
                            alpha: 0.92,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'skip'.tr,
                          style: TextStyle(
                            color: scheme.onSurface,
                          ),
                        ),
                      ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
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
                    () => PrimaryButton(
                      label: controller.isLastPage
                          ? 'get_started'.tr
                          : 'next'.tr,
                      onPressed: controller.nextPage,
                      icon: Icons.arrow_forward,
                      height: 68,
                      borderRadius: 16,
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
                      effect: ExpandingDotsEffect(
                        activeDotColor: scheme.primary,
                        dotColor: isDark
                            ? scheme.outline.withValues(alpha: 0.65)
                            : scheme.outline.withValues(alpha: 0.35),
                        dotHeight: 8,
                        dotWidth: 8,
                        expansionFactor: 4,
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
