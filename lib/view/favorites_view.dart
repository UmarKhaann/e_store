import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/res/components/favorite_button.dart';
import 'package:e_store/utils/routes/routes_name.dart';
import 'package:e_store/view_model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Consumer<HomeViewModel>(
          builder: (context, homeViewModel, child) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: homeViewModel.favoritesList.length,
                      itemBuilder: (context, index) {
                        final reversedIndex =
                            (homeViewModel.favoritesList.length - 1) - index;
                        final product = FirebaseFirestore.instance
                            .collection('products')
                            .doc(homeViewModel.favoritesList[reversedIndex])
                            .get();
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Card(
                            margin: EdgeInsets.zero,
                            child: FutureBuilder(
                              future: product,
                              builder: (context, snapShot) {
                                if (snapShot.connectionState !=
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (!snapShot.hasData ||
                                    snapShot.data!.data()!.isEmpty) {
                                  return const Text('Data not available');
                                } else {
                                  final data = snapShot.data!.data();
                                  return InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, RoutesName.productDetailView,
                                          arguments: snapShot.data!.data());
                                    },
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.horizontal(
                                                    left: Radius.circular(10)),
                                            child: Hero(
                                              tag: data!['imageUrl'],
                                              child: CachedNetworkImage(
                                                height: 100,
                                                width: 100,
                                                imageUrl: data['imageUrl'],
                                                fit: BoxFit.cover,
                                                progressIndicatorBuilder: (context,
                                                        url, downloadProgress) =>
                                                    Center(
                                                        child: CircularProgressIndicator(
                                                            value:
                                                                downloadProgress
                                                                    .progress)),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: SizedBox(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      '${data['price']} Rs',
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    FavoriteButton(
                                                        productId:
                                                            data['productId'])
                                                  ],
                                                ),
                                                Text(data['title']),
                                                Text(data['time']),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        );
                      }),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
