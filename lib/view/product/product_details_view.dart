import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_store/res/components/custom_button.dart';
import 'package:e_store/res/components/favorite_button.dart';
import 'package:e_store/utils/routes/routes_name.dart';
import 'package:e_store/view_model/product_detail_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductDetailsView extends StatelessWidget {
  final dynamic docs;

  ProductDetailsView({required this.docs, Key? key}) : super(key: key);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            FavoriteButton(productId: docs['productId']),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Hero(
                      tag: docs['imageUrl'],
                      child: CachedNetworkImage(
                        color: Colors.black.withOpacity(.2),
                        colorBlendMode: BlendMode.darken,
                        width: double.infinity,
                        height: height * .35,
                        fit: BoxFit.cover,
                        imageUrl: docs['imageUrl'].toString(),
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Center(
                                child: CircularProgressIndicator(
                                    value: downloadProgress.progress)),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Rs ${docs['price']}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Text(
                                docs['time'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Text(
                            docs['title'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Description',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text(
                            docs['description'],
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            if (docs['uid'] == _auth.currentUser!.uid)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CustomButton(
                  width: width * .9,
                  text: 'Edit',
                  onPressed: () {},
                ),
              ),
            if (docs['uid'] != _auth.currentUser!.uid)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                        width: width * .3,
                        text: 'SMS',
                        onPressed: () async {
                          ProductDetailModel.launchTextMessage(
                              phone: docs['phone']);
                        }),
                    CustomButton(
                        width: width * .3,
                        text: 'CALL',
                        onPressed: () {
                          ProductDetailModel.launchCall(phone: docs['phone']);
                        }),
                    CustomButton(
                        width: width * .3,
                        text: 'CHAT',
                        onPressed: () {
                          Navigator.pushNamed(context, RoutesName.chatView,
                              arguments: docs);
                        }),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
