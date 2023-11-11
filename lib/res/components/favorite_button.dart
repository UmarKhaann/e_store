import 'package:e_store/repository/home_repo.dart';
import 'package:e_store/view_model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteButton extends StatelessWidget {
  final String productId;
  const FavoriteButton({required this.productId, super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, homeViewModel, child) {
        return IconButton(
          padding: EdgeInsets.zero,
          onPressed: () async {
            HomeRepo.setFavorite(context, productId);
          },
          icon: Icon(homeViewModel.favoritesList.contains(productId)
              ? Icons.favorite_rounded
              : Icons.favorite_border_rounded, color: Colors.red,),
        );
      },
    );
  }
}
