import 'package:flutter/cupertino.dart';

class MenuModel {
  String? id;
  String? name;
  String? image;
  double? startTime;
  double? endTime;
  String? listCategoryStoreInMenus;

  MenuModel({
    required this.id,
    required this.name,
    required this.image,
    required this.startTime,
    required this.endTime,
    required this.listCategoryStoreInMenus,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      id: json['id'],
      name: json['name'],
      image: json['image'] != "" && json['image'] != null
          ? json['image']
          : "https://firebasestorage.googleapis.com/v0/b/deliveryfood-9c436.appspot.com/o/food%2Ftopic-2.webp?alt=media&token=54a5086f-f2ea-4009-9479-28624019703e",
      startTime: json['startTime'] == null ? 0.0 : json['startTime'].toDouble(),
      endTime: json['endTime'] == null ? 0.0 : json['endTime'].toDouble(),
      listCategoryStoreInMenus:
          json['listCategoryStoreInMenus'] == null ? "" : "",
    );
  }
}
