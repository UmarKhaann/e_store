import 'package:e_store/res/components/custom_button.dart';
import 'package:e_store/utils/routes/routes_name.dart';
import 'package:e_store/utils/utils.dart';
import 'package:e_store/view/home/tabs/selling_tab_view.dart';
import 'package:e_store/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final sellingProducts = fireStore.collection('productsForSale').snapshots();
    final productsRequest = fireStore.collection('productsRequest').snapshots();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("E-Store"),
          actions: [
            TextButton(
                onPressed: () {
                  AuthViewModel.signOutUser();
                  Navigator.pushReplacementNamed(context, RoutesName.loginView);
                  Utils.flushBarMessage(
                      context, 'User logged out successfully');
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
            overlayColor: MaterialStateProperty.all(Colors.grey[300]),
            dividerColor: Colors.transparent,
            tabs: const [
              Tab(
                text: 'Selling',
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
                  SellingTabView(sellingProducts: sellingProducts),
                  StreamBuilder(
                    stream: productsRequest,
                    builder: (context, snapShot) {
                      if (!snapShot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            itemCount: snapShot.data!.docs.length,
                              itemBuilder: (context, child){
                              return const Card(
                                color: Colors.redAccent,
                                child: Column(
                                  children: [
                                    Text('Name'),
                                    Text('time stamp'),
                                    Text('description'),
                                    Text('Image'),
                                  ],
                                ),
                              );
                              })
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: width * .45,
                  child: CustomButton(
                      text: "Sell a product",
                      onPressed: () {
                        Navigator.pushNamed(
                            context, RoutesName.productSellingFormView);
                      }),
                ),
                const VerticalDivider(),
                SizedBox(
                  width: width * .45,
                  child: CustomButton(
                      text: "Request a product",
                      onPressed: () {
                        Navigator.pushNamed(
                            context, RoutesName.requestProductFormView);
                      }),
                ),
              ],
            ),
            const Divider()
          ],
        ),
      ),
    );
  }
}
