import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupportChatTypingIndicatorWidget extends StatelessWidget {
  const SupportChatTypingIndicatorWidget({
    required this.scheme,
    required this.isDark,
    super.key,
  });

  final ColorScheme scheme;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 36, top: 4, bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'support_chat_admin_typing'.tr,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white54 : Colors.black54,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(width: 4),
          SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: scheme.primary.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
