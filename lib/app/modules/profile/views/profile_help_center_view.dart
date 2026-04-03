import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_help_center_controller.dart';
import 'package:fresh_leaf/app/modules/profile/widgets/profile_widget.dart';
import 'package:get/get.dart';

class ProfileHelpCenterView extends GetView<ProfileHelpCenterController> {
  const ProfileHelpCenterView({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: ProfileAppBar(title: 'help_center'.tr),
      body: SafeArea(
        child: Obx(() {
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
            physics: const BouncingScrollPhysics(),
            children: [
              _SupportShortcuts(),
              const SizedBox(height: 16),
              Text(
                'FAQs',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              ...controller.articles
                  .map(
                    (article) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ProfileHelpArticleCard(article: article),
                    ),
                  )
                  .toList(),
            ],
          );
        }),
      ),
    );
  }
}

class _SupportShortcuts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final media = MediaQuery.of(context);

    return Row(
      children: [
        Expanded(
          child: _SupportButton(
            icon: Icons.headset_mic_outlined,
            label: 'Chat with support',
            color: scheme.primary,
            onTap: () => Get.snackbar(
              'Support',
              'Live chat coming soon.',
            ),
            width: media.size.width,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SupportButton(
            icon: Icons.smart_toy_outlined,
            label: 'Virtual AI assistant',
            color: scheme.secondary,
            onTap: () => Get.toNamed<void>('/ai_assistant'),
            width: media.size.width,
          ),
        ),
      ],
    );
  }
}

class _SupportButton extends StatelessWidget {
  const _SupportButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    required this.width,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 64,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withValues(alpha: 0.12),
          foregroundColor: color,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
