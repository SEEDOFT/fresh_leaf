import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// Bottom navigation icon with an optional badge count overlay.
class BuildNavIcon extends StatelessWidget {
  const BuildNavIcon({
    required this.svgAsset,
    required this.isSelected,
    super.key,
    this.selectedColor = const Color(0xFF1A3314),
    this.unselectedColor = const Color(0xFF6B7260),
    this.badgeCount = 0,
  });

  final String svgAsset;
  final bool isSelected;
  final Color selectedColor;
  final Color unselectedColor;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    final icon = Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SvgPicture.asset(
        svgAsset,
        colorFilter: ColorFilter.mode(
          isSelected ? selectedColor : unselectedColor,
          BlendMode.srcIn,
        ),
      ),
    );

    if (badgeCount <= 0) return icon;

    return Badge(
      label: Text(
        badgeCount > 99 ? '99+' : badgeCount.toString(),
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
      ),
      child: icon,
    );
  }
}
