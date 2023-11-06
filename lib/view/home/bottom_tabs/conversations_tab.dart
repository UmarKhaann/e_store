import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../utils/routes/routes_name.dart';

class ConversationsTab extends StatelessWidget {
  ConversationsTab({Key? key}) : super(key: key);

  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot<Map<String, dynamic>>> conversations = fireStore
        .collection('conversations')
        .where('members', arrayContains: _auth.currentUser!.uid)
        .orderBy('lastMessageTime', descending: false)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder(
              stream: conversations,
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Expanded(
                      child: Center(
                          child: Text("there aren't any conversations")));
                } else {
                  return Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final reversedIndex =
                              (snapshot.data!.docs.length - 1) - index;
                          return InkWell(
                            onTap: () {
                              final Map map = {
                                'uid': _auth.currentUser!.uid ==
                                        snapshot.data!.docs[reversedIndex]
                                            ['members'][1]
                                    ? snapshot.data!.docs[reversedIndex]
                                        ['members'][0]
                                    : snapshot.data!.docs[reversedIndex]
                                        ['members'][1],
                                'productId': snapshot.data!.docs[reversedIndex]
                                    ['productId'],
                                'title': snapshot.data!.docs[reversedIndex]
                                    ['productName']
                              };
                              Navigator.pushNamed(context, RoutesName.chatView,
                                  arguments: map);
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                        snapshot.data!.docs[reversedIndex]
                                            ['imageUrl'],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data!.docs[reversedIndex]
                                              ['userName'],
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          snapshot.data!.docs[reversedIndex]
                                              ['productName'],
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ));
                }
              })
        ],
      ),
    );
  }
}
