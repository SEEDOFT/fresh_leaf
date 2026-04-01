import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BuildNavIcon extends StatelessWidget {
  const BuildNavIcon({
    required this.svgAsset,
    required this.isSelected,
    super.key,
    this.selectedColor = const Color(0xFF1A3314),
    this.unselectedColor = const Color(0xFF6B7260),
  });

  final String svgAsset;
  final bool isSelected;
  final Color selectedColor;
  final Color unselectedColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SvgPicture.asset(
        svgAsset,
        colorFilter: ColorFilter.mode(
          isSelected ? selectedColor : unselectedColor,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
