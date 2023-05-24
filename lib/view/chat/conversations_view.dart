import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../res/components/custom_drawer.dart';
import '../../utils/routes/routes_name.dart';

class ConversationsView extends StatefulWidget {
  const ConversationsView({Key? key}) : super(key: key);

  @override
  State<ConversationsView> createState() => _ConversationsViewState();
}

class _ConversationsViewState extends State<ConversationsView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Query<Map<String, dynamic>> snapShot;

  @override
  void initState() {
    snapShot = FirebaseFirestore.instance
        .collection('conversations')
        .where('members', arrayContains: _auth.currentUser!.uid);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text("Chats"),
      ),
      body: Column(
        children: [
          StreamBuilder(
              stream: snapShot.snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if(snapshot.data.docs.isEmpty){
                    return const Center(child: Text("there isn't any data"));
                  }
                  return Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              final Map map = {
                                'uid': _auth.currentUser!.uid == snapshot.data.docs[index]['members'][1] ? snapshot.data.docs[index]['members'][0] : snapshot.data.docs[index]['members'][1] ,
                                'productId': snapshot.data.docs[index]['productId'],
                                'title': snapshot.data.docs[index]['productName']
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
                                        snapshot.data.docs[index]['imageUrl'],
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
                                          snapshot.data.docs[index]['userName'],
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                            snapshot.data.docs[index]
                                                ['productName'],
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
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
