import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TitleRowWidget extends StatelessWidget {
  const TitleRowWidget({
    required this.title, required this.origin, required this.total, super.key,
  });

  final String title;
  final String origin;
  final double total;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.tr,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: scheme.onSurface,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                origin.tr,
                style: TextStyle(
                  fontSize: 13,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Text(
          '\$${total.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: scheme.onSurface,
          ),
        ),
      ],
    );
  }
}
