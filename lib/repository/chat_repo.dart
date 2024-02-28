import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/provider/voice_duration.dart';
import 'package:e_store/repository/auth_repo.dart';
import 'package:e_store/repository/notifications_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../res/components/custom_button.dart';

class ChatModel {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FlutterSoundPlayer player = FlutterSoundPlayer();
  static String voiceChatId = '';
  static final FlutterSoundRecorder voiceRecorder = FlutterSoundRecorder();
  static Timer? timer;

  static Future startRecording() async {
    voiceChatId = DateTime.now().microsecondsSinceEpoch.toString();
    await voiceRecorder.startRecorder(
      toFile: voiceChatId,
    );
    debugPrint('recording started');
  }

  static Future stopRecording() async {
    final path = await voiceRecorder.stopRecorder();
    final audioPath = File(path!);
    debugPrint('recording stopped');
    return audioPath;
  }

  static Future playVoiceMessage(
      context, String fileUrl, VoidCallback whenFinished) async {
    await player
        .startPlayer(fromURI: fileUrl, whenFinished: whenFinished)
        .then((value) {
      final voiceProvider =
          Provider.of<VoiceDurationProvider>(context, listen: false);
      voiceProvider.setVoiceDuration(value!.inSeconds);
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (voiceProvider.voiceDuration > voiceProvider.position) {
          voiceProvider.setPosition();
        } else {
          timer.cancel();
        }
      });
    });
  }

  static Future stopVoiceMessage(context) async {
    final durationProvider =
        Provider.of<VoiceDurationProvider>(context, listen: false);
    durationProvider.setVoiceDuration(0);
    durationProvider.resetPosition();
    timer!.cancel();
    await player.stopPlayer();
  }

  static Future toggleVoiceMessage(
      {required BuildContext context,
      required String fileUrl,
      required VoidCallback whenFinished}) async {
    if (player.isPlaying) {
      await stopVoiceMessage(context);
    } else {
      await playVoiceMessage(context, fileUrl, whenFinished);
    }
  }

  static void askForMicrophonePermission(context) async {
    final PermissionStatus permissionStatus =
        await Permission.microphone.status;
    if (!permissionStatus.isGranted) {
      bool status = await Permission.microphone.request().isGranted;
      if (!status) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  content: const Text('App requires microphone permissions.'),
                  actions: [
                    CustomButton(
                        height: 35,
                        width: 130,
                        text: 'No thanks',
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    CustomButton(
                        height: 35,
                        width: 130,
                        text: 'Open settings',
                        onPressed: () {
                          openAppSettings();
                        }),
                  ],
                ));
      }
    } else {
      debugPrint('permission denied');
    }
  }

  static getToken(uid) async {
    var docSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    var fcmToken = docSnapshot.data()!['fcmToken'];

    return fcmToken;
  }

  static sentChatMessage({
    required bool isVoiceMessage,
    required String message,
    required String chatId,
    required dynamic productId,
  }) {
    DateTime now = DateTime.now();
    String formattedDateTime = DateFormat.MMMd().add_jm().format(now);
    String customFormattedDateTime = formattedDateTime.replaceAll(',', ' at');
    final NotificationRepo notificationRepo = NotificationRepo();

    final productDocs = _firestore.collection('products').doc(productId);

    final doc = _firestore.collection('conversations').doc(chatId);
    doc.get().then((value) {
      if (value.exists) {
        doc.update({
          "messages": FieldValue.arrayUnion([
            {
              "sender": _auth.currentUser!.uid,
              isVoiceMessage ? "voiceMessage" : "message": message,
              "time": customFormattedDateTime,
            }
          ]),
          "lastMessageTime": DateTime.now().microsecondsSinceEpoch.toString(),
        }).then((_) async {
          List members = await value.data()!['members'];

          String uid =
              AuthRepo.currentUserUid == members[0] ? members[1] : members[0];
          getToken(uid).then((token) async {
            notificationRepo.sentNoti(
              token: token,
              title: _auth.currentUser!.displayName!,
              body: isVoiceMessage ? "voice message" : message,
              chatId: chatId,
            );
          });
        });
      } else {
        productDocs.get().then((productDocs) {
          doc.set({
            "members": [_auth.currentUser!.uid, productDocs['uid']],
            "productId": productDocs['productId'],
            "productName": productDocs['title'],
            "imageUrl": productDocs['imageUrl'],
            'userName': productDocs['name'],
            "messages": [
              {
                "sender": _auth.currentUser!.uid,
                isVoiceMessage ? "voiceMessage" : "message": message,
                "time": customFormattedDateTime,
              }
            ],
            "lastMessageTime": DateTime.now().microsecondsSinceEpoch.toString(),
          }).then((_) async {
            List members = await value.data()!['members'];

            String uid =
                AuthRepo.currentUserUid == members[0] ? members[1] : members[0];
            getToken(uid).then((token) async {
              notificationRepo.sentNoti(
                token: token,
                title: _auth.currentUser!.displayName!,
                body: isVoiceMessage ? "voice message" : message,
                chatId: chatId,
              );
            });
          });
        });
      }
    });
  }
}
