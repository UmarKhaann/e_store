import 'package:e_store/utils/routes/routes_name.dart';
import 'package:e_store/view_model/product_detail_model.dart';
import 'package:flutter/material.dart';

class ActionBottomSheet extends StatelessWidget {
  final docs;
  const ActionBottomSheet({
    required this.docs,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          onTap: () => Navigator.pushNamed(context, RoutesName.chatView,
              arguments: docs),
          title: const Text('Chat'),
        ),
        ListTile(
          onTap: () => ProductDetailModel.launchTextMessage(
              phone: docs['phone']),
          title: const Text('SMS'),
        ),
        ListTile(
          onTap: () => ProductDetailModel.launchCall(
              phone: docs['phone']),
          title: const Text('Call'),
        ),
      ],
    );
  }
}
