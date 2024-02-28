import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/repository/home_repo.dart';
import 'package:e_store/res/components/custom_input_field.dart';
import 'package:e_store/utils/routes/routes_name.dart';
import 'package:e_store/view_model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConversationsTab extends StatefulWidget {
  const ConversationsTab({Key? key}) : super(key: key);

  @override
  State<ConversationsTab> createState() => _ConversationsTabState();
}

class _ConversationsTabState extends State<ConversationsTab> {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
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
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
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
          StreamBuilder(
              stream: HomeRepo.conversations,
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Expanded(child: Center(child: CircularProgressIndicator()));
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
                          ? const Expanded(child: Center(child: Text('Nothing Found!')))
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
                                        Navigator.pushNamed(
                                            context, RoutesName.chatView,
                                            arguments: {
                                              'chatId' : docs[reversedIndex].id,
                                              'productId' : docs[reversedIndex]['productId']
                                            });
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
