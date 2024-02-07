import 'dart:convert';
import 'dart:io';

import 'package:e_store/utils/routes/routes_name.dart';
import 'package:e_store/view/chat/chat_view.dart';
import 'package:e_store/view/notification_view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class NotificationRepo {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


  void initLocalNotifications(BuildContext context, RemoteMessage message, productDocs) async {
    var androidInit = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitialization = const DarwinInitializationSettings();

    var initSettings = InitializationSettings(
      android: androidInit,
      iOS: iOSInitialization,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (payload) {
        handleMessage(context, message, productDocs);
      },
    );
  }

  void firebaseInit(BuildContext context, productDocs) {
    FirebaseMessaging.onBackgroundMessage(showNotification);
    FirebaseMessaging.onMessage.listen((message) {

      RemoteNotification? notification = message.notification ;
      AndroidNotification? android = message.notification!.android ;


      if(Platform.isIOS){
        forgroundMessage();
      }


      if (Platform.isAndroid) {
        initLocalNotifications(context, message, productDocs);
        showNotification(message);
      }
    });
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
      debugPrint('granted');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('granted provisional');
    } else {
      debugPrint('denied');
    }
  }


  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel androidNotificationChannel = AndroidNotificationChannel(
      message.notification!.android!.channelId.toString(),
      message.notification!.android!.channelId.toString(),
      importance: Importance.max,
      showBadge: true,
      playSound: true,
      // sound: const RawResourceAndroidNotificationSound('jetsons_doorbell'),
    );

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      androidNotificationChannel.id,
      androidNotificationChannel.name,
      channelDescription: 'This is channel description.',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      ticker: 'ticker',
      // sound: androidNotificationChannel.sound,
    );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(Duration.zero, () {
        flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails,
        );
      },
    );
  }

  Future<String?> getDeviceToken() async {
    return await messaging.getToken();
  }

  void isTokenRefresh() {
    messaging.onTokenRefresh.listen((event) {
      debugPrint('token: $event');
    });
  }

  Future<void> setupInteractMessage(BuildContext context, productDocs) async {

    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if(initialMessage != null){
      handleMessage(context, initialMessage, productDocs);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event, productDocs);
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message, productDocs) {
    if (message.data['type'].toString() == 'msj') {
      Navigator.pushNamed(context, RoutesName.chatView, arguments: productDocs);
    }
  }

  Future forgroundMessage() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void sentNoti({required String token, required String title, required String body, required dynamic productDocs})async{

      var data = {
        'to' : token,
        'notification' : {
          'title' : title ,
          'body' : body,
          "sound": "jetsons_doorbell.mp3"
        },
        'android': {
          'notification': {
            'notification_count': 23,
          },
        },
        'data' : {
          'type' : 'msj' ,
          'id' : 'id',
          'productDocs':productDocs,
        }
      };

      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          body: jsonEncode(data) ,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization' : 'key=AAAAidyJF5M:APA91bFLmYSqs_4zOsFB4DE0E8pKp7GBEPA2PBIrgxqmJhNSCscLqQlcyjViMPObPAqYvZ4vnCHU71bZMOhQMM1X4IU3MQfasY5FQ2Meu1YgSoST4Cc3tvdcLFb45xTpLjXIpfUite3S'
          }
      ).then((value){
        if (kDebugMode) {
          print(value.body.toString());
        }
      }).onError((error, stackTrace){
        if (kDebugMode) {
          print(error);
        }
      });
  }

  // void sentNotification({required token, required title, required body}) async {
  //
  //
  //   var data = {
  //     'to': token.toString(),
  //     // 'priority': 'high',
  //     'notification': {
  //       'title': title,
  //       'body': body,
  //     },
  //     'android': {
  //       'notification': {
  //         'notification_count': 23,
  //       },
  //     },
  //     'data' : {
  //       'type' : 'msj',
  //       'id' : 'umar'
  //     }
  //   };
  //
  //   await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //       body: jsonEncode(data),
  //       headers: {
  //         'Content-Type': 'application/json; charset=UTF-8',
  //         'Authorization':
  //             'key=AAAAidyJF5M:APA91bFLmYSqs_4zOsFB4DE0E8pKp7GBEPA2PBIrgxqmJhNSCscLqQlcyjViMPObPAqYvZ4vnCHU71bZMOhQMM1X4IU3MQfasY5FQ2Meu1YgSoST4Cc3tvdcLFb45xTpLjXIpfUite3S'
  //       }).then((value){
  //         debugPrint(value.body.toString());
  //   }).onError((error, stackTrace){
  //     debugPrint(error.toString());
  //   });
  // }

}
