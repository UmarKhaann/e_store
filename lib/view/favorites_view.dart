import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_store/repository/home_repo.dart';
import 'package:e_store/res/components/favorite_button.dart';
import 'package:e_store/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';

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
        child: Column(
          children: [
            FutureBuilder(
              future: HomeRepo.favoriteProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(),);
                } else if (!snapshot.hasData||snapshot.data!.docs.isEmpty) {
                  return const Text("There isn't any Favorite");
                } else {
                  return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final data = snapshot.data!.docs[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Card(
                              margin: EdgeInsets.zero,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RoutesName.productDetailView,
                                      arguments: data);
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
                                          tag: data['imageUrl'],
                                          child: CachedNetworkImage(
                                            height: 100,
                                            width: 100,
                                            imageUrl: data['imageUrl'],
                                            fit: BoxFit.cover,
                                            progressIndicatorBuilder: (context,
                                                    url, downloadProgress) =>
                                                Center(
                                                    child:
                                                        CircularProgressIndicator(
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
                              ),
                            ),
                          );
                        }),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
