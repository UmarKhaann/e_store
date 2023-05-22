import 'package:e_store/res/components/custom_input_field.dart';
import 'package:flutter/material.dart';
import '../../res/components/custom_drawer.dart';

class ChatView extends StatefulWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController chatController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text("Product Name"),
      ),
      body: Column(
        children: [
          Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomInputField(hintText: "Type a message", controller: chatController),
                ),
                IconButton(onPressed: (){}, icon: const Icon(Icons.send)),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
