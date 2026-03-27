import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BuildNavIcon extends StatelessWidget {
  const BuildNavIcon({
    super.key,
    required this.svgAsset,
    required this.isSelected,
  });

  final String svgAsset;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SvgPicture.asset(
        svgAsset,
        colorFilter: ColorFilter.mode(
          isSelected
              ? const Color(0xFF1A3C14) // selected color
              : const Color(
                  0xFF1D1B19,
                ).withValues(alpha: 0.7), // unselected + opacity
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
