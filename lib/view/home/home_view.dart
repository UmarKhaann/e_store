import 'package:e_store/res/components/custom_alert_box.dart';
import 'package:e_store/res/components/custom_button.dart';
import 'package:e_store/utils/routes/routes_name.dart';
import 'package:e_store/view/home/tabs/request_tab_view.dart';
import 'package:e_store/view/home/tabs/product_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final sellingProducts = fireStore.collection('ProductsForSale').snapshots();
    final productsRequest = fireStore.collection('productsRequest').snapshots();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("E-Store"),
          actions: [
            TextButton(
                onPressed: () {
                  showDialog(context: context, builder: (_) => const CustomAlertBox());
                },
                child: const Text(
                  'Log Out',
                  style: TextStyle(color: Colors.black),
                )),
            const SizedBox(
              width: 10,
            )
          ],
          bottom: TabBar(
            indicatorColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.black,
            overlayColor: MaterialStateProperty.all(Colors.grey[400]),
            dividerColor: Colors.transparent,
            tabs: const [
              Tab(
                text: 'Products',
              ),
              Tab(
                text: 'Requests',
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  ProductTabView(sellingProducts: sellingProducts),
                  RequestTabView(productsRequest: productsRequest),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: width * .45,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                    ),
                    child: CustomButton(
                        text: "Sell a product",
                        onPressed: () {
                          Navigator.pushNamed(
                              context, RoutesName.productSellingFormView);
                        }),
                  ),
                ),
                const VerticalDivider(),
                SizedBox(
                  width: width * .45,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(10),
                    ),
                    child: CustomButton(
                        text: "Request a product",
                        onPressed: () {
                          Navigator.pushNamed(
                              context, RoutesName.requestProductFormView);
                        }),
                  ),
                ),
              ],
            ),],
        ),
      ),
    );
  }
}
