import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/support_tickets/controllers/support_tickets_controller.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/models/chat_conversation.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';
import 'package:fresh_leaf/shared/widgets/app_avatar.dart';
import 'package:fresh_leaf/shared/widgets/app_scaffold.dart';
import 'package:fresh_leaf/shared/widgets/custom_app_bar.dart';
import 'package:fresh_leaf/shared/widgets/paginated_list_view.dart';
import 'package:get/get.dart';

class SupportTicketsView extends GetView<SupportTicketsController> {
  const SupportTicketsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      scrollable: false,
      padding: EdgeInsets.zero,
      appBar: CustomAppBar(title: 'messages'.tr),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.createNewTicket,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.support_agent, color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            _MessagesFilterBar(controller: controller),
            Expanded(
              child: controller.items.isEmpty
                  ? _MessagesEmptyState(isDark: isDark)
                  : RefreshIndicator(
                      onRefresh: controller.refreshList,
                      child: PaginatedListView(
                        items: controller.items,
                        onLoadMore: controller.loadMore,
                        isLoadingMore: controller.isLoadingMore,
                        hasMore: controller.hasMore,
                        padding: const EdgeInsets.all(16),
                        itemBuilder: (context, index, conversation) {
                          return _MessageConversationCard(
                            conversation: conversation,
                            isDark: isDark,
                            onTap: () async {
                              await Get.toNamed<void>(
                                AppRoutes.supportChat,
                                arguments: {'conversation': conversation},
                              );
                              await controller.refreshList();
                            },
                          );
                        },
                      ),
                    ),
            ),
          ],
        );
      }),
    );
  }
}

class _MessagesFilterBar extends StatelessWidget {
  const _MessagesFilterBar({required this.controller});

  final SupportTicketsController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final filter = MessagesFilter.values[index];
          final isSelected = controller.selectedFilter.value == filter;

          return ChoiceChip(
            label: Text(filter.labelKey.tr),
            selected: isSelected,
            onSelected: (_) {
              unawaited(controller.setFilter(filter));
            },
            selectedColor: AppColors.primary,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : null,
              fontWeight: FontWeight.w600,
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemCount: MessagesFilter.values.length,
      ),
    );
  }
}

class _MessagesEmptyState extends StatelessWidget {
  const _MessagesEmptyState({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.chat_bubble_outline,
                  size: 80,
                  color: AppColors.primary.withValues(alpha: 0.6),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'no_messages_yet'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'messages_empty_subtitle'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
                color: isDark ? Colors.white54 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageConversationCard extends StatelessWidget {
  const _MessageConversationCard({
    required this.conversation,
    required this.isDark,
    required this.onTap,
  });

  final ChatConversation conversation;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isOpen = conversation.status == 'open';
    final isSupport = conversation.type == 'support';
    final imageUrl = conversation.otherParticipant?.displayImage;

    return Card(
      elevation: 0,
      color: isDark ? Colors.white10 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? Colors.white12 : Colors.black12,
        ),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        onTap: onTap,
        leading: AppAvatar(
          radius: 18,
          imageUrl: imageUrl,
          name: isSupport ? null : conversation.displayTitle,
          fallbackIcon: isSupport
              ? Icons.support_agent
              : Icons.storefront_outlined,
          backgroundColor: isOpen
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.grey.withValues(alpha: 0.1),
          foregroundColor: isOpen ? AppColors.primary : Colors.grey,
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                isSupport ? 'customer_support'.tr : conversation.displayTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            if (conversation.otherParticipant?.isVerified == true) ...[
              const SizedBox(width: 4),
              const Icon(
                Icons.verified,
                color: AppColors.primary,
                size: 16,
              ),
            ],
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _conversationPreview(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _MessageBadge(
                    label: isSupport
                        ? 'customer_support'.tr
                        : 'messages_vendor_chat'.tr,
                    color: isSupport ? Colors.orange : AppColors.primary,
                  ),
                  if (isSupport)
                    _MessageBadge(
                      label: isOpen
                          ? 'ticket_status_open'.tr
                          : 'ticket_status_resolved'.tr,
                      color: isOpen ? Colors.orange : Colors.green,
                    ),
                  Text(
                    conversation.updatedAt != null
                        ? formatDateTime(conversation.updatedAt)
                        : 'unknown_date'.tr,
                    style: TextStyle(
                      color: isDark ? Colors.white54 : Colors.black45,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        trailing: conversation.unreadCount > 0
            ? _UnreadBadge(count: conversation.unreadCount)
            : null,
      ),
    );
  }

  String _conversationPreview() {
    final preview = conversation.previewText;
    if (preview.isNotEmpty) return preview;
    return conversation.createdAt != null
        ? formatDateTime(conversation.createdAt)
        : 'unknown_date'.tr;
  }
}

class _MessageBadge extends StatelessWidget {
  const _MessageBadge({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _UnreadBadge extends StatelessWidget {
  const _UnreadBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: SizedBox(
        width: 26,
        height: 26,
        child: Center(
          child: Text(
            count > 99 ? '99+' : count.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
