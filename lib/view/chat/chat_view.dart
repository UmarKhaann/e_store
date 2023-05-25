import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/res/components/custom_input_field.dart';
import 'package:e_store/view_model/chat_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../res/components/custom_drawer.dart';

class ChatView extends StatefulWidget {
  final dynamic productDocs;

  const ChatView({required this.productDocs, Key? key}) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _chatController = TextEditingController();
  late Stream<DocumentSnapshot<Map<String, dynamic>>> stream;

  @override
  void dispose() {
    // TODO: implement dispose
    _chatController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: Text(widget.productDocs['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: stream,
                builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                  if (!snapshot.hasData) {
                    return SizedBox(
                      height: height * 0.5,
                        child: const Center(child: CircularProgressIndicator()));
                  } else {
                    final data = snapshot.data?.data();
                    if (data == null) {
                      return const Center(child: Text("there isn't any data"));
                    } else {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: data['messages'].length,
                            itemBuilder: (context, index) {
                              final messages = data['messages'][index];
                              final meCurrUser = messages['sender'] ==
                                  _auth.currentUser!.uid;

                              String storedTime = messages['time'];
                              DateTime parsedTime = DateFormat.MMMd().add_jm().parse(storedTime);
                              String formattedTime = DateFormat.jm().format(parsedTime);

                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: meCurrUser ? 5.0 : 2.0),
                                child: Align(
                                  alignment: meCurrUser ? Alignment.topRight : Alignment.topLeft,
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: meCurrUser ? Colors.blue : Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(5)
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            '${messages['message']}   ',
                                          ),
                                        ),
                                        Text(formattedTime, style: const TextStyle(fontSize: 10),)
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      );
                    }
                  }
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomInputField(
                      hintText: "Type a message", controller: _chatController),
                ),
                IconButton(
                    onPressed: () {
                      ChatModel.sentChatMessage(
                          message: _chatController.text,
                          productDocs: widget.productDocs);
                      _chatController.clear();
                    },
                    icon: const Icon(Icons.send)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
