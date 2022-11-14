class OrderDetailModel {
  String? id;
  String? storeName;
  String? buildingName;

  double? total;
  double? shipCost;
  String? note;
  String? paymentName;
  String? modeId;
  String? time;
  List? listProInMenu;
  List? listStatusOrder;

  OrderDetailModel({
    this.id,
    this.storeName,
    this.buildingName,
    this.total,
    this.note,
    this.paymentName,
    this.shipCost,
    this.time,
    this.listProInMenu,
    this.modeId,
    this.listStatusOrder,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      id: json['id'],
      storeName: json['storeName'],
      buildingName: json['buildingName'],
      note: json['note'] ?? "",
      total: json['total'] == null ? 0.0 : json['total'].toDouble(),
      paymentName: json['paymentName'],
      shipCost: json['shipCost'] == null ? 0.0 : json['shipCost'].toDouble(),
      time: json['time'],
      modeId: json['modeId'],
      listProInMenu: json['listProInMenu'],
      listStatusOrder: json['listStatusOrder'],
    );
  }
}
