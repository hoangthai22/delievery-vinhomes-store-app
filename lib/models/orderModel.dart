import 'package:flutter/cupertino.dart';

class OrderModel {
  String? id;
  String? storeName;
  String? buildingName;
  String? customerName;
  String? phone;
  double? total;
  double? shipCost;
  String? note;
  String? paymentName;
  String? statusName;
  String? time;

  OrderModel({
    required this.id,
    required this.storeName,
    required this.buildingName,
    required this.customerName,
    required this.phone,
    required this.total,
    required this.note,
    required this.statusName,
    required this.paymentName,
    required this.shipCost,
    required this.time,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      storeName: json['storeName'],
      buildingName: json['buildingName'],
      customerName: json['customerName'],
      phone: json['phone'],
      note: json['note'],
      total: json['total'] == null ? 0.0 : json['total'].toDouble(),
      statusName: json['statusName'],
      paymentName: json['paymentName'],
      shipCost: json['shipCost'] == null ? 0.0 : json['shipCost'].toDouble(),
      time: json['time'],
    );
  }
}
