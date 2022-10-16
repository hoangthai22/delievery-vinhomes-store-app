import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  String userId = "";
  String uid = "";
  String avatar = "";
  bool isLogin = false;

  void setIsLogin() {
    isLogin = true;
    notifyListeners();
  }

  void setAvatar(img) {
    avatar = img;
    notifyListeners();
  }

  void setIsLogout() {
    isLogin = false;
    notifyListeners();
  }

  void setUserLogin(id) {
    userId = id;
    notifyListeners();
  }

  void setUid(id) {
    uid = id;
    notifyListeners();
  }

  bool get getIsLogin => isLogin;
  String get getUserId => userId;
  String get getAvatar => avatar;
  String get getUid => uid;
}
