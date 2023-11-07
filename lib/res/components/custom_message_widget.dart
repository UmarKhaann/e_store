import 'package:e_store/provider/theme_provider.dart';
import 'package:e_store/provider/voice_duration.dart';
import 'package:e_store/repository/chat_repo.dart';
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

  @override
  Widget build(BuildContext context) {
    String storedTime = widget.messages['time'];
    DateTime parsedTime = DateFormat.MMMd().add_jm().parse(storedTime);
    String formattedTime = DateFormat.jm().format(parsedTime);

    return Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
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
                        : themeProvider.isDarkTheme ? Colors.grey[800] : Theme.of(context).cardColor,
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
                            builder: (context, voiceDurationProvider, child) {
                            return Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      voiceDurationProvider.setIsPlayingVoiceMessage(true);
                                      ChatModel.toggleVoiceMessage(
                                          context: context,
                                          fileUrl:
                                              widget.messages['voiceMessage'],
                                          whenFinished: () {
                                            ChatModel.stopVoiceMessage(context);
                                            voiceDurationProvider.setIsPlayingVoiceMessage(false);
                                          });
                                    },
                                    icon: Icon(voiceDurationProvider.isPlayingVoiceMessage
                                        ? Icons.pause
                                        : Icons.play_arrow), color: themeProvider.isDarkTheme? Colors.grey[300]: Colors.black,),
                                Slider(
                                    min: 0,
                                    max: voiceDurationProvider.isPlayingVoiceMessage
                                        ? voiceDurationProvider.voiceDuration.toDouble()
                                        : 0.0,
                                    value: voiceDurationProvider.isPlayingVoiceMessage
                                        ? voiceDurationProvider.position.toDouble()
                                        : 0.0,
                                    onChanged: (value) async {}),
                                if (voiceDurationProvider.isPlayingVoiceMessage) ...[
                                  Text(
                                    voiceDurationProvider.position.toString(),
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                  Text(
                                    "/ ${voiceDurationProvider.voiceDuration.toString()}",
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
