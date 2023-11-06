import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/view/home/tabs/product_tab_view.dart';
import 'package:e_store/view/home/tabs/request_tab_view.dart';
import 'package:e_store/view_model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final TextEditingController searchController = TextEditingController();
  late Future<QuerySnapshot<Map<String, dynamic>>> sellingProducts;
  late Future<QuerySnapshot<Map<String, dynamic>>> productsRequest;

  void searchProducts() async {
    final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    homeViewModel.setQuery(searchController.text);
  }

  void getData() {
    sellingProducts = fireStore
        .collection('products')
        .where('isSellingProduct', isEqualTo: true)
        .get();
    productsRequest = fireStore
        .collection('products')
        .where('isSellingProduct', isEqualTo: false)
        .get();
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        titleSpacing: 0,
        leading: const Icon(Icons.person),
        title: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              hintText: 'What are you looking for?',
              prefixIcon: const Icon(Icons.search),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).canvasColor),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).canvasColor),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (value) {
              searchProducts();
            },
          ),
        ),
      ),
      body: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(
                text: 'Products',
              ),
              Tab(
                text: 'Requests',
              ),
            ],
          ),
          Consumer<HomeViewModel>(
            builder: (context, homeViewModel, child) {
              return Expanded(
                child: TabBarView(
                  children: [
                    ProductTabView(
                      data: {
                        'sellingProducts': sellingProducts,
                        'query': searchController.text
                      },
                    ),
                    RequestTabView(
                      data: {
                        'productsRequest': productsRequest,
                        'query': searchController.text
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
