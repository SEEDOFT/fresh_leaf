import 'package:flutter/material.dart';
import 'package:fresh_leaf/shared/widgets/app_card.dart';

class SettingsCard extends StatelessWidget {
  const SettingsCard({
    required this.children,
    super.key,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      borderRadius: 16,
      showShadow: true,
      showBorder: false,
      child: Column(children: children),
    );
  }
}
