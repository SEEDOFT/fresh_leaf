import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/support_chat/controllers/support_chat_controller.dart';
import 'package:fresh_leaf/core/config/app_config.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
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
        appBar: const CustomAppBar(title: 'Customer Support'),
        body: ColoredBox(
          color: isDark ? scheme.surface : const Color(0xFFE5DDD5),
          child: Column(
            children: [
              Expanded(
                child: Obx(() {
                  // Access reactive variables early
                  // to avoid "Improper use of GetX"
                  final isLoading = controller.isLoading.value;
                  final messages = controller.messages;
                  final isAdminTyping = controller.isAdminTyping.value;

                  if (isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (messages.isEmpty && !isAdminTyping) {
                    return Center(
                      child: Text(
                        'Start a conversation with our team',
                        style: TextStyle(
                          color: isDark ? Colors.white54 : Colors.black54,
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
                    // We use builder instead of separated
                    // to avoid issues with extra elements
                    itemCount: messages.length + (isAdminTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == messages.length) {
                        return _buildTypingIndicator(isDark);
                      }

                      final msg = messages[index];
                      final isMe = msg.isUser;

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
                                const CircleAvatar(
                                  radius: 14,
                                  // backgroundColor: AppColors.primary,
                                  child: Icon(
                                    Icons.headset_mic,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.72,
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
                                    if (msg.filePath != null)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 6,
                                        ),
                                        child: _buildAttachmentPreview(
                                          msg.filePath!,
                                          isDark,
                                        ),
                                      ),
                                    if (msg.message.isNotEmpty)
                                      Text(
                                        msg.message,
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
                                _buildUserAvatar(scheme),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
              _buildComposer(isDark, scheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserAvatar(ColorScheme scheme) {
    final userProfile = Get.find<StorageService>().userProfile;
    final imageUrl = userProfile?.image ?? '';

    return CircleAvatar(
      radius: 14,
      backgroundColor: scheme.primaryContainer,
      backgroundImage: imageUrl.isNotEmpty
          ? NetworkImage(
              '${AppConfig.apiUrl.replaceAll('/api/v1', '')}/storage/$imageUrl',
            )
          : null,
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

  Widget _buildAttachmentPreview(String filePath, bool isDark) {
    final isImage =
        filePath.endsWith('.jpg') ||
        filePath.endsWith('.jpeg') ||
        filePath.endsWith('.png');

    if (isImage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          '${AppConfig.apiUrl.replaceAll('/api/v1', '')}/storage/$filePath',
          fit: BoxFit.cover,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.insert_drive_file,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              filePath.split('/').last,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 36, top: 4, bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Admin is typing',
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
              color: AppColors.primary.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComposer(bool isDark, ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      color: scheme.surface,
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
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: controller.pickFile,
                      icon: const Icon(Icons.attach_file),
                      color: isDark ? Colors.white70 : Colors.grey[600],
                    ),
                    Expanded(
                      child: TextField(
                        controller: controller.messageController,
                        onChanged: (_) => controller.notifyTyping(),
                        minLines: 1,
                        maxLines: 5,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Message',
                          hintStyle: TextStyle(
                            color: isDark ? Colors.white38 : Colors.grey[500],
                          ),
                          border: InputBorder.none,
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
            Container(
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Obx(() {
                final isSending = controller.isSending.value;
                if (isSending) {
                  return const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                }
                return IconButton(
                  onPressed: controller.sendMessage,
                  icon: const Icon(Icons.send),
                  color: Colors.white,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
