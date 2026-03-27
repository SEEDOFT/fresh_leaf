import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fresh_leaf/core/constants/svg_assets.dart';

// Logo Widget
class OnboardingLogo extends StatelessWidget {
  const OnboardingLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 8, height: 32, color: Colors.white),
        const SizedBox(width: 8),
        const Text(
          'FreshLeaf',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

// Info Card Widget
class OnboardingInfoCard extends StatelessWidget {
  const OnboardingInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 98,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          // Leaf Logo
          SizedBox(
            height: 48,
            width: 48,
            child: CircleAvatar(
              backgroundColor: Color(0xFFC4EEB5),
              child: Icon(
                Icons.eco,
                size: 18,
              ),
            ),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ethically Sourced',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                '100% Carbon Neutral Delivery',
                style: TextStyle(color: Colors.black45, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Text Content Widget
class OnboardingTextContent extends StatelessWidget {
  const OnboardingTextContent({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
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
          text: const TextSpan(
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              height: 1.1,
              fontFamily: 'Serif',
            ),
            children: [
              TextSpan(
                text: 'Freshness\n',
                style: TextStyle(color: Color(0xFF1A1A1A)),
              ),
              TextSpan(
                text: 'Delivered.',
                style: TextStyle(color: Color(0xFF1E3616)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Sourcing the finest seasonal produce directly from boutique organic farms to your kitchen.',
          style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
        ),
      ],
    );
  }
}
