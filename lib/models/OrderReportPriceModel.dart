import 'package:flutter/cupertino.dart';

class OrderReportPriceModel {
  double? totalOrder;
  double? totalPaymentCash;
  double? totalRevenueOrder;
  double? totalProfitOrder;

  OrderReportPriceModel({
    required this.totalOrder,
    required this.totalPaymentCash,
    required this.totalRevenueOrder,
    required this.totalProfitOrder,
  });

  factory OrderReportPriceModel.fromJson(Map<String, dynamic> json) {
    return OrderReportPriceModel(
      totalOrder: json['totalOrder'] == null ? 0.0 : json['totalOrder'].toDouble(),
      totalPaymentCash: json['totalPaymentCash'] == null ? 0.0 : json['totalPaymentCash'].toDouble(),
      totalRevenueOrder: json['totalRevenueOrder'] == null ? 0.0 : json['totalRevenueOrder'].toDouble(),
      totalProfitOrder: json['totalProfitOrder'] == null ? 0.0 : json['totalProfitOrder'].toDouble(),
    );
  }
}
