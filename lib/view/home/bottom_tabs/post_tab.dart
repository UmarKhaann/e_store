import 'package:e_store/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';

class PostTab extends StatelessWidget {
  const PostTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              child: ListTile(
                onTap: () {
                  Navigator.pushNamed(
                      context, RoutesName.productSellingFormView);
                },
                title: const Text('Sell a product'),
              ),
            ),
            Card(
              child: ListTile(
                onTap: () {
                  Navigator.pushNamed(
                      context, RoutesName.requestProductFormView);
                },
                title: const Text('Request a product'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
