import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/repository/auth_repo.dart';
import 'package:e_store/repository/home_repo.dart';
import 'package:e_store/res/components/bottomsheet.dart';
import 'package:flutter/material.dart';

class RequestTabView extends StatelessWidget {
  final Map<String, dynamic> data;

  const RequestTabView({required this.data, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return FutureBuilder(
      future: HomeRepo.productsRequest,
      builder: (context, snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.black),
          );
        } else if (!snapShot.hasData || snapShot.data!.docs.isEmpty) {
          return const Center(
              child: Text("There isn't any request available!"));
        } else {
          List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
              snapShot.data!.docs;
          if (!data['query'].isEmpty) {
            docs = HomeRepo.searchProduct(
                docs, 'description', data['query'].toString());
          }
          return Padding(
              padding: const EdgeInsets.all(8.0),
              child: docs.isEmpty
                  ? const Center(child: Text('Nothing Found!'))
                  : RefreshIndicator(
                      onRefresh: () async {
                        await HomeRepo.getPosts(context);
                      },
                      child: ListView.builder(
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            final reversedIndex = (docs.length - 1) - index;
                            return Card(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10, bottom: 10, left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              docs[reversedIndex]['name'],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                            if(AuthRepo.currentUserUid == docs[reversedIndex]['uid'])
                                            TextButton(onPressed: (){}, child: const Text('Edit')),
                                            if(AuthRepo.currentUserUid != docs[reversedIndex]['uid'])
                                            TextButton(
                                              onPressed: () {
                                                showModalBottomSheet(
                                                    context: context,
                                                    builder: (context) {
                                                      return ActionBottomSheet(docs: docs[reversedIndex],);
                                                    });
                                              },

                                              child: const Text("Get in touch"),
                                            )
                                          ],
                                        ),
                                        Text(
                                          docs[reversedIndex]['time'],
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 13),
                                        ),
                                        
                                        Text(
                                            "${docs[reversedIndex]['description']} for ${docs[reversedIndex]['price']}\$"),
                                      ],
                                    ),
                                  ),
                                  if (docs[reversedIndex]['imageUrl']
                                      .isNotEmpty)
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                      child: CachedNetworkImage(
                                        width: double.infinity,
                                        height: height * .25,
                                        fit: BoxFit.cover,
                                        imageUrl: docs[reversedIndex]
                                                ['imageUrl']
                                            .toString(),
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                Center(
                                          child: CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }),
                    ));
        }
      },
    );
  }
}
