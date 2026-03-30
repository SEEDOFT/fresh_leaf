import 'package:flutter/material.dart';

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
