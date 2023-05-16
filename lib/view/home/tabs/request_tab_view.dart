import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../utils/routes/routes_name.dart';

class RequestTabView extends StatelessWidget {
  final Stream productsRequest;

  const RequestTabView({required this.productsRequest, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return StreamBuilder(
      stream: productsRequest,
      builder: (context, snapShot) {
        if (!snapShot.hasData) {
          return const Center(child: CircularProgressIndicator(color: Colors.black,));
        } else {
          return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  itemCount: snapShot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final reversedIndex =
                        (snapShot.data!.docs.length - 1) - index;
                    final docs = snapShot.data!.docs[reversedIndex];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: InkWell(
                        onTap: (){
                          Navigator.pushNamed(context, RoutesName.productDetailView, arguments: docs);
                        },
                        child: Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      docs['name'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Text(
                                      docs['time'],
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 13),
                                    ),
                                    SizedBox(height: height * .01),
                                    Text(docs['description']),
                                  ],
                                ),
                              ),
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
                                              color: Colors.black,
                                                value: downloadProgress.progress),
                                          ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }));
        }
      },
    );
  }
}
