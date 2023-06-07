import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/res/components/custom_message_widget.dart';
import 'package:e_store/res/components/sending_message_widget.dart';
import 'package:e_store/view_model/chat_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../res/components/custom_drawer.dart';

class ChatView extends StatefulWidget {
  final dynamic productDocs;

  const ChatView({required this.productDocs, Key? key}) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> stream;

  @override
  void initState() {
    final id = (_auth.currentUser!.uid +
            widget.productDocs['productId'] +
            widget.productDocs['uid'])
        .split('')
      ..sort()
      ..join();
    stream = FirebaseFirestore.instance
        .collection('conversations')
        .doc(id.toString())
        .snapshots();
    ChatModel.player.openPlayer();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    ChatModel.player.closePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController(
        initialScrollOffset: MediaQuery.of(context).size.height * 1);
    final height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(title: Text(widget.productDocs['title'])),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
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
                      return Expanded(
                        child: CustomScrollView(
                          controller: scrollController,
                          slivers: [
                            SliverList(
                              delegate:
                                  SliverChildBuilderDelegate((context, index) {
                                final messages = data['messages'][index];
                                final meCurrUser = messages['sender'] ==
                                    _auth.currentUser!.uid;
                                return CustomMessageWidget(
                                    messages: messages, meCurrUser: meCurrUser,
                                );
                              }, childCount: data['messages'].length),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                }),
            SendingMessageWidget(
              scrollController: scrollController,
              productDocs: widget.productDocs,
            ),
          ],
        ),
      ),
    );
  }
}
