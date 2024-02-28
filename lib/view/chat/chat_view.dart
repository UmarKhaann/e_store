import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/repository/chat_repo.dart';
import 'package:e_store/repository/notifications_repo.dart';
import 'package:e_store/res/components/custom_message_widget.dart';
import 'package:e_store/res/components/sending_message_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatView extends StatefulWidget {
  final dynamic data;

  const ChatView({required this.data, Key? key}) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> stream;
  final NotificationRepo notificationRepo = NotificationRepo();
  String chatId = '';
  String productName = '';

  void initChat() async{
    if (widget.data['chatId'] == 'null'){
      await _firestore.collection('products').doc(widget.data['productId']).get().then((value) {
        String uid = value.data()!['uid'];
        productName = value.data()!['title'];
        chatId = ((_auth.currentUser!.uid + widget.data['productId'] + uid).split('')..sort()..join()).toString();
      });
    } else {
      await _firestore.collection('conversations').doc(chatId).get().then((value) => productName =  value.data()!['productName']);
      chatId = widget.data['chatId'];
    }
    stream = _firestore.collection('conversations').doc(chatId).snapshots();
  }

  @override
  void initState(){
    initChat();

    ChatModel.player.openPlayer();

    notificationRepo.requestNotificationsPermission();
    notificationRepo.forgroundMessage();
    notificationRepo.firebaseInit(context);
    notificationRepo.setupInteractMessage(context);
    notificationRepo.isTokenRefresh();
    super.initState();
  }

  @override
  void dispose() {
    ChatModel.player.closePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController(
        initialScrollOffset: MediaQuery.of(context).size.height * 1);
    final height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      appBar: AppBar(title: Text(productName)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: stream,
                builder: (context,
                    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (!snapshot.hasData) {
                    return SizedBox(
                        height: height * 0.5,
                        child:
                            const Center(child: CircularProgressIndicator()));
                  } else {
                    final data = snapshot.data?.data();
                    if (data == null) {
                      return const Expanded(
                          child: Center(child: Text("there isn't any data")));
                    } else {
                      return Column(
                        children: [
                          Expanded(
                            child: CustomScrollView(
                              controller: scrollController,
                              slivers: [
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                    final messages = data['messages'][index];
                                    final meCurrUser = messages['sender'] ==
                                        _auth.currentUser!.uid;
                                    return CustomMessageWidget(
                                      messages: messages,
                                      meCurrUser: meCurrUser,
                                    );
                                  }, childCount: data['messages'].length),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                  }
                },
              ),
            ),
            SendingMessageWidget(
              scrollController: scrollController,
              data: {
                'chatId': chatId,
                'productId': widget.data['productId']
              },
            ),
          ],
        ),
      ),
    );
  }
}
