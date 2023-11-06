import 'package:flutter/material.dart';

class VoiceDurationProvider extends ChangeNotifier {
  int _voiceDuration = 0;
  int _positoin = 0;
  bool _isPlayingVoiceMessage = false;

  get voiceDuration => _voiceDuration;
  get position => _positoin;
  get isPlayingVoiceMessage => _isPlayingVoiceMessage;

  setIsPlayingVoiceMessage(bool value){
    _isPlayingVoiceMessage = value;
    notifyListeners();
  }

  setVoiceDuration(voiceDuration) {
    _voiceDuration = voiceDuration;
    notifyListeners();
  }

  resetPosition(){
    _positoin = 0;
    notifyListeners();
  }

  setPosition() {
    _positoin+= 1;
    notifyListeners();
  }
}