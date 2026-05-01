import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_help_center_controller.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
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
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload != null) {
          final data = jsonDecode(payload) as Map<String, dynamic>;
          _handleNotificationClick(data);
        }
      },
    );

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
    }
  }

  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
      return;
    }

    if (Platform.isIOS || Platform.isMacOS) {
      await _fcm.requestPermission();
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
  }

  void _listenToMessages() {
    // Foreground messages
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      final type = message.data['type'] as String?;

      if (type == 'support_chat') {
        // Only show notification if NOT currently on the support chat screen
        if (Get.currentRoute != AppRoutes.supportChat) {
          unawaited(_showLocalNotification(message));
        }

        // Always try to refresh unread count if help center is open
        if (Get.isRegistered<ProfileHelpCenterController>()) {
          Get.find<ProfileHelpCenterController>().refreshUnreadCount();
        }
        return;
      }

      if (message.notification != null) {
        unawaited(_showLocalNotification(message));
      }
    });

    // Background messages (when app is opened from background)
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('A new onMessageOpenedApp event was published!');
      _handleNotificationClick(message.data);
    });
  }

  Future<void> _handleInitialMessage() async {
    // When app is opened from terminated state
    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationClick(initialMessage.data);
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;

    if (notification != null) {
      await _localNotifications.show(
        id: notification.hashCode,
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
    }
  }

  void _listenToTokenRefresh() {
    _tokenRefreshSubscription ??= _fcm.onTokenRefresh.listen((token) {
      unawaited(_uploadTokenValue(token));
    });
  }

  void _handleNotificationClick(Map<String, dynamic> data) {
    final route = data['route'] as String?;
    final type = data['type'] as String?;

    if (type == 'support_chat') {
      Get.toNamed<void>(AppRoutes.supportChat);
      return;
    }

    if (route != null && route.isNotEmpty) {
      Get.toNamed<void>(route);
    } else {
      // Default to notifications list if no route provided
      Get.toNamed<void>(AppRoutes.notifications);
    }
  }

  /// Get the current FCM token.
  Future<String?> getToken() async {
    try {
      final token = await _fcm.getToken();
      if (token != null) {
        final tok = token.length > 15 ? '${token.substring(0, 15)}...' : token;
        debugPrint('[NotificationService] FCM Token: $tok');
      } else {
        debugPrint('[NotificationService] FCM Token is null');
      }
      return token;
    } on Exception catch (e) {
      debugPrint('[NotificationService] Error getting FCM token: $e');
      return null;
    }
  }

  /// Send the FCM token to the backend.
  Future<void> uploadToken() async {
    final token = await getToken();
    if (token != null) {
      debugPrint('[NotificationService] Uploading FCM token...');
      await _uploadTokenValue(token);
    } else {
      debugPrint('[NotificationService] No token to upload');
    }
  }

  Future<void> _uploadTokenValue(String token) async {
    final tok = token.length > 15 ? '${token.substring(0, 15)}...' : token;
    debugPrint('[NotificationService] Upload token: $tok');
    try {
      final response = await apiClient.postRequest(
        ApiEndpoints.userDevices,
        data: {
          'device_token': token,
          'device_type': Platform.isAndroid ? 'android' : 'ios',
        },
      );
      debugPrint('[NotificationService] FCM Token uploaded: $response');
    } on Exception catch (e) {
      debugPrint('[NotificationService] Error uploading FCM token: $e');
    }
  }

  /// Delete the device token from the backend.
  Future<void> deleteToken() async {
    final token = await getToken();
    if (token != null) {
      try {
        await apiClient.deleteRequest(
          ApiEndpoints.userDeviceByToken.replaceFirst('{token}', token),
        );
        debugPrint('FCM Token deleted successfully');
      } on Exception catch (e) {
        debugPrint('Error deleting FCM token: $e');
      }
    }
  }

  @override
  void onClose() {
    unawaited(_tokenRefreshSubscription?.cancel());
    super.onClose();
  }
}
