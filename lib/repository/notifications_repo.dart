import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:e_store/utils/routes/routes_name.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class NotificationRepo {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidInitialization =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitialization = const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
      android: androidInitialization,
      iOS: iOSInitialization,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) {
        handleMessage(context, message);
      },
    );
  }

  void requestNotificationsPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('granded');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('granded proversinal');
    } else {
      debugPrint('denied');
    }
  }

  Future<String?> getDeviceToken() async {
    return await messaging.getToken();
  }

  void isTokenRefresh() {
    messaging.onTokenRefresh.listen((event) {
      debugPrint('token: $event');
    });
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      if (Platform.isAndroid) {
        initLocalNotifications(context, message);
        showNotification(message);
      } else {
        showNotification(message);
      }
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel androidNotificationChannel =
        AndroidNotificationChannel(
            Random.secure().nextInt(1000).toString(), 'channelName',
            importance: Importance.max);

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            androidNotificationChannel.id, androidNotificationChannel.name,
            channelDescription: 'This is channel description.',
            importance: Importance.high,
            priority: Priority.high,
            ticker: 'ticker');

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    Future.delayed(
      Duration.zero,
      () {
        flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails,
        );
      },
    );
  }

  Future<void> setupInteractMessage(BuildContext context) async {
    await messaging.getInitialMessage().then((initialMessage) {
      if (initialMessage != null) {
        handleMessage(context, initialMessage);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    if (message.data['type'].toString() == 'message') {
      debugPrint('before: navigated');
      Navigator.pushNamed(context, RoutesName.notificationView);
      debugPrint('after: navigated');
    }
  }

  void sentNotification({required token,required title, required body}) async {
    var data = {
      'to': token,
      'priority': 'high',
      'notification': {
        'title': title,
        'body': body,
      }
    };
    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'key=AAAAidyJF5M:APA91bFLmYSqs_4zOsFB4DE0E8pKp7GBEPA2PBIrgxqmJhNSCscLqQlcyjViMPObPAqYvZ4vnCHU71bZMOhQMM1X4IU3MQfasY5FQ2Meu1YgSoST4Cc3tvdcLFb45xTpLjXIpfUite3S'
        });
  }
}
