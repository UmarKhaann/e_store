import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/repository/home_repo.dart';
import 'package:e_store/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';

import '../../../res/components/custom_card.dart';

class ProductTabView extends StatelessWidget {
  final Map<String, dynamic> data;
  const ProductTabView({required this.data, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: HomeRepo.sellingProducts,
      builder: (context, snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapShot.data!.docs.isEmpty || !snapShot.hasData) {
          return const Center(child: Text('No Products Available'));
        } else {
          List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
              snapShot.data!.docs;
          if (!data['query'].isEmpty) {
            docs =
                HomeRepo.searchProduct(docs, 'title', data['query'].toString());
            HomeRepo.sort(docs, data['query']);
          }
          return Padding(
            padding: const EdgeInsets.all(10),
            child: docs.isEmpty
                ? const Center(child: Text('Nothing Found!'))
                : RefreshIndicator(
                  color: Theme.of(context).iconTheme.color,
                    onRefresh: () async {
                      await HomeRepo.getPosts(context);
                    },
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                childAspectRatio: 3 / 3.8,
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
                  ),
          );
        }
      },
    );
  }
}
