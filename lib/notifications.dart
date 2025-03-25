import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// NotificationService class
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // Initialize the notification service
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Android initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Initialization settings
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Show notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    // Android notification settings
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'rehearsal_channel', 
      'Rehearsal Notifications', 
      channelDescription: 'Notifications for rehearsal reminders',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

  // Notification details
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

  // Show notification
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
    );
  }
}
