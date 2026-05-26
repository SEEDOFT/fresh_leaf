import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/notifications/controllers/notifications_controller.dart';
import 'package:fresh_leaf/app/modules/notifications/widgets/notifications_widget.dart';
import 'package:fresh_leaf/shared/widgets/app_filter_bar.dart';
import 'package:fresh_leaf/shared/widgets/app_scaffold.dart';
import 'package:fresh_leaf/shared/widgets/custom_app_bar.dart';
import 'package:get/get.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final filterOptions = [
      {'label': 'All', 'value': 'all', 'icon': Icons.inbox_outlined},
      {
        'label': 'Orders',
        'value': 'order',
        'icon': Icons.local_shipping_outlined,
      },
      {'label': 'Promos', 'value': 'promo', 'icon': Icons.local_offer_outlined},
      {
        'label': 'System',
        'value': 'system',
        'icon': Icons.settings_suggest_outlined,
      },
    ];

    return AppScaffold(
      scrollable: false,
      appBar: CustomAppBar(
        title: 'Notifications',
        actions: [
          TextButton(
            onPressed: controller.markAllRead,
            child: Text(
              'Mark all read',
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
          const SizedBox(height: 6),
          Obx(
            () => AppFilterBar(
              filters: filterOptions.map((e) => e['value']! as String).toList(),
              selectedFilter: controller.activeFilter,
              onChanged: (value) => controller.activeFilter = value,
              labelBuilder: (value) =>
                  filterOptions.firstWhere((e) => e['value'] == value)['label']!
                      as String,
              iconBuilder: (value) =>
                  filterOptions.firstWhere((e) => e['value'] == value)['icon']!
                      as IconData,
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
                      : ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                          itemCount: controller.filtered.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = controller.filtered[index];
                            return NotificationCard(
                              item: item,
                              scheme: scheme,
                              onTap: () async => await Get.toNamed<void>(
                                '/notification_detail',
                                arguments: item,
                              ),
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
