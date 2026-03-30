import 'package:flutter/material.dart';

class OnboardingTextContent extends StatelessWidget {
  const OnboardingTextContent({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFFDE2D3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'THE DIGITAL LARDER',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Color(0xFF8B5E3C),
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
                text: 'Freshness\n',
                style: TextStyle(color: scheme.onSurface),
              ),
              TextSpan(
                text: 'Delivered.',
                style: TextStyle(color: scheme.primary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Sourcing the finest seasonal produce directly from boutique organic farms to your kitchen.',
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
