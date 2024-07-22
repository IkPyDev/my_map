import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';

import '../data/src/local.dart';
import '../data/src/remote/firebase_manager.dart';
import '../model/user_model.dart';

class NotificationManager {
  static final NotificationManager _instance = NotificationManager._internal();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  factory NotificationManager() {
    return _instance;
  }

  NotificationManager._internal();

  Future<void> init() async {
    // Request permission for notifications
    await FirebaseMessaging.instance.requestPermission();

    // Set auto initialization for Firebase Messaging
    await FirebaseMessaging.instance.setAutoInitEnabled(true);

    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('New foreground message received: ${message.notification?.title}');
      showNotification(message);
      _updateLocationOnMessage();
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'default_channel_id',
      'default_channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: message.data['payload'],
    );
  }

  Future<void> onDidReceiveNotificationResponse(NotificationResponse response) async {
    // Handle notification tap
    if (response.payload != null) {
      print('Notification tapped with payload: ${response.payload}');
      // Update location on notification tap
      await _updateLocationOnMessage();
      // Navigate to the appropriate screen if needed
    }
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // Handle background message
    UserModel user = SharedPrefsManager.getUserData();
    await NotificationManager().showNotification(message);
    print('New background message received: ${message.notification?.title}');
    await _updateLocationOnMessage();
  }

  static Future<void> _updateLocationOnMessage() async {
    print("Updating location...");
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    await FirebaseManager.updateLocation(position.latitude, position.longitude);
  }
}
