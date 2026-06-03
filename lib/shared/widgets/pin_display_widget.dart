import 'package:flutter/material.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
import 'package:fresh_leaf/shared/widgets/shake_widget.dart';

class PinDisplayWidget extends StatelessWidget {
  const PinDisplayWidget({
    required this.pinLength,
    this.maxLength = 6,
    this.hasError = false,
    super.key,
  });

  final int pinLength;
  final int maxLength;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ShakeWidget(
      shake: hasError,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(maxLength, (index) {
          final isFilled = index < pinLength;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: EdgeInsets.symmetric(horizontal: 8.scaled),
            width: 16.scaled,
            height: 16.scaled,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isFilled
                  ? (hasError ? scheme.error : scheme.primary)
                  : scheme.surfaceContainerHighest,
              border: Border.all(
                color: isFilled
                    ? (hasError ? scheme.error : scheme.primary)
                    : scheme.outline.withValues(alpha: 0.3),
                width: 1.5.scaled,
              ),
            ),
          );
        }),
      ),
    );
  }
}
