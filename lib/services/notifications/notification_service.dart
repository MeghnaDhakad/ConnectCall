import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request user permission for notifications
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('User granted permission: ${settings.authorizationStatus}');

    // Handle foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      if (message.notification != null) {
        debugPrint('Message also contained a notification: ${message.notification}');
        _showNotification(message.notification!);
      }
    });

    // Handle background notifications
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('A new onMessageOpenedApp event was published!');
      _handleNotificationTap(message);
    });

    // Get device token for sending notifications
    String? token = await _firebaseMessaging.getToken();
    debugPrint('Device Token: $token');
  }

  void _showNotification(RemoteNotification notification) {
    debugPrint('Notification received: ${notification.title}');
    // Integration with local notification plugins can be done here
  }

  void _handleNotificationTap(RemoteMessage message) {
    // Handle navigation based on notification data
    debugPrint('User tapped notification: ${message.data}');
  }

  // Send notification for incoming call
  static Future<void> sendIncomingCallNotification({
    required String recipientId,
    required String callerName,
    required String callType, // 'audio' or 'video'
  }) async {
    // This would typically be done from your backend
    // For now, this is a placeholder for the implementation
    debugPrint('Incoming call notification for: $recipientId from $callerName ($callType)');
  }

  // Send notification for missed call
  static Future<void> sendMissedCallNotification({
    required String userId,
    required String callerName,
    required DateTime missedTime,
  }) async {
    debugPrint('Missed call notification for: $userId from $callerName');
  }
}
