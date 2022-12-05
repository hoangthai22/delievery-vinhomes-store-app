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
  int? paymentName;
  int? status;
  String? countProduct;
  String? modeId;
  String? fromHour;
  String? toHour;
  String? time;
  List? listShipper;

  OrderModel({
    required this.id,
    required this.storeName,
    required this.buildingName,
    required this.customerName,
    required this.phone,
    required this.total,
    required this.note,
    required this.status,
    required this.fromHour,
    required this.toHour,
    required this.paymentName,
    required this.shipCost,
    required this.modeId,
    required this.listShipper,
    required this.countProduct,
    required this.time,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      storeName: json['storeName'],
      buildingName: json['buildingName'],
      customerName: json['customerName'],
      phone: json['phone'],
      fromHour: json['fromHour'],
      toHour: json['toHour'],
      countProduct: json['countProduct'],
      note: json['note'],
      total: json['total'] == null ? 0.0 : json['total'].toDouble(),
      status: json['status'],
      modeId: json['modeId'],
      paymentName: json['paymentName'],
      shipCost: json['shipCost'] == null ? 0.0 : json['shipCost'].toDouble(),
      time: json['time'],
      listShipper: json['listShipper'],
    );
  }
}
