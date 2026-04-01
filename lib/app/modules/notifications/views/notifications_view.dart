import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/notifications/controllers/notifications_controller.dart';
import 'package:fresh_leaf/app/modules/notifications/widgets/notifications_widget.dart';
import 'package:get/get.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(
            color: scheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: scaffoldBg,
        elevation: 0,
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
      body: Column(
        children: [
          const SizedBox(height: 6),
          NotificationsFilterBar(controller: controller),
          Expanded(
            child: Obx(
              () => RefreshIndicator(
                onRefresh: controller.refreshList,
                child: controller.filtered.isEmpty
                    ? NotificationsEmptyState(scheme: scheme)
                    : ListView.separated(
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                        itemCount: controller.filtered.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
