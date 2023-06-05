import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../utils/utils.dart';
import '../../view_model/chat_model.dart';
import 'custom_input_field.dart';
import 'holdable_icon_button.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
  String voiceChatId = '';
  final TextEditingController _chatController = TextEditingController();
  final FlutterSoundRecorder voiceRecorder = FlutterSoundRecorder();


  Future startRecording()async{
    voiceChatId = DateTime.now().microsecondsSinceEpoch.toString();
    await voiceRecorder.startRecorder(
      toFile: voiceChatId,
    );
    print('recording started');
  }

  Future stopRecording()async{
    final path = await voiceRecorder.stopRecorder();
    final audioPath = File(path!);
    print('recording stopped');
    return audioPath;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _chatController.dispose();
    voiceRecorder.closeRecorder();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initRecorder();
  }

  Future initRecorder()async{
    final status = await Permission.microphone.request();

    if(status != PermissionStatus.granted){
      throw RecordingPermissionException('Microphone permission not granted');
    }
    await voiceRecorder.openRecorder();
    voiceRecorder.setSubscriptionDuration(const Duration(milliseconds: 500));
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
                  child: StreamBuilder<RecordingDisposition>(
                    stream: voiceRecorder.onProgress,
                    builder: (context, snapshot){
                      final duration = snapshot.hasData ? snapshot.data!.duration : Duration.zero;
                      String twoDigits(int n) => n.toString().padLeft(2, '0');
                      final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
                      final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
                      return Row(
                        children: [
                          const SizedBox(width: 10),
                          const Icon(Icons.mic, color: Colors.red),
                          const SizedBox(width: 5),
                          Text('$twoDigitMinutes : $twoDigitSeconds'),
                          Expanded(child: Container()),
                          Icon(Icons.arrow_back_ios,
                              size: 15, color: Colors.grey[600]),
                          Text(
                            'slide to cancel',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(width: 20),
                        ],
                      );
                    },
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
            return CircleAvatar(
              radius: 22,
              backgroundColor: Colors.blue,
              child: Center(
                child: HoldableButton(
                  onTap: () async {
                    if (_isTyping.value == true) {
                      ChatModel.sentChatMessage(
                        isVoiceMessage: false,
                          message: _chatController.text,
                          productDocs: widget.productDocs);
                      _chatController.clear();
                      _isTyping.value = false;
                      widget.scrollController.animateTo(
                          widget.scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInCirc);
                    } else {
                      Utils.toastMessage('hold to record, release to send');
                    }
                  },
                  onLongPress: () async{
                    _onHold.value = true;
                      await startRecording();
                  },
                  onLongPressEnd: (data) async{
                    _onHold.value = false;
                    final path = await stopRecording();
                    Reference storageReference = FirebaseStorage.instance.ref().child('voiceMessages/$voiceChatId');
                    UploadTask uploadTask = storageReference.putFile(path);
                    uploadTask.whenComplete(() async{
                      final voiceMessageUrl = await storageReference.getDownloadURL();
                      ChatModel.sentChatMessage(
                          isVoiceMessage: true,
                          message: voiceMessageUrl,
                          productDocs: widget.productDocs);
                    }).then((value) { Utils.flushBarMessage(context, 'voice message send successfully');
                    });
                  },
                  icon: isTyping
                      ? const Icon(Icons.send)
                      : const Icon(Icons.mic),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}