import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_help_center_controller.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/app_notification.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:get/get.dart';

/// Service to handle Firebase Push Notifications and Local Notifications.
class NotificationService extends GetxService {
  NotificationService({required this.apiClient});

  final ApiClient apiClient;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  StreamSubscription<String>? _tokenRefreshSubscription;

  static const String _highImportanceChannelId = 'high_importance_channel';
  static const String _highImportanceChannelName =
      'High Importance Notifications';
  static const String _highImportanceChannelDescription =
      'This channel is used for important notifications.';

  /// Initialize the notification service.
  Future<NotificationService> init() async {
    await _initializeLocalNotifications();
    await _requestPermissions();
    await _configureForegroundPresentation();
    _listenToMessages();
    _listenToTokenRefresh();
    await _handleInitialMessage();

    if (kDebugMode) {
      debugPrint('[NotificationService] Init complete');
    }

    return this;
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (response) async {
        final payload = response.payload;

        if (kDebugMode) {
          debugPrint(
            '[NotificationService] onDidReceiveNotificationResponse:'
            ' payload=$payload',
          );
        }

        if (payload != null) {
          final data = jsonDecode(payload) as Map<String, dynamic>;
          await _handleNotificationClick(data);
        }
      },
    );

    if (kDebugMode) {
      debugPrint(
        '[NotificationService] Local notifications initialized:'
        ' androidSettings=$androidSettings, iosSettings=$iosSettings',
      );
    }

    if (Platform.isAndroid) {
      const androidChannel = AndroidNotificationChannel(
        _highImportanceChannelId,
        _highImportanceChannelName,
        description: _highImportanceChannelDescription,
        importance: Importance.max,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(androidChannel);

      if (kDebugMode) {
        debugPrint(
          '[NotificationService] Android notification channel created',
        );
      }
    }
  }

  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      final granted = await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();

