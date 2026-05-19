import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/support_chat/controllers/support_chat_controller.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class SupportChatComposerWidget extends StatelessWidget {
  const SupportChatComposerWidget({
    required this.scheme,
    required this.controller,
    required this.isDark,
    super.key,
  });

  final ColorScheme scheme;
  final SupportChatController controller;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -2),
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? scheme.surfaceContainerHighest
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(width: 4),
                    IconButton(
                      onPressed: controller.pickFile,
                      icon: const Icon(Icons.add_circle_outline_rounded),
                      color: scheme.primary,
                    ),
                    Expanded(
                      child: TextField(
                        controller: controller.messageController,
                        onChanged: (_) => controller.notifyTyping(),
                        minLines: 1,
                        maxLines: 5,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(
                            color: isDark ? Colors.white38 : Colors.grey[500],
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          filled: true,
                          fillColor: Colors.transparent,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Send Button
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: scheme.primary,
                shape: BoxShape.circle,
              ),
              child: Obx(() {
                final isSending = controller.isSending.value;
                final isUploading = controller.isUploading.value;
                final uploadProgress = controller.uploadProgress.value;

                if (isSending || isUploading) {
                  return Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: isUploading ? uploadProgress : null,
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                          if (isUploading)
                            Text(
                              '${(uploadProgress * 100).toInt()}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }
                return IconButton(
                  onPressed: controller.sendMessage,
                  icon: const Icon(Icons.send_rounded),
                  color: Colors.white,
                  iconSize: 22,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
