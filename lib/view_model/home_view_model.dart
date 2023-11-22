import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/view/home/bottom_tabs/conversations_tab.dart';
import 'package:e_store/view/home/bottom_tabs/home_tab.dart';
import 'package:e_store/view/home/bottom_tabs/my_ads_tab.dart';
import 'package:e_store/view/home/bottom_tabs/post_form.dart';
import 'package:e_store/view/home/bottom_tabs/settings_tab.dart';
import 'package:flutter/material.dart';

class HomeViewModel with ChangeNotifier{
  int _currentIndex = 0;
  String _query = '';
  String _profileImage = "";
  DocumentSnapshot<Map<String, dynamic>>? _userData;
  List<dynamic> _favoritesList = [];

  get query => _query;
  get profileImage => _profileImage;
  get favoritesList => _favoritesList;
  get userData => _userData;

  setUserData(value){
    _userData = value;
    notifyListeners();
  }

  setFavoritesList(value){
    _favoritesList = value;
    notifyListeners();
  }

  setProfileImage(String value){
    _profileImage = value;
    notifyListeners();
  }

  setQuery(String value){
    _query = value;
    notifyListeners();
  }

  final List<Widget> _tabs = [
    HomeTab(),
    ConversationsTab(),
    // PostTab(),
    PostForm(),
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