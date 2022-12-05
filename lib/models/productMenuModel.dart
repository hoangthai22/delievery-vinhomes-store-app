import 'package:flutter/cupertino.dart';

class ProductMenuModel {
  String? id;
  String? name;
  String? image;
  String? unit;
  double? pricePerPack;
  double? minimumDeIn;
  String? packDes;
  String? storeId;
  String? storeName;
  String? productMenuId;

  ProductMenuModel({
    this.id,
    this.name,
    this.pricePerPack,
    this.image,
    this.unit,
    this.minimumDeIn,
    this.storeId,
    this.storeName,
  });

  // String checkImage(String img) {
  //   var image = img;
  //   if (img == null || img == "") {
  //     image =
  //         "https://firebasestorage.googleapis.com/v0/b/lucky-science-341916.appspot.com/o/assets%2FImagesProducts%2Fa9bf8b5b-f24e-4452-92af-bfcd779983ff?alt=media&token=f17ac3db-4684-4e12-9262-98b2c94b2e57";
  //   } else {
  //     image = img;
  //   }
  //   return img;
  // }

  factory ProductMenuModel.fromJson(Map<String, dynamic> json) {
    return ProductMenuModel(
      id: json['id'],
      name: json['name'],
      image: json['image'] != "" && json['image'] != null
          ? json['image']
          : "https://firebasestorage.googleapis.com/v0/b/deliveryfood-9c436.appspot.com/o/food%2Ftopic-2.webp?alt=media&token=54a5086f-f2ea-4009-9479-28624019703e",
      pricePerPack:
          json['pricePerPack'] == null ? 0.0 : json['pricePerPack'].toDouble(),
      unit: json['unit'],
      minimumDeIn:
          json['minimumDeIn'] == null ? 0.0 : json['minimumDeIn'].toDouble(),
      storeId: json['storeId'] ?? "",
      storeName: json['storeName'] ?? "",
    );
  }
}
