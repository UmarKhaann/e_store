import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../../view_model/chat_model.dart';
import 'custom_input_field.dart';
import 'holdable_icon_button.dart';

class SendingMessageWidget extends StatefulWidget {
  final ScrollController scrollController;
  final dynamic productDocs;

  const SendingMessageWidget(
      {required this.scrollController, required this.productDocs, super.key});

  @override
  State<SendingMessageWidget> createState() => _SendingMessageWidgetState();
}

class _SendingMessageWidgetState extends State<SendingMessageWidget> {
  final ValueNotifier<bool> _isTyping = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _onHold = ValueNotifier<bool>(false);
  final TextEditingController _chatController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _onHold.value
            ? Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  width: MediaQuery.of(context).size.width * .75,
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      const Icon(Icons.mic, color: Colors.red),
                      const SizedBox(width: 5),
                      const Text('0:00'),
                      Expanded(child: Container()),
                      Icon(Icons.arrow_back_ios,
                          size: 15, color: Colors.grey[600]),
                      Text(
                        'slide to cancel',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),
              )
            : Expanded(
                child: CustomInputField(
                    onChanged: (value) {
                      _isTyping.value = value.isNotEmpty ? true : false;
                    },
                    circularBorderRadius: 30,
                    hintText: "Type a message",
                    controller: _chatController)),
        const SizedBox(width: 10),
        ValueListenableBuilder(
          valueListenable: _isTyping,
          builder: (context, isTyping, child) {
            return LongPressDraggable(
              data: const Icon(Icons.mic, color: Colors.red),
              feedback: Text('working'),
              child: CircleAvatar(
                radius: 22,
                backgroundColor: Colors.blue,
                child: Center(
                  child: HoldableButton(
                    onTap: () async {
                      if (_isTyping.value == true) {
                        ChatModel.sentChatMessage(
                            message: _chatController.text,
                            productDocs: widget.productDocs);
                        _chatController.clear();
                        _isTyping.value = false;
                      } else {
                        Utils.flushBarMessage(
                            context, 'hold to record, release to send');
                      }
                      widget.scrollController.animateTo(
                          widget.scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInCirc);
                    },
                    onLongPress: () {
                      _onHold.value = true;
                    },
                    onLongPressEnd: (data) {
                      _onHold.value = false;
                    },
                    icon: isTyping
                        ? const Icon(Icons.send)
                        : const Icon(Icons.mic),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
