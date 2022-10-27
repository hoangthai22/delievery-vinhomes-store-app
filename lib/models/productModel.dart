import 'package:flutter/cupertino.dart';

class ProductModel {
  String? id;
  String? name;
  String? image;
  String? unit;
  double? pricePerPack;
  String? packDescription;
  double? packNetWeight;
  double? maximumQuantity;
  double? minimumQuantity;
  double? minimumDeIn;
  String? description;
  String? storeId;
  String? storeName;
  String? storeImage;
  String? slogan;
  String? categoryId;
  String? productCategory;
  String? createAt;
  String? updateAt;
  double? rate;

  ProductModel({
    this.id,
    this.name,
    this.pricePerPack,
    this.categoryId,
    this.image,
    this.unit,
    this.packDescription,
    this.packNetWeight,
    this.maximumQuantity,
    this.minimumQuantity,
    this.minimumDeIn,
    this.description,
    this.storeId,
    this.storeName,
    this.storeImage,
    this.slogan,
    this.productCategory,
    this.createAt,
    this.updateAt,
    this.rate,
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

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      image: json['image'] != "" && json['image'] != null
          ? json['image']
          : "https://firebasestorage.googleapis.com/v0/b/deliveryfood-9c436.appspot.com/o/food%2Ftopic-2.webp?alt=media&token=54a5086f-f2ea-4009-9479-28624019703e",
      categoryId: json['categoryId'],
      pricePerPack:
          json['pricePerPack'] == null ? 0.0 : json['pricePerPack'].toDouble(),
      unit: json['unit'],
      packDescription: json['packDescription'],
      packNetWeight: json['packNetWeight'] == null
          ? 0.0
          : json['packNetWeight'].toDouble(),
      maximumQuantity: json['maximumQuantity'] == null
          ? 0.0
          : json['maximumQuantity'].toDouble(),
      minimumQuantity: json['minimumQuantity'] == null
          ? 0.0
          : json['minimumQuantity'].toDouble(),
      minimumDeIn:
          json['minimumDeIn'] == null ? 0.0 : json['minimumDeIn'].toDouble(),
      description: json['description'],
      storeId: json['storeId'],
      storeName: json['storeName'],
      storeImage: json['storeImage'],
      slogan: json['slogan'],
      productCategory: json['productCategory'],
      createAt: json['createAt'],
      updateAt: json['updateAt'],
      rate: json['rate'] == null ? 0.0 : json['rate'].toDouble(),
    );
  }
}
