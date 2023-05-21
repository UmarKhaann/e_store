import 'package:flutter/material.dart';

import '../res/components/custom_drawer.dart';
import '../utils/routes/routes_name.dart';

class ChatView extends StatelessWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text("Chats"),
        actions: [
          IconButton(onPressed: (){
            Navigator.pushNamed(context, RoutesName.chatView);
          }, icon: const Icon(Icons.chat)),
          const SizedBox(
            width: 10,
          )
        ],
      ),
    );
  }
}
