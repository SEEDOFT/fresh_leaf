import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import 'package:fresh_leaf/shared/widgets/app_empty_state.dart';
import 'package:get/get.dart';

class AiAssistantEmptyState extends StatelessWidget {
  const AiAssistantEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.auto_awesome,
      iconColor: AppColors.accentBrown,
      title: 'ai_empty_title'.tr,
      subtitle: 'ai_empty_subtitle'.tr,
    );
  }
}
