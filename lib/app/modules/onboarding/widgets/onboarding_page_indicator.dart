import 'package:flutter/material.dart';

class OnboardingPageIndicator extends StatelessWidget {
  const OnboardingPageIndicator({
    required this.controller,
    required this.count,
    required this.activeColor,
    required this.inactiveColor,
    super.key,
  });

  final PageController controller;
  final int count;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final currentPage = controller.hasClients
            ? (controller.page ?? controller.initialPage.toDouble())
            : controller.initialPage.toDouble();
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(count, (index) {
            final distance = (currentPage - index).abs();
            final isActive = distance < 0.5;
            final width = isActive ? 24.0 : 8.0;
            final color = isActive ? activeColor : inactiveColor;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              width: width,
              height: 8,
              margin: EdgeInsets.only(right: index == count - 1 ? 0 : 8),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(999),
              ),
            );
          }),
        );
      },
    );
  }
}
