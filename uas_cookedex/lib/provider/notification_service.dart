import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static Future<void> initialize() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'recipe_reviews',
          channelName: 'Recipe Reviews',
          channelDescription: 'Notifications for recipe reviews',
          defaultColor: const Color(0xFFFFAB40),
          ledColor: const Color(0xFFFFAB40),
          importance: NotificationImportance.High,
          enableVibration: true,
          defaultRingtoneType: DefaultRingtoneType.Notification,
        ),
      ],
    );
    
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: 'recipe_reviews',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }
}