import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RequestTabView extends StatelessWidget {
  final Map<String, dynamic> data;

  const RequestTabView({required this.data, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return FutureBuilder(
      future: data['productsRequest']
          as Future<QuerySnapshot<Map<String, dynamic>>>,
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
            docs = snapShot.data!.docs.where((element) {
              return element
                      .data()['title']
                      .toString()
                      .toLowerCase()
                      .startsWith(data['query'].toString().toLowerCase()) ||
                  element
                      .data()['title']
                      .toString()
                      .toLowerCase()
                      .contains(data['query'].toString().trim().toLowerCase());
            }).toList();

            docs.sort((b, a) {
              final aTitle = a.data()['title'].toString().toLowerCase();
              final bTitle = b.data()['title'].toString().toLowerCase();
              final query = data['query'].toString().toLowerCase();

              if (aTitle.startsWith(query) && !bTitle.startsWith(query)) {
                return -1;
              } else if (!aTitle.startsWith(query) &&
                  bTitle.startsWith(query)) {
                return 1;
              }

              return aTitle.compareTo(bTitle);
            });
          }
          return Padding(
              padding: const EdgeInsets.all(8.0),
              child: docs.isEmpty
                  ? const Center(child: Text('Nothing Found!'))
                  : ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final reversedIndex =
                            (snapShot.data!.docs.length - 1) - index;
                        final docs = snapShot.data!.docs[reversedIndex];
                        return Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 10, bottom: 10, left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          docs['name'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        TextButton(
                                          onPressed: () {},
                                          style: ButtonStyle(
                                              padding:
                                                  MaterialStateProperty.all(
                                                      EdgeInsets.zero)),
                                          child: const Text("Get in touch"),
                                        )
                                      ],
                                    ),
                                    Text(
                                      docs['time'],
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 13),
                                    ),
                                    SizedBox(height: height * .01),
                                    Text(
                                        "${docs['description']} for ${docs['price']}\$"),
                                  ],
                                ),
                              ),
                              if (docs['imageUrl'].isNotEmpty)
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                  child: CachedNetworkImage(
                                    width: double.infinity,
                                    height: height * .25,
                                    fit: BoxFit.cover,
                                    imageUrl: docs['imageUrl'].toString(),
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
                      }));
        }
      },
    );
  }
}
