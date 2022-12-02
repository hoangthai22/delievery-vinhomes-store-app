import 'package:flutter/cupertino.dart';

class OrderReportModel {
  int? totalOrderNew;
  int? totalOrderCancel;
  int? totalOrderCompleted;
  int? totalOrder;

  OrderReportModel({
    required this.totalOrderNew,
    required this.totalOrderCancel,
    required this.totalOrderCompleted,
    required this.totalOrder,
  });

  factory OrderReportModel.fromJson(Map<String, dynamic> json) {
    return OrderReportModel(
      totalOrderCompleted: json['totalOrderCompleted'],
      totalOrder: json['totalOrder'],
      totalOrderCancel: json['totalOrderCancel'],
      totalOrderNew: json['totalOrderNew'],
    );
  }
}
