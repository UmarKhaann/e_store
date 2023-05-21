import 'package:e_store/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import '../../../res/components/custom_card.dart';

class ProductTabView extends StatelessWidget {
  final Stream sellingProducts;
  const ProductTabView({
    required this.sellingProducts,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: sellingProducts,
      builder: (context, snapShot) {
        if (!snapShot.hasData) {
          return const Center(child: CircularProgressIndicator(color: Colors.black,));
        } else {
          if(snapShot.data!.docs.isEmpty){
            return const Center(child: Text('No Products Available'));
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    childAspectRatio: 3 / 4,
                    mainAxisSpacing: 10),
                itemCount: snapShot.data!.docs.length,
                itemBuilder: (context, index) {
                  final reversedIndex =
                      (snapShot.data!.docs.length - 1) - index;
                  final docs = snapShot.data!.docs[reversedIndex];
                  return CustomCard(docs: docs, onTap: () {
                    Navigator.pushNamed(context, RoutesName.productDetailView, arguments: docs);
                  });
                }),
          );
        }
      },
    );
  }
}
