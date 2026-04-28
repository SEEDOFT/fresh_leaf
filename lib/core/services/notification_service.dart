import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

  /// Initialize the notification service.
  Future<NotificationService> init() async {
    await _initializeLocalNotifications();
    await _requestPermissions();
    _listenToMessages();
    await _handleInitialMessage();
    return this;
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
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
  }

  Future<void> _requestPermissions() async {
    if (Platform.isIOS) {
      await _fcm.requestPermission();
    }
  }

  void _listenToMessages() {
    // Foreground messages
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      if (message.notification != null) {
        debugPrint(
          'Message also contained a notification: '
          '${message.notification?.title}',
        );
        _showLocalNotification(message);
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
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
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

  void _handleNotificationClick(Map<String, dynamic> data) {
    final route = data['route'] as String?;
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
      return await _fcm.getToken();
    } on Exception catch (e) {
      debugPrint('Error getting FCM token: $e');
      return null;
    }
  }

  /// Send the FCM token to the backend.
  Future<void> uploadToken() async {
    final token = await getToken();
    if (token != null) {
      try {
        await apiClient.postRequest(
          ApiEndpoints.userDevices,
          data: {
            'device_token': token,
            'device_type': Platform.isAndroid ? 'android' : 'ios',
          },
        );
        debugPrint('FCM Token uploaded successfully');
      } on Exception catch (e) {
        debugPrint('Error uploading FCM token: $e');
      }
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
}
