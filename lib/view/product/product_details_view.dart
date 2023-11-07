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
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
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
          const SizedBox(width: 10,),
        ],
      ),
      body: Stack(
        children: [
          Hero(
            tag: docs['imageUrl'],
            child: CachedNetworkImage(
              width: double.infinity,
              height: height * .45,
              fit: BoxFit.cover,
              imageUrl: docs['imageUrl'].toString(),
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                      child: CircularProgressIndicator(
                          value: downloadProgress.progress)),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(.1),
            height: 500,
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: height * .40,
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40)),
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    color: Theme.of(context).cardColor,
                    height: height * .60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Rs ${docs['price']}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 22),
                            ),
                            Text(
                              docs['time'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
                        SizedBox(
                          height: height * .35,
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: [
                              Text(
                                docs['description'],
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Expanded(child: Container()),
                        if (docs['uid'] != _auth.currentUser!.uid)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomButton(
                                  width: 110,
                                  text: 'SMS',
                                  onPressed: () async {
                                    ProductDetailModel.launchTextMessage(
                                        phone: docs['phone']);
                                  }),
                              CustomButton(
                                  width: 110,
                                  text: 'CALL',
                                  onPressed: () {
                                    ProductDetailModel.launchCall(
                                        phone: docs['phone']);
                                  }),
                              CustomButton(
                                  width: 110,
                                  text: 'CHAT',
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, RoutesName.chatView,
                                        arguments: docs);
                                  }),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
