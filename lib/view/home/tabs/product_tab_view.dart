import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';

import '../../../res/components/custom_card.dart';

class ProductTabView extends StatelessWidget {
  final Map<String, dynamic> data;
  const ProductTabView({required this.data, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: data['sellingProducts']
          as Future<QuerySnapshot<Map<String, dynamic>>>,
      builder: (context, snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapShot.data!.docs.isEmpty || !snapShot.hasData) {
          return const Center(child: Text('No Products Available'));
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
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            childAspectRatio: 3 / 4,
                            mainAxisSpacing: 10),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final reversedIndex = (docs.length - 1) - index;
                      return CustomCard(
                          docs: docs[reversedIndex],
                          onTap: () {
                            Navigator.pushNamed(
                                context, RoutesName.productDetailView,
                                arguments: docs[reversedIndex]);
                          });
                    }),
          );
        }
      },
    );
  }
}
