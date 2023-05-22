import 'package:flutter/material.dart';

import '../../res/components/custom_drawer.dart';

class ConversationsView extends StatelessWidget {
  const ConversationsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text("Chats"),
      ),
    );
  }
}
