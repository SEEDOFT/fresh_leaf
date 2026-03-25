import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DashboardWidget {
  DashboardWidget._();

  // Build Svg Icon for Bottom Navigation Bar
  static Widget buildIcon(String asset, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SvgPicture.asset(
        asset,
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
