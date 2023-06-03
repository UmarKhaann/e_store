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
  final ValueNotifier<bool> _isTyping = ValueNotifier<bool>(false);

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
                      return const Expanded(child: Center(child: Text("there isn't any data")));
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

                                String storedTime = messages['time'];
                                DateTime parsedTime = DateFormat.MMMd()
                                    .add_jm()
                                    .parse(storedTime);
                                String formattedTime =
                                    DateFormat.jm().format(parsedTime);

                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Align(
                                    alignment: meCurrUser
                                        ? Alignment.topRight
                                        : Alignment.topLeft,
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: meCurrUser
                                              ? Colors.blue
                                              : Theme.of(context).cardColor,
                                          borderRadius: BorderRadius.only(
                                              topLeft:
                                                  const Radius.circular(15),
                                              topRight:
                                                  const Radius.circular(15),
                                              bottomLeft: Radius.circular(
                                                  meCurrUser ? 15 : 0),
                                              bottomRight: Radius.circular(
                                                  meCurrUser ? 0 : 15))),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              '${messages['message']}',
                                            ),
                                          ),
                                          const SizedBox(width: 10,),
                                          Text(
                                            formattedTime,
                                            style:
                                                const TextStyle(fontSize: 10),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }, childCount: data['messages'].length),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomInputField(
                    onChanged: (value){
                      if(value.isNotEmpty){
                        _isTyping.value = true;
                      }else{
                        _isTyping.value = false;
                      }
                    },
                    circularBorderRadius: 30,
                      hintText: "Type a message", controller: _chatController),
                ),
                const SizedBox(width: 10,),
                ValueListenableBuilder(
                  valueListenable: _isTyping,
                  builder: (context, snapshot, child){
                    return CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.blue,
                      child: Center(
                        child: IconButton(
                          onPressed: (){
                            ChatModel.sentChatMessage(
                                message: _chatController.text,
                                productDocs: widget.productDocs);
                            _chatController.clear();
                            scrollController.animateTo(
                                scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInCirc);
                          },
                          icon: snapshot ? const Icon(Icons.send) : const Icon(Icons.mic),

                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
