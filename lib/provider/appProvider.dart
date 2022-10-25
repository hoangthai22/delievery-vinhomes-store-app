import 'package:flutter/material.dart';
import 'package:store_app/models/storeModel.dart';

class AppProvider with ChangeNotifier {
  String userId = "";
  String uid = "";
  String name = "";
  String avatar = "";
  late StoreModel storeModel = StoreModel();
  bool status = false;

  void setStatus(bool bool) {
    status = bool;
    notifyListeners();
  }

  void setStoreModel(StoreModel store) {
    storeModel = store;
    notifyListeners();
  }

  void setAvatar(img) {
    avatar = img;
    notifyListeners();
  }

  // void setIsLogout() {
  //   status = false;
  //   notifyListeners();
  // }

  void setUserLogin(id) {
    userId = id;
    notifyListeners();
  }

  void setUid(id) {
    uid = id;
    notifyListeners();
  }

  void setName(storeName) {
    name = storeName;
    notifyListeners();
  }

  bool get getStatus => status;
  String get getUserId => userId;
  String get getAvatar => avatar;
  String get getUid => uid;
  String get getName => name;
  StoreModel get getStoreModel => storeModel;
}
