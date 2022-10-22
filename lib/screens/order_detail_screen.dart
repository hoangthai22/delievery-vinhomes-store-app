import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:store_app/apis/apiService.dart';
import 'package:store_app/constants/Theme.dart';
import 'package:store_app/models/orderDetailModel.dart';
import 'package:store_app/models/orderModel.dart';

class ProductOrder {
  String? productInMenuId;
  String? quantity;
  String? productName;
  int? price;

  ProductOrder({
    required this.productInMenuId,
    required this.quantity,
    required this.productName,
    required this.price,
  });

  factory ProductOrder.fromJson(Map<String, dynamic> json) {
    return ProductOrder(
      productInMenuId: json['productInMenuId'],
      quantity: json['quantity'],
      productName: json['productName'],
      price: json['price'] ?? 0,
    );
  }
}

class OrderDetailScreen extends StatefulWidget {
  OrderModel order;
  OrderDetailScreen({Key? key, required this.order}) : super(key: key);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  OrderDetailModel orderDetailModel = OrderDetailModel();
  List<ProductOrder> listProductOrder = [];
  bool isLoading = true;
  getOrderDetail() {
    ApiServices.getOrderDetail(widget.order.id!).then((value) => {
          if (value != null)
            {
              setState(() {
                orderDetailModel = value;
                listProductOrder =
                    orderDetailModel.listProInMenu!.map((dynamic item) {
                  return ProductOrder.fromJson(item);
                }).toList();
                print(listProductOrder.length);
                isLoading = false;
              })
            }
          else
            {isLoading = false}
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrderDetail();
  }

  String getStatusName(status) {
    if (status == "CreateOrder" || status == "ShopAccept") {
      return "Đang chuẩn bị";
    } else if (status == "Shipping") {
      return "Đang giao";
    } else if (status == "Done") {
      return "Hoàn thành";
    } else {
      return "Đã hủy";
    }
  }

  Color? getStatusColor(status) {
    if (status == "CreateOrder" || status == "ShopAccept") {
      return Colors.amber[800];
    } else if (status == "Shipping") {
      return Colors.blueGrey[900];
    } else if (status == "Done") {
      return Colors.green;
    } else {
      return Colors.red[600];
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat('#,##0', 'ID');
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            "Chi tiết đơn hàng",
            style:
                TextStyle(color: MaterialColors.black, fontFamily: "SF Bold"),
          ),
        ),
        body: Stack(
          children: [
            if (!isLoading)
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(children: [
                            Text(
                              "FD-${widget.order.id.toString().substring(0, 4)}",
                              style: const TextStyle(
                                  fontFamily: "SF Bold",
                                  fontSize: 16,
                                  color: Colors.black54),
                            ),
                            const Padding(padding: EdgeInsets.all(5)),
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 5, top: 5),
                              decoration: BoxDecoration(
                                color: getStatusColor(widget.order.statusName),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Text(
                                getStatusName(widget.order.statusName),
                                style: const TextStyle(
                                    fontFamily: "SF SemiBold",
                                    fontSize: 14,
                                    color: Colors.white),
                              ),
                            )
                          ]),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                "5 món ",
                                style: const TextStyle(
                                    fontFamily: "SF Bold",
                                    // fontSize: 14,
                                    color: Colors.black),
                              ),
                              Text(
                                " cho Dương ",
                                style: const TextStyle(
                                    fontFamily: "SF Medium",
                                    // fontSize: 14,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Tài xế sẽ đên vào ",
                            style: const TextStyle(
                                fontFamily: "SF Medium",
                                fontSize: 14,
                                color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Text("Tài xế ",
                          style: const TextStyle(
                              fontFamily: "SF Bold",
                              fontSize: 18,
                              color: Colors.black54)),
                      padding: EdgeInsets.only(
                          left: 15, right: 15, top: 25, bottom: 10),
                    ),
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 15),
                                width: 45,
                                child: Image.asset(
                                  'assets/images/delivery-bike.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width - 190,
                                child: Text("Phạm Văn Dương",
                                    style: const TextStyle(
                                        fontFamily: "SF SemiBold",
                                        fontSize: 16,
                                        color: Colors.black)),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: Color.fromRGBO(120, 120, 120, 1),
                                size: 24,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Icon(
                                Icons.phone_in_talk_outlined,
                                size: 24,
                                color: Color.fromRGBO(120, 120, 120, 1),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Text("Tóm tắt đơn hàng ",
                          style: const TextStyle(
                              fontFamily: "SF Bold",
                              fontSize: 18,
                              color: Colors.black54)),
                      padding: EdgeInsets.only(
                          left: 15, right: 15, top: 25, bottom: 10),
                    ),
                    Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.order.customerName!,
                                style: const TextStyle(
                                    fontFamily: "SF SemiBold",
                                    fontSize: 16,
                                    color: Colors.black87)),
                            Row(
                              children: [
                                Text(widget.order.phone!,
                                    style: const TextStyle(
                                        fontFamily: "SF SemiBold",
                                        fontSize: 14,
                                        color:
                                            Color.fromRGBO(120, 120, 120, 1))),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.phone_in_talk_outlined,
                                  size: 24,
                                  color: Color.fromRGBO(120, 120, 120, 1),
                                ),
                              ],
                            )
                          ],
                        )),
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border:
                                Border(top: BorderSide(color: Colors.black12))),
                        padding: EdgeInsets.all(15),
                        child: Row(
                          children: [
                            Text("Tin nhắn từ khách hàng",
                                style: const TextStyle(
                                    fontFamily: "SF SemiBold",
                                    fontSize: 16,
                                    color: Color.fromRGBO(150, 150, 150, 1))),
                          ],
                        )),
                    Container(
                        padding: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                bottom: BorderSide(color: Colors.black12))),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(15),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(238, 220, 171, 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: Text(
                                        orderDetailModel.note != ""
                                            ? orderDetailModel.note.toString()
                                            : "Không có",
                                        style: const TextStyle(
                                            fontFamily: "SF SemiBold",
                                            fontSize: 15,
                                            color: Colors.black)),
                                  )
                                ],
                              ),
                            )
                          ],
                        )),
                    if (listProductOrder.isNotEmpty)
                      ...listProductOrder.map((e) {
                        return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.only(
                                top: 18, bottom: 18, left: 15, right: 15),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Text("${e.quantity.toString()}",
                                          style: const TextStyle(
                                              fontFamily: "SF Bold",
                                              fontSize: 15,
                                              color: Colors.black)),
                                      Padding(padding: EdgeInsets.all(2)),
                                      Text("x",
                                          style: const TextStyle(
                                              fontFamily: "SF Bold",
                                              fontSize: 15,
                                              color: Color.fromRGBO(
                                                  100, 100, 100, 1))),
                                      Padding(padding: EdgeInsets.all(7)),
                                      Text(e.productName ?? "",
                                          style: const TextStyle(
                                              fontFamily: "SF Bold",
                                              fontSize: 15,
                                              color: Colors.black)),
                                    ],
                                  ),
                                ),
                                Text(
                                    currencyFormatter
                                            .format((e.price!).toInt())
                                            .toString() +
                                        "₫",
                                    style: const TextStyle(
                                        fontFamily: "SF Bold",
                                        fontSize: 15,
                                        color:
                                            Color.fromRGBO(100, 100, 100, 1))),
                              ],
                            ));
                      }),
                    Container(
                      child: Text("Chi tiết thanh toán ",
                          style: const TextStyle(
                              fontFamily: "SF Bold",
                              fontSize: 18,
                              color: Colors.black54)),
                      padding: EdgeInsets.only(
                          left: 15, right: 15, top: 25, bottom: 10),
                    ),
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                bottom: BorderSide(color: Colors.black12))),
                        padding: EdgeInsets.only(
                            left: 15, right: 15, top: 20, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Hình thức thanh toán",
                                style: const TextStyle(
                                    fontFamily: "SF Bold",
                                    fontSize: 15,
                                    color: Colors.black87)),
                            Text(widget.order.paymentName ?? "",
                                style: const TextStyle(
                                    fontFamily: "SF Bold",
                                    fontSize: 15,
                                    color: Colors.black87)),
                          ],
                        )),
                    Container(
                        padding: EdgeInsets.only(
                            left: 15, right: 15, top: 20, bottom: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                bottom: BorderSide(color: Colors.black12))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Tổng cộng",
                                style: const TextStyle(
                                    fontFamily: "SF Bold",
                                    fontSize: 16,
                                    color: Colors.black87)),
                            Text(
                                currencyFormatter
                                        .format((widget.order.total! -
                                                widget.order.shipCost!)
                                            .toInt())
                                        .toString() +
                                    "₫",
                                style: const TextStyle(
                                    fontFamily: "SF Bold",
                                    fontSize: 16,
                                    color: Colors.black87)),
                          ],
                        )),
                    Container(
                      color: Colors.white,
                      height: 50,
                    )
                  ],
                ),
              ),
            if (isLoading)
              SpinKitDualRing(
                color: MaterialColors.primary,
                size: 50.0,
              ),
          ],
        ));
  }
}
