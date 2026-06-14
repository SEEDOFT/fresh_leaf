import 'package:flutter/material.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';

class WalletTopUpForTopUpSectionCardWidget extends StatelessWidget {
  const WalletTopUpForTopUpSectionCardWidget({
    required this.child,
    super.key,
    this.isProminent = false,
  });

  final Widget child;
  final bool isProminent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = isProminent ? 20.scaled : 16.scaled;
    final baseAlpha = isProminent ? 0.34 : 0.22;
    final padding = isProminent ? 18.scaled : 14.scaled;

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: baseAlpha),
        borderRadius: BorderRadius.circular(radius),
        border: isProminent
            ? null
            : Border.all(
                color: scheme.outline.withValues(alpha: 0.12),
              ),
        boxShadow: isProminent
            ? [
                BoxShadow(
                  color: scheme.primary.withValues(alpha: 0.08),
                  blurRadius: 18.scaled,
                  offset: Offset(0, 8.scaled),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}