      if (kDebugMode) {
        debugPrint(
          '[NotificationService] Android permissions: granted=$granted',
        );
      }
      return;
    }

    if (Platform.isIOS || Platform.isMacOS) {
      final granted = await _fcm.requestPermission();

      if (kDebugMode) {
        debugPrint('[NotificationService] iOS permissions: granted=$granted');
      }
    }
  }

  Future<void> _configureForegroundPresentation() async {
    if (!Platform.isIOS && !Platform.isMacOS) {
      return;
    }

    await _fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    if (kDebugMode) {
      debugPrint('[NotificationService] Foreground presentation configured');
    }
  }

  void _listenToMessages() {
    // Foreground messages
    FirebaseMessaging.onMessage.listen((message) async {
      final type = message.data['type'] as String?;

      if (kDebugMode) {
        debugPrint(
          '[NotificationService] onMessage (foreground):'
          ' type=$type, data=${message.data}',
        );
      }

      if (type == 'support_chat') {
        if (kDebugMode) {
          debugPrint(
            '[NotificationService] Handling support_chat notification',
          );
        }
        // Only show notification if NOT currently on the support chat screen
        if (Get.currentRoute != AppRoutes.supportChat &&
            Get.currentRoute != AppRoutes.supportTickets) {
          unawaited(_showLocalNotification(message));
        }

        // Always try to refresh unread count if help center is open
        if (Get.isRegistered<ProfileHelpCenterController>()) {
          await Get.find<ProfileHelpCenterController>().refreshUnreadCount();
        }
        return;
      }

      if (message.notification != null) {
        if (kDebugMode) {
          debugPrint(
            '[NotificationService] Showing notification:'
            ' title=${message.notification?.title}',
          );
        }
        unawaited(_showLocalNotification(message));
      }
    });

    // Background messages (when app is opened from background)
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      if (kDebugMode) {
        debugPrint(
          '[NotificationService] onMessageOpenedApp (background):'
          ' data=${message.data}',
        );
      }
      await _handleNotificationClick(message.data);
    });

    if (kDebugMode) {
      debugPrint('[NotificationService] Listening to FCM messages');
    }
  }

  Future<void> _handleInitialMessage() async {
    // When app is opened from terminated state
    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      if (kDebugMode) {
        debugPrint(
          '[NotificationService] Initial message found:'
          ' data=${initialMessage.data}',
        );
      }
      await _handleNotificationClick(initialMessage.data);
    } else {
      if (kDebugMode) {
        debugPrint('[NotificationService] No initial message found');
      }
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;

    if (notification != null) {
      final id = notification.hashCode;

      if (kDebugMode) {
        debugPrint(
          '[NotificationService] Showing local notification:'
          ' id=$id, title=${notification.title}, body=${notification.body}',
        );
      }

      await _localNotifications.show(
        id: id,
        title: notification.title,
        body: notification.body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _highImportanceChannelId,
            _highImportanceChannelName,
            channelDescription: _highImportanceChannelDescription,
            importance: Importance.max,
            priority: Priority.high,
            icon: android?.smallIcon,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: jsonEncode(message.data),
      );

      if (kDebugMode) {
        debugPrint(
          '[NotificationService] Local '
          'notification shown with id: $id',
        );
      }
    } else {
      // Always log this as it might indicate an issue
      if (kDebugMode) {
        debugPrint('[NotificationService] Notification is null, not showing');
      }
    }
  }

  void _listenToTokenRefresh() {
    _tokenRefreshSubscription ??= _fcm.onTokenRefresh.listen((token) {
      if (kDebugMode) {
        debugPrint(
          '[NotificationService] Token refreshed: ${token.substring(0, 15)}...',
        );
      }
      unawaited(_uploadTokenValue(token));
    });

    if (kDebugMode) {
      debugPrint('[NotificationService] Listening to token refresh');
    }
  }

  Future<void> _handleNotificationClick(Map<String, dynamic> data) async {
    final route = data['route'] as String?;
    final type = data['type'] as String?;

    if (kDebugMode) {
      debugPrint(
        '[NotificationService] Handling notification click:'
        ' route=$route, type=$type, data=$data',
      );
    }

    if (type == 'support_chat') {
      if (kDebugMode) {
        debugPrint('[NotificationService] Navigating to support_tickets');
      }
      await Get.toNamed<void>(AppRoutes.supportTickets);
      return;
    }

    if (route != null && route.isNotEmpty) {
      if (kDebugMode) {
        debugPrint('[NotificationService] Navigating to: $route');
      }
      await Get.toNamed<void>(route);
    } else {
      // Default to notifications list if no route provided
      if (kDebugMode) {
        debugPrint('[NotificationService] Navigating to default notifications');
      }
      await Get.toNamed<void>(AppRoutes.notifications);
    }
  }

  /// Get the current FCM token.
  Future<String?> getToken() async {
    try {
      final token = await _fcm.getToken();
      if (token != null) {
        final tok = token.length > 15 ? '${token.substring(0, 15)}...' : token;
        if (kDebugMode) {
          debugPrint('[NotificationService] FCM Token received: $tok');
        }
      } else {
        if (kDebugMode) {
          debugPrint('[NotificationService] FCM Token is null');
        }
      }
      return token;
    } on Exception catch (e) {
      if (kDebugMode) {
        debugPrint('[NotificationService] Error getting FCM token: $e');
      }
      return null;
    }
  }

  /// Send the FCM token to the backend.
  Future<void> uploadToken() async {
    final token = await getToken();
    if (token != null) {
      if (kDebugMode) {
        debugPrint('[NotificationService] Uploading FCM token...');
      }
      await _uploadTokenValue(token);
    } else {
      if (kDebugMode) {
        debugPrint('[NotificationService] No token to upload');
      }
    }
  }

  Future<void> _uploadTokenValue(String token) async {
    final tok = token.length > 15 ? '${token.substring(0, 15)}...' : token;

    if (kDebugMode) {
      debugPrint('[NotificationService] Upload token: $tok');
    }

    try {
      final response = await apiClient.postRequest(
        ApiEndpoints.userDevices,
        data: {
          'device_token': token,
          'device_type': Platform.isAndroid ? 'android' : 'ios',
        },
      );

      if (kDebugMode) {
        debugPrint(
          '[NotificationService] FCM Token uploaded successfully: $response',
        );
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        debugPrint('[NotificationService] Error uploading FCM token: $e');
      }
    }
  }

  /// Delete the device token from the backend.
  Future<void> deleteToken() async {
    final token = await getToken();
    if (token != null) {
      try {
        await apiClient.deleteRequest(
          ApiEndpoints.userDevices,
          data: {'device_token': token},
        );
        if (kDebugMode) {
          debugPrint('FCM Token deleted successfully');
        }
      } on Exception catch (e) {
        if (kDebugMode) {
          debugPrint('Error deleting FCM token: $e');
        }
      }
    }
  }

  @override
  void onClose() {
    unawaited(_tokenRefreshSubscription?.cancel());
    if (kDebugMode) {
      debugPrint('[NotificationService] Service closed');
    }
    super.onClose();
  }

  final RxList<AppNotification> notifications = <AppNotification>[].obs;
  final RxInt unreadCount = 0.obs;

  /// Get database notifications for the user
  Future<List<AppNotification>> getNotifications() async {
    try {
      final response = await apiClient.getRequest(ApiEndpoints.notifications);
      final apiResponse = ApiResponse.parseList(response.data);

      if (apiResponse.isSuccess) {
        final list = apiResponse.data.map(AppNotification.fromMap).toList();
        notifications.assignAll(list);
        unreadCount.value = list.where((n) => !n.isRead).length;
        return list;
      }
      return [];
    } on Exception {
      return [];
    }
  }

  /// Mark a notification as read
  Future<bool> markAsRead(int notificationId) async {
    try {
      final response = await apiClient.postRequest(
        ApiEndpoints.notificationsMarkRead.replaceAll(
          '{id}',
          notificationId.toString(),
        ),
      );
      final apiResponse = ApiResponse.parseMap(response.data);
      if (apiResponse.isSuccess) {
        if (unreadCount.value > 0) {
          unreadCount.value--;
        }
        final idx = notifications.indexWhere((n) => n.id == notificationId);
        if (idx != -1) {
          final old = notifications[idx];
          notifications[idx] = AppNotification(
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
        return true;
      }
      return false;
    } on Exception {
      return false;
    }
  }

  /// Mark all notifications as read
  Future<bool> markAllAsRead() async {
    try {
      final response = await apiClient.postRequest(
        ApiEndpoints.notificationsMarkAllRead,
      );
      final apiResponse = ApiResponse.parseMap(response.data);
      if (apiResponse.isSuccess) {
        unreadCount.value = 0;
        notifications.assignAll(
          notifications.map((n) {
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
          }).toList(),
        );
        return true;
      }
      return false;
    } on Exception {
      return false;
    }
  }
}
