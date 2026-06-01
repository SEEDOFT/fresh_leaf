import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/support_tickets/controllers/support_tickets_controller.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';
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

        if (controller.items.isEmpty) {
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
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 80,
                            color: AppColors.primary.withValues(alpha: 0.6),
                          ),
                        ],
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

        return RefreshIndicator(
          onRefresh: controller.refreshList,
          child: PaginatedListView(
            items: controller.items,
            onLoadMore: controller.loadMore,
            isLoadingMore: controller.isLoadingMore,
            hasMore: controller.hasMore,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index, conversation) {
              final isOpen = conversation.status == 'open';
              final isSupport = conversation.type == 'support';

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
                  onTap: () async {
                    await Get.toNamed<void>(
                      AppRoutes.supportChat,
                      arguments: {'conversation': conversation},
                    );
                    await controller.refreshList();
                  },
                  leading: CircleAvatar(
                    backgroundColor: isOpen
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.1),
                    child: Icon(
                      isSupport
                          ? Icons.support_agent
                          : Icons.chat_bubble_outline,
                      color: isOpen ? AppColors.primary : Colors.grey,
                    ),
                  ),
                  title: Text(
                    isSupport ? 'customer_support'.tr : 'chat_with_vendor'.tr,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    conversation.createdAt != null
                        ? formatDateTime(conversation.createdAt)
                        : 'unknown_date'.tr,
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isOpen
                          ? Colors.orange.withValues(alpha: 0.1)
                          : Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      isOpen
                          ? 'ticket_status_open'.tr
                          : 'ticket_status_resolved'.tr,
                      style: TextStyle(
                        color: isOpen ? Colors.orange[700] : Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
