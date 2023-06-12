import 'package:e_store/provider/voice_duration.dart';
import 'package:e_store/view_model/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CustomMessageWidget extends StatefulWidget {
  final dynamic messages;
  final bool meCurrUser;

  const CustomMessageWidget(
      {required this.messages, required this.meCurrUser, super.key});

  @override
  State<CustomMessageWidget> createState() => _CustomMessageWidgetState();
}

class _CustomMessageWidgetState extends State<CustomMessageWidget> {
  ValueNotifier<bool> isPlayingVoiceMessage = ValueNotifier(false);

  @override
  void dispose() {
    // TODO: implement dispose
    isPlayingVoiceMessage.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String storedTime = widget.messages['time'];
    DateTime parsedTime = DateFormat.MMMd().add_jm().parse(storedTime);
    String formattedTime = DateFormat.jm().format(parsedTime);

    return ValueListenableBuilder(
        valueListenable: isPlayingVoiceMessage,
        builder: (context, value, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Align(
              alignment:
                  widget.meCurrUser ? Alignment.topRight : Alignment.topLeft,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: widget.meCurrUser
                        ? Colors.blue
                        : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(15),
                        topRight: const Radius.circular(15),
                        bottomLeft: Radius.circular(widget.meCurrUser ? 15 : 0),
                        bottomRight:
                            Radius.circular(widget.meCurrUser ? 0 : 15))),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    widget.messages['message'] != null
                        ? Flexible(
                            child: Text('${widget.messages['message']}'),
                          )
                        : Consumer<VoiceDurationProvider>(
                            builder: (context, value, child) {
                            return Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      isPlayingVoiceMessage.value =
                                          !isPlayingVoiceMessage.value;
                                      ChatModel.toggleVoiceMessage(
                                          context: context,
                                          fileUrl:
                                              widget.messages['voiceMessage'],
                                          whenFinished: () {
                                            ChatModel.stopVoiceMessage(context);
                                            isPlayingVoiceMessage.value = false;
                                          });
                                    },
                                    icon: Icon(isPlayingVoiceMessage.value
                                        ? Icons.pause
                                        : Icons.play_arrow)),
                                Slider(
                                    min: 0,
                                    max: isPlayingVoiceMessage.value
                                        ? value.voiceDuration.toDouble()
                                        : 0.0,
                                    value: isPlayingVoiceMessage.value
                                        ? value.position.toDouble()
                                        : 0.0,
                                    onChanged: (value) async {}),
                                if (isPlayingVoiceMessage.value) ...[
                                  Text(
                                    value.position.toString(),
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                  Text(
                                    "/ ${value.voiceDuration.toString()}",
                                    style: const TextStyle(fontSize: 10),
                                  )
                                ]
                              ],
                            );
                          }),
                    if (widget.messages['message'] != null)
                      const SizedBox(width: 10),
                    Text(
                      formattedTime,
                      style: const TextStyle(fontSize: 10),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
