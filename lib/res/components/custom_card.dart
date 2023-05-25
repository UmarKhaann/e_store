import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomCard extends StatelessWidget {
  final Function()? onTap;
  final QueryDocumentSnapshot<Map<String, dynamic>> docs;

  const CustomCard({required this.docs, required this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(10), right: Radius.circular(10)),
              child: CachedNetworkImage(
                width: width,
                height: height * .2,
                fit: BoxFit.cover,
                imageUrl: docs['imageUrl'].toString(),
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                        child: CircularProgressIndicator(
                            value: downloadProgress.progress)),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            SizedBox(
              height: height * .01,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Name: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(docs['title'].toString()),
                    ],
                  ),
                  // Text(docs['title'].toString()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Price: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('Rs ${docs['price'].toString()}'),
                    ],
                  ),
                ],
              ),
            ),
            // Text(docs['description'].toString())
          ],
        ),
      ),
    );
  }
}
