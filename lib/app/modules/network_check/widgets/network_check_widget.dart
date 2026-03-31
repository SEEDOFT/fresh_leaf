import 'package:flutter/material.dart';

class NetworkStatusIcon extends StatelessWidget {
  const NetworkStatusIcon({
    super.key,
    required this.isOnline,
    required this.isChecking,
  });

  final bool isOnline;
  final bool isChecking;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = isOnline ? scheme.primary : scheme.error;
    final icon = isOnline ? Icons.wifi_rounded : Icons.wifi_off_rounded;

    return Container(
      width: 84,
      height: 84,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(24),
      ),
      child: isChecking
          ? Center(
              child: CircularProgressIndicator(
                color: scheme.primary,
                strokeWidth: 2.6,
              ),
            )
          : Icon(icon, color: color, size: 42),
    );
  }
}
