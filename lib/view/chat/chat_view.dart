import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/res/components/custom_input_field.dart';
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
    stream = FirebaseFirestore.instance.collection('conversations').doc(_auth.currentUser!.uid +widget.productDocs['productId']).snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            StreamBuilder(
              stream: stream,
                builder: (context, AsyncSnapshot snapshot){
                if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator());
                }else{
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data.data()['messages'].length,
                        itemBuilder: (context, index){
                        return Text(snapshot.data.data()['messages'][index]['message'] ?? "there isn't any data",
                          textAlign: snapshot.data.data()['messages'][index]['sender'] == _auth.currentUser!.uid ? TextAlign.right : TextAlign.left);
                        }),
                  );
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
                      ChatModel.sentChatMessage(message: _chatController.text, productDocs: widget.productDocs);
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
