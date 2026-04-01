import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({required this.title, super.key});

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          size: 20,
          color: scheme.onSurface,
        ),
        onPressed: Get.back<void>,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: scheme.onSurface,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
