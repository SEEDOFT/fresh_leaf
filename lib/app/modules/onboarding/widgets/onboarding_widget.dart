import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fresh_leaf/core/constants/svg_assets.dart';

class OnboardingWidget {
  // Logo
  static Widget buildLogo() {
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

  // Info Card
  static Widget buildInfoCard() {
    return Container(
      height: 98,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Leaf Logo
          SizedBox(
            height: 48,
            width: 48,
            child: CircleAvatar(
              backgroundColor: const Color(0xFFC4EEB5),
              child: SvgPicture.asset(
                SvgAssets.leaf,
                height: 18,
                width: 18,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF1E3616),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Column(
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

  // Text Content
  static Widget buildTextContent(int index) {
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
