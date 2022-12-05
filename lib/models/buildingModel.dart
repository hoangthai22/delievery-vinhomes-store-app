import 'package:flutter/cupertino.dart';

class BuildingModel {
  String? id;
  String? name;

  BuildingModel({
    required this.id,
    required this.name,
  });

  factory BuildingModel.fromJson(Map<String, dynamic> json) {
    return BuildingModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
