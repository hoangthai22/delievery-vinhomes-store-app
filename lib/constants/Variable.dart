import 'dart:ui';

import 'package:flutter/material.dart';

class Status {
  static const String CREATEORDER = "1";
  static const String SHIPPERACCEPT = "2";
  static const String SHIPPING = "3";
  static const String DONE = "4";
  static const String CANCEL = "5";

  static String getStatusName(status) {
    if (status == "ShopAccept" || status == "ShipAccept") {
      return "Đang chuẩn bị";
    } else if (status == "Shipping") {
      return "Đang giao";
    } else if (status == "Done") {
      return "Hoàn thành";
    } else {
      return "Đã hủy";
    }
  }

  static Color? getStatusColor(status) {
    if (status == "ShopAccept" || status == "ShipAccept") {
      return Colors.amber[800];
    } else if (status == "Shipping") {
      return Colors.blue[900];
    } else if (status == "Done") {
      return Colors.green;
    } else {
      return Colors.red[600];
    }
  }
}
