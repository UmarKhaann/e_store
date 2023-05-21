import 'package:e_store/res/components/custom_button.dart';
import 'package:e_store/res/components/custom_drawer.dart';
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
        drawer: const CustomDrawer(),
        appBar: AppBar(
          title: const Text("E-Store"),
          actions: [
            IconButton(onPressed: (){
              Navigator.pushNamed(context, RoutesName.chatView);
            }, icon: const Icon(Icons.chat)),
            const SizedBox(
              width: 10,
            )
          ],
          bottom: const TabBar(
            tabs: [
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
                    borderRadius: BorderRadius.circular(3),
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
                    borderRadius: BorderRadius.circular(3),
                    child: CustomButton(
                        text: "Request a product",
                        onPressed: () {
                          Navigator.pushNamed(
                              context, RoutesName.requestProductFormView);
                        }),
                  ),
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
