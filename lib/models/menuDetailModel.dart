import 'package:flutter/cupertino.dart';
import 'package:store_app/models/productModel.dart';

class MenuDetailModel {
  String? id;
  String? name;
  String? image;
  List<dynamic>? listProducts;

  MenuDetailModel({
    required this.id,
    required this.name,
    required this.image,
    required this.listProducts,
  });

  factory MenuDetailModel.fromJson(Map<String, dynamic> json) {
    return MenuDetailModel(
      id: json['id'],
      name: json['name'],
      image: json['image'] != "" && json['image'] != null
          ? json['image']
          : "https://firebasestorage.googleapis.com/v0/b/deliveryfood-9c436.appspot.com/o/food%2Ftopic-2.webp?alt=media&token=54a5086f-f2ea-4009-9479-28624019703e",
      listProducts: json['listProducts'],
    );
  }
}
