import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingTextContent extends StatelessWidget {
  const OnboardingTextContent({required this.index, super.key});

  final int index;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isDark
                ? scheme.secondaryContainer.withValues(alpha: 0.8)
                : const Color(0xFFFDE2D3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'onboarding_badge'.tr,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: isDark
                  ? scheme.onSecondaryContainer
                  : const Color(0xFF8B5E3C),
            ),
          ),
        ),
        const SizedBox(height: 16),
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              height: 1.1,
              fontFamily: 'Serif',
            ),
            children: [
              TextSpan(
                text: '${'onboarding_title_top'.tr}\n',
                style: TextStyle(color: scheme.onSurface),
              ),
              TextSpan(
                text: 'onboarding_title_bottom'.tr,
                style: TextStyle(color: scheme.primary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'onboarding_subtitle'.tr,
          style: TextStyle(
            fontSize: 16,
            color: scheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
