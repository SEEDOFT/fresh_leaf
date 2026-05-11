import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/models/user_profile.dart';

class SupportChatBuildUserAvatarWidget extends StatelessWidget {
  const SupportChatBuildUserAvatarWidget({
    required this.userProfile,
    required this.imageUrl,
    required this.scheme,
    super.key,
  });

  final UserProfile? userProfile;
  final String imageUrl;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 14,
      backgroundColor: scheme.primaryContainer,
      backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
      child: imageUrl.isEmpty
          ? Text(
              (userProfile?.firstName.isNotEmpty ?? false)
                  ? userProfile!.firstName[0]
                  : 'M',
              style: TextStyle(
                fontSize: 10,
                color: scheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
    );
  }
}
