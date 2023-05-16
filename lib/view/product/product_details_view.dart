import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_store/res/components/custom_button.dart';
import 'package:e_store/view_model/product_detail_model.dart';
import 'package:flutter/material.dart';

class ProductDetailsView extends StatelessWidget {
  final dynamic docs;

  const ProductDetailsView({required this.docs, Key? key}) : super(key: key);

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
      ),
      body: Stack(
        children: [
          CachedNetworkImage(
            width: double.infinity,
            height: height * .40,
            fit: BoxFit.cover,
            imageUrl: docs['imageUrl'].toString(),
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Center(
                    child: CircularProgressIndicator(
                        color: Colors.black,
                        value: downloadProgress.progress)),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: height * .35,
              ),
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(50),
                  topLeft: Radius.circular(50)
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.grey[100],
                  height: height * .65,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
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
                                style: const TextStyle(fontWeight: FontWeight.bold),
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
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Text(docs['description']),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(50),
                              bottomLeft: Radius.circular(10),
                            ),
                            child: CustomButton(
                                width: 120,
                                text: 'SMS',
                                onPressed: () async {
                                  ProductDetailModel.launchTextMessage(
                                      phone: docs['phone']);
                                }),
                          ),
                          CustomButton(
                              width: 120,
                              text: 'CALL',
                              onPressed: () {
                                ProductDetailModel.launchCall(phone: docs['phone']);
                              }),
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(50),
                              topRight: Radius.circular(10),
                            ),
                            child: CustomButton(
                                width: 120,
                                text: 'WhatsApp',
                                onPressed: () {
                                  ProductDetailModel.launchWhatsApp();
                                }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
