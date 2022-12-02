class OrderDetailModel {
  String? id;
  String? storeName;
  String? buildingName;

  double? total;
  double? shipCost;
  String? note;
  int? paymentName;
  String? modeId;
  String? time;
  String? dayfilter;
  String? shipperName;
  String? fromHour;
  String? toHour;
  String? shipperPhone;
  List? listProInMenu;
  List? listStatusOrder;
  List? listShipper;

  OrderDetailModel({
    this.id,
    this.storeName,
    this.buildingName,
    this.total,
    this.note,
    this.paymentName,
    this.shipCost,
    this.time,
    this.fromHour,
    this.toHour,
    this.dayfilter,
    this.shipperPhone,
    this.shipperName,
    this.listProInMenu,
    this.modeId,
    this.listStatusOrder,
    this.listShipper,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      id: json['id'],
      storeName: json['storeName'],
      buildingName: json['buildingName'],
      shipperName: json['shipperName'],
      shipperPhone: json['shipperPhone'],
      note: json['note'] ?? "",
      total: json['total'] == null ? 0.0 : json['total'].toDouble(),
      paymentName: json['paymentName'],
      shipCost: json['shipCost'] == null ? 0.0 : json['shipCost'].toDouble(),
      time: json['time'],
      toHour: json['toHour'],
      fromHour: json['fromHour'],
      dayfilter: json['dayfilter'] ?? "",
      modeId: json['modeId'],
      listProInMenu: json['listProInMenu'],
      listStatusOrder: json['listStatusOrder'],
      listShipper: json['listShipper'],
    );
  }
}
