import 'package:flutter/material.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
import 'package:fresh_leaf/shared/widgets/app_card.dart';

class ProfileSectionCard extends StatelessWidget {
  const ProfileSectionCard({
    required this.title,
    required this.children,
    super.key,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppCard(
      margin: EdgeInsets.only(bottom: 16.scaled),
      showBorder: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16.scaled,
              color: scheme.onSurface,
            ),
          ),
          SizedBox(height: 12.scaled),
          ...children,
        ],
      ),
    );
  }
}
