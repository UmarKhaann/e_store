import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/res/components/favorite_button.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Function()? onTap;
  final QueryDocumentSnapshot<Map<String, dynamic>> docs;

  const CustomCard({
    required this.docs,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.zero,
        child: Column(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
              child: Hero(
                tag: docs['imageUrl'],
                child: CachedNetworkImage(
                  width: width,
                  height: height * .17,
                  fit: BoxFit.cover,
                  imageUrl: docs['imageUrl'].toString(),
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                          child: CircularProgressIndicator(
                              value: downloadProgress.progress)),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${docs['price']} Rs',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Container(
                          constraints:
                              BoxConstraints.tight(const Size(30, 35)),
                          child:
                              FavoriteButton(productId: docs['productId'])),
                    ],
                  ),
                  Text(docs['title'].toString(),
                      overflow: TextOverflow.ellipsis),
                  Text(docs['time'].toString()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
