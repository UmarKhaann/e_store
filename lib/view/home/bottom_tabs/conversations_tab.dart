import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/repository/home_repo.dart';
import 'package:e_store/res/components/custom_input_field.dart';
import 'package:e_store/view_model/home_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/routes/routes_name.dart';

class ConversationsTab extends StatefulWidget {
  const ConversationsTab({Key? key}) : super(key: key);

  @override
  State<ConversationsTab> createState() => _ConversationsTabState();
}

class _ConversationsTabState extends State<ConversationsTab> {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    HomeRepo.getConversations();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: CustomInputField(
              padding: EdgeInsets.zero,
              icon: Icons.search,
              hintText: 'Search...',
              controller: searchController,
              onChanged: (value) {
                HomeRepo.searchProducts(context, searchController.text);
              },
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder(
              stream: HomeRepo.conversations,
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Expanded(
                      child: Center(
                          child: Text("there aren't any conversations")));
                } else {
                  return Consumer<HomeViewModel>(
                    builder: (context, homeViewModel, child) {
                      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
                          snapshot.data!.docs;
                      if (homeViewModel.query.isNotEmpty) {
                        docs = HomeRepo.searchProduct(
                            docs, 'productName', homeViewModel.query);
                        HomeRepo.sort(docs, homeViewModel.query);
                      }
                      return docs.isEmpty
                          ? const Center(child: Text('Nothing Found!'))
                          : Expanded(
                              child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: docs.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final reversedIndex =
                                        (docs.length - 1) - index;
                                    return ListTile(
                                      onTap: () {
                                        final Map map = {
                                          'uid': _auth.currentUser!.uid ==
                                                  docs[reversedIndex]['members']
                                                      [1]
                                              ? docs[reversedIndex]['members']
                                                  [0]
                                              : docs[reversedIndex]['members']
                                                  [1],
                                          'productId': docs[reversedIndex]
                                              ['productId'],
                                          'title': docs[reversedIndex]
                                              ['productName']
                                        };
                                        Navigator.pushNamed(
                                            context, RoutesName.chatView,
                                            arguments: map);
                                      },
                                      leading: docs[reversedIndex]['imageUrl'].isEmpty? const CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        child: Icon(Icons.person, color: Colors.white,),
                                      ):CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                          docs[reversedIndex]['imageUrl'],
                                        ),
                                      ),
                                      title: Text(
                                        docs[reversedIndex]['productName'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      subtitle: Text(
                                        docs[reversedIndex]['userName'],
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    );
                                  }));
                    },
                  );
                }
              })
        ],
      ),
    );
  }
}
