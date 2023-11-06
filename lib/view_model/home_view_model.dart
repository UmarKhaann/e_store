import 'package:e_store/view/home/bottom_tabs/conversations_tab.dart';
import 'package:e_store/view/home/bottom_tabs/home_tab.dart';
import 'package:e_store/view/home/bottom_tabs/my_ads_tab.dart';
import 'package:e_store/view/home/bottom_tabs/post_tab.dart';
import 'package:e_store/view/home/bottom_tabs/settings_tab.dart';
import 'package:flutter/material.dart';

class HomeViewModel with ChangeNotifier{
  int _currentIndex = 0;
  
  String _query = '';

  get query => _query;

  setQuery(String value){
    _query = value;
    notifyListeners();
  }

  final List<Widget> _tabs = [
    HomeTab(),
    ConversationsTab(),
    PostTab(),
    MyAdsTap(),
    SettingsTab(),
  ];

  get currentIndex => _currentIndex;

  setCurrentIndex(int currentIndex){
    _currentIndex = currentIndex;
    notifyListeners();
  }

  get tabs => _tabs;
}