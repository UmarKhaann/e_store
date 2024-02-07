import 'package:e_store/repository/home_repo.dart';
import 'package:e_store/res/components/custom_input_field.dart';
import 'package:e_store/utils/routes/routes_name.dart';
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
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String? image = HomeRepo.auth.currentUser != null ? HomeRepo.auth.currentUser!.photoURL : null;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        titleSpacing: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pushNamed(context, RoutesName.profileView);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).cardColor,
              backgroundImage: image == null ? null : NetworkImage(image),
              child: image == null ? const Icon(Icons.person) : null,
            ),
          ),
        ),
        title: CustomInputField(
          controller: searchController,
          hintText: 'What are you looking for?',
          icon: Icons.search,
          suffixIcon:
              IconButton(onPressed: () {}, icon: const Icon(Icons.filter_alt)),
          onChanged: (value) {
            HomeRepo.searchProducts(context, searchController.text);
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, RoutesName.favoritesView);
            },
            icon: const Icon(Icons.favorite_rounded),
            padding: EdgeInsets.zero,
          ),
        ],
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
                      data: {'query': searchController.text},
                    ),
                    RequestTabView(
                      data: {'query': searchController.text},
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
