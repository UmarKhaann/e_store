import 'package:flutter/material.dart';

class VoiceDurationProvider extends ChangeNotifier {
  int _voiceDuration = 0;
  int _positoin = 0;

  get voiceDuration => _voiceDuration;
  get position => _positoin;

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