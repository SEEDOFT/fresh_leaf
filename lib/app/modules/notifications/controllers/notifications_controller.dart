import 'dart:async';
import 'package:fresh_leaf/core/mixins/paginated_list_mixin.dart';
import 'package:fresh_leaf/core/models/app_notification.dart';
import 'package:fresh_leaf/core/models/paginated_response.dart';
import 'package:fresh_leaf/core/services/notification_service.dart';
import 'package:get/get.dart';

class NotificationsController extends GetxController
    with PaginatedListMixin<AppNotification> {
  NotificationsController({
    required NotificationService notificationService,
  }) : _notificationService = notificationService;

  final NotificationService _notificationService;

  final RxString _activeFilter = 'all'.obs;

  List<AppNotification> get notifications => items;

  String get activeFilter => _activeFilter.value;
  set activeFilter(String value) => _activeFilter.value = value;

  @override
  void onInit() {
    super.onInit();
    items.assignAll(_notificationService.notifications);
    unawaited(loadInitial());
  }

  @override
  Future<PaginatedResponse<AppNotification>> fetchPage(int page) async {
    return _notificationService.getNotifications(page: page);
  }

  List<AppNotification> get filtered {
    if (_activeFilter.value == 'all') return notifications;

    // Map UI filter to backend codes
    String? typeCode;
    if (_activeFilter.value == 'order') typeCode = 'ORDER_UPDATE';
    if (_activeFilter.value == 'promo') typeCode = 'PROMOTION';
    if (_activeFilter.value == 'system') typeCode = 'SYSTEM';

    return items.where((n) => n.typeCode == typeCode).toList(growable: false);
  }

  Future<void> markAllRead() async {
    final success = await _notificationService.markAllAsRead();
    if (success) {
      items.assignAll(_notificationService.notifications);
    }
  }

  void markItemAsReadLocally(int id) {
    final idx = items.indexWhere((n) => n.id == id);
    if (idx != -1) {
      final old = items[idx];
      items[idx] = AppNotification(
        id: old.id,
        title: old.title,
        message: old.message,
        isRead: true,
        readAt: DateTime.now(),
        createdAt: old.createdAt,
        typeCode: old.typeCode,
        typeNameEn: old.typeNameEn,
        typeNameKm: old.typeNameKm,
        data: old.data,
      );
    }
  }
}
