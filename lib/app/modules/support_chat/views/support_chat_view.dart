import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/support_chat/controllers/support_chat_controller.dart';
import 'package:fresh_leaf/app/modules/support_chat/widgets/support_chat_widgets.dart';
import 'package:fresh_leaf/core/models/chat_message.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import 'package:fresh_leaf/shared/widgets/app_scaffold.dart';
import 'package:fresh_leaf/shared/widgets/custom_app_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SupportChatView extends GetView<SupportChatController> {
  const SupportChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: AppScaffold(
        scrollable: false,
        padding: EdgeInsets.zero,
        appBar: CustomAppBar(
          title: controller.activeConversation.value?.type == 'support'
              ? 'customer_support'.tr
              : 'chat_with_vendor'.tr,
        ),
        body: ColoredBox(
          color: isDark ? scheme.surface : const Color(0xFFE5DDD5),
          child: Column(
            children: [
              Expanded(
                child: Obx(
                  () {
                    final isLoading = controller.isLoading.value;
                    final messages = controller.messages;

                    if (isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (messages.isEmpty && !controller.isOtherTyping.value) {
                      return Center(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.chat_bubble_outline,
                                  size: 64,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'welcome_to_support'.tr,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'support_chat_empty_subtitle'.tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  height: 1.5,
                                  color: isDark
                                      ? Colors.white54
                                      : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: controller.scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      itemCount:
                          messages.length +
                          (controller.isOtherTyping.value ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == messages.length) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: SupportChatTypingIndicatorWidget(
                              scheme: scheme,
                              isDark: isDark,
                            ),
                          );
                        }

                        final msg = messages[index];
                        final isMe = msg.senderId == controller.userProfile?.id;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Align(
                            alignment: isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (!isMe) ...[
                                  SupportChatUserAvatarWidget(
                                    scheme: scheme,
                                    imageUrl: controller
                                        .activeConversation
                                        .value
                                        ?.otherParticipant
                                        ?.displayImage,
                                    name: controller
                                        .activeConversation
                                        .value
                                        ?.otherParticipant
                                        ?.fullName,
                                    fallbackIcon:
                                        controller
                                                .activeConversation
                                                .value
                                                ?.type ==
                                            'support'
                                        ? Icons.headset_mic
                                        : Icons.person_outline,
                                  ),
                                  const SizedBox(width: 8),
                                ],
                                Container(
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                        0.72,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isMe
                                        ? (isDark
                                              ? const Color(0xFF1E3616)
                                              : const Color(0xFFE1FFC7))
                                        : (isDark
                                              ? Colors.grey[800]
                                              : Colors.white),
                                    borderRadius: BorderRadius.circular(16)
                                        .copyWith(
                                          bottomRight: isMe
                                              ? const Radius.circular(4)
                                              : const Radius.circular(16),
                                          bottomLeft: !isMe
                                              ? const Radius.circular(4)
                                              : const Radius.circular(16),
                                        ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 1,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: isMe
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _buildAttachment(msg, isDark),
                                      if (msg.content.isNotEmpty)
                                        Text(
                                          msg.content,
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.white
                                                : Colors.black87,
                                            fontSize: 15,
                                          ),
                                        ),
                                      const SizedBox(height: 2),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            msg.createdAt != null
                                                ? DateFormat('HH:mm').format(
                                                    msg.createdAt!.toLocal(),
                                                  )
                                                : '',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: isDark
                                                  ? Colors.white54
                                                  : Colors.black45,
                                            ),
                                          ),
                                          if (isMe) ...[
                                            const SizedBox(width: 4),
                                            Icon(
                                              Icons.done_all,
                                              size: 14,
                                              color: isDark
                                                  ? Colors.blue[300]
                                                  : Colors.blue,
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                if (isMe) ...[
                                  const SizedBox(width: 8),
                                  SupportChatUserAvatarWidget(
                                    scheme: scheme,
                                    imageUrl: controller.userProfile?.image,
                                    name:
                                        '${controller.userProfile?.firstName}'
                                        ' ${controller.userProfile?.lastName}',
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              SupportChatComposerWidget(
                scheme: scheme,
                isDark: isDark,
                controller: controller,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttachment(ChatMessage msg, bool isDark) {
    final url = msg.fileUrl;
    if (url == null || url.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: SupportChatAttachmentPreviewWidget(
        fileUrl: url,
        fileName: msg.filePath?.split('/').last ?? 'file',
        isDark: isDark,
      ),
    );
  }
}
