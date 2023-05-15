import 'package:e_store/res/components/custom_button.dart';
import 'package:e_store/view_model/product_detail_model.dart';
import 'package:flutter/material.dart';

class ProductDetailsView extends StatelessWidget {
  final dynamic docs;

  const ProductDetailsView({required this.docs, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
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
        ),
        body: Column(
          children: [
            Image.network(
                width: double.infinity,
                height: height * .35,
                fit: BoxFit.cover,
                docs['imageUrl'].toString()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: SizedBox(
                width: double.infinity,
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
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(docs['description']),
                  ],
                ),
              ),
            ),
            Expanded(child: Container()),
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
            const Divider(),
          ],
        ),
      ),
    );
  }
}
