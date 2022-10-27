import 'package:flutter/cupertino.dart';

class StoreModel {
  String? id;
  String? name;
  String? buildingId;
  String? brandId;
  String? rate;
  String? closeTime;
  String? openTime;
  String? image;
  String? storeCategoryId;
  String? slogan;
  bool? status;
  String? phone;
  String? updateAt;
  String? createAt;
  Map<String, dynamic>? account;

  StoreModel(
      {this.id,
      this.name,
      this.image,
      this.createAt,
      this.updateAt,
      this.account,
      this.brandId,
      this.buildingId,
      this.closeTime,
      this.openTime,
      this.phone,
      this.rate,
      this.slogan,
      this.status,
      this.storeCategoryId});

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'],
      name: json['name'],
      image: json['image'] != "" && json['image'] != null
          ? json['image']
          : "https://firebasestorage.googleapis.com/v0/b/deliveryfood-9c436.appspot.com/o/food%2Ftopic-2.webp?alt=media&token=54a5086f-f2ea-4009-9479-28624019703e",
      createAt: json['createAt'],
      updateAt: json['updateAt'],
      account: json['account'],
      brandId: json['brandId'],
      buildingId: json['buildingId'],
      closeTime: json['closeTime'],
      openTime: json['openTime'],
      phone: json['phone'],
      rate: json['rate'],
      slogan: json['slogan'],
      status: json['status'],
      storeCategoryId: json['storeCategoryId'],
    );
  }
}
