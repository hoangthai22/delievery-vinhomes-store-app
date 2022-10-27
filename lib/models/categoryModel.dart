import 'package:flutter/cupertino.dart';

class CategoryModel {
  String? id;
  String? name;
  String? image;
  String? createAt;
  String? updateAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.createAt,
    required this.updateAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      image: json['image'] != "" && json['image'] != null
          ? json['image']
          : "https://firebasestorage.googleapis.com/v0/b/deliveryfood-9c436.appspot.com/o/food%2Ftopic-2.webp?alt=media&token=54a5086f-f2ea-4009-9479-28624019703e",
      createAt: json['createAt'],
      updateAt: json['updateAt'],
    );
  }
}
