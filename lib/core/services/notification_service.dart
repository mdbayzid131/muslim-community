import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:muslim_community/core/utils/helpers.dart';

class NotificationService extends GetxService {
  FirebaseMessaging? _messaging;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  @override
  void onInit() {
    super.onInit();
    initializeNotifications();
  }

  Future<void> initializeNotifications() async {
    try {
      _messaging = FirebaseMessaging.instance;
      if (_messaging == null) return;

      // 1. Request permission
      NotificationSettings settings = await _messaging!.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      Helpers.info('Notification permission status: ${settings.authorizationStatus}');

      await _messaging!.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // 2. Get the FCM Token
      _fcmToken = await _messaging!.getToken();
      Helpers.info('FCM Token: $_fcmToken');

      // 3. Android Notification Channel
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
        playSound: true,
      );

      await _localNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);

      // 4. Initialize Local Notifications
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings initializationSettingsDarwin =
          DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          );

      const InitializationSettings initializationSettings =
          InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
          );

      await _localNotificationsPlugin.initialize(
        settings: initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          Helpers.info('Notification clicked: ${response.payload}');
        },
      );

      // 5. Foreground Messages Listener
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        Helpers.info('Received a foreground message: ${message.messageId}');
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        if (notification != null && android != null) {
          _localNotificationsPlugin.show(
            id: notification.hashCode,
            title: notification.title,
            body: notification.body,
            notificationDetails: NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: '@mipmap/ic_launcher',
                importance: Importance.max,
                priority: Priority.high,
                playSound: true,
              ),
            ),
            payload: message.data.toString(),
          );
        }
      });

      // 6. Handle App Open from notification
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        Helpers.info('App opened from notification: ${message.data}');
      });
    } catch (e) {
      Helpers.error('Error initializing notifications: $e');
    }
  }
}
