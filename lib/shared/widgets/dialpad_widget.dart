import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';

class DialpadWidget extends StatelessWidget {
  const DialpadWidget({
    required this.onKeyPressed,
    required this.onDeletePressed,
    this.primaryColor,
    super.key,
  });

  final void Function(String key) onKeyPressed;
  final VoidCallback onDeletePressed;
  final Color? primaryColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final buttonColor = primaryColor ?? scheme.primary;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.scaled),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRow(['1', '2', '3'], buttonColor, scheme),
          SizedBox(height: 16.scaled),
          _buildRow(['4', '5', '6'], buttonColor, scheme),
          SizedBox(height: 16.scaled),
          _buildRow(['7', '8', '9'], buttonColor, scheme),
          SizedBox(height: 16.scaled),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildEmptySpace(),
              _buildDialpadButton('0', buttonColor, scheme),
              _buildDeleteButton(buttonColor, scheme),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> keys, Color buttonColor, ColorScheme scheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys
          .map((k) => _buildDialpadButton(k, buttonColor, scheme))
          .toList(),
    );
  }

  Widget _buildDialpadButton(
    String key,
    Color buttonColor,
    ColorScheme scheme,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          unawaited(HapticFeedback.lightImpact());
          onKeyPressed(key);
        },
        borderRadius: BorderRadius.circular(40.scaled),
        splashColor: buttonColor.withValues(alpha: 0.1),
        highlightColor: buttonColor.withValues(alpha: 0.05),
        child: Container(
          width: 72.scaled,
          height: 72.scaled,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
          ),
          alignment: Alignment.center,
          child: Text(
            key,
            style: TextStyle(
              fontSize: 28.scaled,
              fontWeight: FontWeight.w600,
              color: scheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton(Color buttonColor, ColorScheme scheme) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          unawaited(HapticFeedback.lightImpact());
          onDeletePressed();
        },
        borderRadius: BorderRadius.circular(40.scaled),
        splashColor: scheme.error.withValues(alpha: 0.1),
        highlightColor: scheme.error.withValues(alpha: 0.05),
        child: Container(
          width: 72.scaled,
          height: 72.scaled,
          alignment: Alignment.center,
          child: Icon(
            Icons.backspace_rounded,
            size: 26.scaled,
            color: scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptySpace() {
    return SizedBox(
      width: 72.scaled,
      height: 72.scaled,
    );
  }
}
