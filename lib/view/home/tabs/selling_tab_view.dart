import 'package:flutter/material.dart';

import '../../../res/components/custom_card.dart';

class SellingTabView extends StatelessWidget {
  final Stream sellingProducts;
  const SellingTabView({
    required this.sellingProducts,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: sellingProducts,
      builder: (context, snapShot) {
        if (!snapShot.hasData) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
                shrinkWrap: true,
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
                  return CustomCard(docs: docs);
                }),
          );
        }
      },
    );
  }
}
