import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/notifications/controllers/notifications_controller.dart';
import 'package:fresh_leaf/app/modules/notifications/widgets/notifications_widget.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/shared/widgets/app_filter_bar.dart';
import 'package:fresh_leaf/shared/widgets/app_scaffold.dart';
import 'package:fresh_leaf/shared/widgets/custom_app_bar.dart';
import 'package:fresh_leaf/shared/widgets/paginated_list_view.dart';
import 'package:get/get.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final filterOptions = [
      {'label': 'filter_all', 'value': 'all', 'icon': Icons.inbox_outlined},
      {
        'label': 'orders',
        'value': 'order',
        'icon': Icons.local_shipping_outlined,
      },
      {
        'label': 'filter_promos',
        'value': 'promo',
        'icon': Icons.local_offer_outlined,
      },
      {
        'label': 'filter_system',
        'value': 'system',
        'icon': Icons.settings_suggest_outlined,
      },
    ];

    return AppScaffold(
      scrollable: false,
      appBar: CustomAppBar(
        title: 'notification_title'.tr,
        actions: [
          TextButton(
            onPressed: controller.markAllRead,
            child: Text(
              'mark_all_read'.tr,
              style: TextStyle(
                color: scheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      padding: EdgeInsets.zero,
      body: Column(
        children: [
          const SizedBox(height: 14),
          Obx(
            () => AppFilterBar(
              filters: filterOptions.map((e) => e['value']! as String).toList(),
              selectedFilter: controller.activeFilter,
              onChanged: (value) => controller.activeFilter = value,
              labelBuilder: (value) =>
                  (filterOptions.firstWhere(
                            (e) => e['value'] == value,
                          )['label']!
                          as String)
                      .tr,
              iconBuilder: (value) =>
                  filterOptions.firstWhere((e) => e['value'] == value)['icon']!
                      as IconData,
              badgeTextBuilder: (value) {
                final count = controller.unreadCounts[value];
                if (count == null || count == 0) return null;
                return count > 99 ? '99+' : count.toString();
              },
            ),
          ),
          Expanded(
            child: Obx(
              () {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.refreshList,
                  child: controller.filtered.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: NotificationsEmptyState(scheme: scheme),
                            ),
                          ],
                        )
                      : PaginatedListView(
                          items: controller.filtered,
                          onLoadMore: controller.loadMore,
                          isLoadingMore: controller.isLoadingMore,
                          hasMore: controller.hasMore,
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index, item) {
                            return NotificationCard(
                              item: item,
                              scheme: scheme,
                              onTap: () async {
                                final result = await Get.toNamed<dynamic>(
                                  AppRoutes.notificationDetail,
                                  arguments: item,
                                );
                                if (result == true) {
                                  controller.markItemAsReadLocally(item.id);
                                }
                              },
                            );
                          },
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
