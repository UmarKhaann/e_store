import 'package:e_store/repository/home_repo.dart';
import 'package:e_store/res/components/custom_card.dart';
import 'package:e_store/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  @override
  void initState() {
    setFavorite();
    super.initState();
  }

  setFavorite() {
    HomeRepo.getIdsOfFavorites().then((value) {
      if (value.isNotEmpty) {
        HomeRepo.getFavorites(value);
      } else {
        HomeRepo.favoriteProducts = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (HomeRepo.favoriteProducts == null)
              const Center(
                  child: Text("There isn't anything selected as Favorites."))
            else
              FutureBuilder(
                future: HomeRepo.favoriteProducts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text("There isn't any Favorite");
                  } else {
                    return Expanded(
                      child: RefreshIndicator(
                        color: Theme.of(context).iconTheme.color,
                        onRefresh: () => setFavorite(),
                        child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    childAspectRatio: 3 / 3.8,
                                    mainAxisSpacing: 10),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return CustomCard(
                                  docs: snapshot.data!.docs[index],
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, RoutesName.productDetailView,
                                        arguments: snapshot.data!.docs[index]);
                                  });
                            }),
                      ),
                    );
                  }
                },
              )
          ],
        ),
      ),
    );
  }
}
