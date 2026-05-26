import 'dart:async';
import 'package:fresh_leaf/core/models/app_notification.dart';
import 'package:fresh_leaf/core/services/notification_service.dart';
import 'package:get/get.dart';

class NotificationsController extends GetxController {
  final NotificationService _notificationService =
      Get.find<NotificationService>();

  final RxList<AppNotification> notifications = <AppNotification>[].obs;
  final RxString _activeFilter = 'all'.obs;
  final RxBool isRefreshing = false.obs;
  final RxBool isLoading = false.obs;

  String get activeFilter => _activeFilter.value;
  set activeFilter(String value) => _activeFilter.value = value;

  @override
  void onInit() {
    super.onInit();
    unawaited(loadNotifications());
  }

  Future<void> loadNotifications() async {
    isLoading.value = true;
    try {
      final data = await _notificationService.getNotifications();
      notifications.assignAll(data);
    } finally {
      isLoading.value = false;
    }
  }

  List<AppNotification> get filtered {
    if (_activeFilter.value == 'all') return notifications;

    // Map UI filter to backend codes
    String? typeCode;
    if (_activeFilter.value == 'order') typeCode = 'ORDER_UPDATE';
    if (_activeFilter.value == 'promo') typeCode = 'PROMOTION';
    if (_activeFilter.value == 'system') typeCode = 'SYSTEM';

    return notifications
        .where((n) => n.typeCode == typeCode)
        .toList(growable: false);
  }

  Future<void> refreshList() async {
    if (isRefreshing.value) return;
    isRefreshing.value = true;
    try {
      final data = await _notificationService.getNotifications();
      notifications.assignAll(data);
    } finally {
      isRefreshing.value = false;
    }
  }

  Future<void> markAllRead() async {
    final success = await _notificationService.markAllAsRead();
    if (success) {
      // Optimistically update UI
      final updatedList = notifications.map((n) {
        if (!n.isRead) {
          return AppNotification(
            id: n.id,
            title: n.title,
            message: n.message,
            isRead: true,
            readAt: DateTime.now(),
            createdAt: n.createdAt,
            typeCode: n.typeCode,
            typeNameEn: n.typeNameEn,
            typeNameKm: n.typeNameKm,
            data: n.data,
          );
        }
        return n;
      }).toList();
      notifications.assignAll(updatedList);
    }
  }
}
