import 'package:flutter/material.dart';
import 'package:fresh_leaf/shared/widgets/app_avatar.dart';

class SupportChatUserAvatarWidget extends StatelessWidget {
  const SupportChatUserAvatarWidget({
    required this.scheme,
    this.imageUrl,
    this.name,
    this.fallbackIcon,
    this.radius = 14,
    super.key,
  });

  final String? imageUrl;
  final String? name;
  final IconData? fallbackIcon;
  final double radius;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return AppAvatar(
      imageUrl: imageUrl,
      name: name,
      fallbackIcon: fallbackIcon,
      radius: radius,
    );
  }
}
