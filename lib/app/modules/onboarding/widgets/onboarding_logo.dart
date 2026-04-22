import 'package:flutter/material.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';

class OnboardingLogo extends StatelessWidget {
  const OnboardingLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 8.scaled, height: 32.scaled, color: Colors.white),
        SizedBox(width: 8.scaled),
        Text(
          'FreshLeaf',
          style: TextStyle(
            fontSize: 40.scaled,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
