import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/view/home/bottom_tabs/conversations_tab.dart';
import 'package:e_store/view/home/bottom_tabs/home_tab.dart';
import 'package:e_store/view/home/bottom_tabs/my_ads_tab.dart';
import 'package:e_store/view/home/bottom_tabs/post_form.dart';
import 'package:e_store/view/home/bottom_tabs/settings_tab.dart';
import 'package:flutter/material.dart';

class HomeViewModel with ChangeNotifier {
  int _currentIndex = 0;
  String _query = '';
  DocumentSnapshot<Map<String, dynamic>>? _userData;
  List<dynamic> _favoritesList = [];
  
  final List<Widget> _tabs = [
    const HomeTab(),
    const ConversationsTab(),
    const PostForm(),
    const MyPostsTab(),
    SettingsTab(),
  ];

  get query => _query;
  get favoritesList => _favoritesList;
  get userData => _userData;
  get currentIndex => _currentIndex;
  get tabs => _tabs;

  setUserData(value) {
    _userData = value;
    notifyListeners();
  }

  setFavoritesList(value) {
    _favoritesList = value;
    notifyListeners();
  }

  setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  setCurrentIndex(int currentIndex) {
    _currentIndex = currentIndex;
    notifyListeners();
  }
}
