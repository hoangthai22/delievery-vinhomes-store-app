import 'package:flutter/material.dart';
import 'package:store_app/models/orderModel.dart';
import 'package:store_app/models/storeModel.dart';

class AppProvider with ChangeNotifier {
  String userId = "";
  String uid = "";
  String name = "";
  String avatar = "";
  int countOrder = 0;
  int countOrderMode3 = 0;
  List<OrderModel> orderListMode3 = [];
  late StoreModel storeModel = StoreModel();
  bool status = false;

  void setStatus(bool bool) {
    status = bool;
    notifyListeners();
  }

  void setCountOrder(int count) {
    countOrder = count;
    notifyListeners();
  }

  void setCountOrderMode3(int count) {
    countOrderMode3 = count;
    notifyListeners();
  }

  void setOrderListMode3(List<OrderModel> order) {
    orderListMode3 = order;
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
  int get getCountOrder => countOrder;
  int get getCountOrderMode3 => countOrderMode3;
  List<OrderModel> get getOrderListMode3 => orderListMode3;
  StoreModel get getStoreModel => storeModel;
}
