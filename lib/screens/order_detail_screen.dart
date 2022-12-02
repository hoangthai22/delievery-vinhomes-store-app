import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:store_app/apis/apiService.dart';
import 'package:store_app/constants/Theme.dart';
import 'package:store_app/constants/Variable.dart';
import 'package:store_app/models/orderDetailModel.dart';
import 'package:store_app/models/orderModel.dart';
import 'package:url_launcher/url_launcher.dart';

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
  String status = "";
  String shipperName = "---";
  String shipperPhone = "";
  int statusId = 0;
  Color? color;
  bool isLoading = true;
  final GlobalKey<TooltipState> tooltipkey = GlobalKey<TooltipState>();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  late StreamSubscription fcmListener;
  // PushNotificationModel? _notificationInfo;
  // FirebaseFirestore db = FirebaseFirestore.instance;

  getOrderDetail() {
    ApiServices.getOrderDetail(widget.order.id!).then((value) => {
          if (value != null)
            {
              setState(() {
                orderDetailModel = value;
                listProductOrder = orderDetailModel.listProInMenu!.map((dynamic item) {
                  return ProductOrder.fromJson(item);
                }).toList();
                if (orderDetailModel.listShipper!.isNotEmpty) {
                  shipperName = orderDetailModel.listShipper![0]["shipperName"].toString();
                }
                orderDetailModel.listStatusOrder!.map((dynamic item) {
                  statusId = item["status"];
                  // status = Status.getStatusName(item["status"]);
                  // color = Status.getStatusColor(item["status"]);
                }).toList();
                isLoading = false;
              })
            }
          else
            {isLoading = false}
        });
  }

  void registerNotification() async {
    await Firebase.initializeApp();
    messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(alert: true, badge: true, provisional: false, sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      fcmListener = FirebaseMessaging.onMessage.asBroadcastStream().listen((RemoteMessage message) {
        getOrderDetail();
      });
    } else {
      print("not permission");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    registerNotification();

    super.initState();
    getOrderDetail();
  }

  @override
  void dispose() {
    super.dispose();
    print('EVERYTHING disposed');
    fcmListener.cancel();
    // other disposes()
  }

  showModal() {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(8.0))),
        builder: (BuildContext bc) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.27,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
            child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_back_ios,
                      size: 20,
                      color: Colors.black87,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Tại sao bạn hủy đơn?", style: const TextStyle(fontFamily: "SF Bold", fontSize: 18, color: Colors.black87)),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15, top: 10),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, "/cancel-order").then((value) => {getOrderDetail()});
                },
                child: Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Phần lớn các món đều hết", style: const TextStyle(fontFamily: "SF Regular", fontSize: 16, color: Colors.black87)),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 12,
                        color: Colors.black45,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15, top: 15),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Color.fromRGBO(230, 230, 230, 1)))),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, "/cancel-order").then((value) => {getOrderDetail()});
                },
                child: Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Chúng tôi sắp đóng cửa", style: const TextStyle(fontFamily: "SF Regular", fontSize: 16, color: Colors.black87)),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 12,
                        color: Colors.black45,
                      )
                    ],
                  ),
                ),
              ),
            ]),
          );
        });
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    if (phoneNumber != "") {
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: phoneNumber,
      );
      await launchUrl(launchUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat('#,##0', 'ID');

    return Scaffold(
        appBar: AppBar(
            // backgroundColor: Color.fromARGB(255, 255, 255, 255),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: Status.getStatusColor(widget.order.status)!),
              ),
            ),
            toolbarHeight: 65,
            centerTitle: false,
            iconTheme: IconThemeData(
              color: Colors.white, //change your color here
            ),
            elevation: 0,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Đơn hàng #${widget.order.id.toString()}",
                  style: const TextStyle(fontFamily: "SF Bold", fontSize: 16, color: Colors.white),
                ),
                SizedBox(
                  height: 7,
                ),
                Text(
                  Status.getStatusName(widget.order.status),
                  style: const TextStyle(fontFamily: "SF Medium", fontSize: 14, color: Colors.white),
                ),
              ],
            )),
        body: Stack(
          children: [
            if (!isLoading)
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              child: Image.asset(
                                getIconOrder(orderDetailModel.modeId),
                                fit: BoxFit.cover,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(getModeName(orderDetailModel.modeId),
                                          style: const TextStyle(
                                            fontFamily: "SF Medium",
                                            fontSize: 16,
                                            color: Color.fromRGBO(150, 150, 150, 1),
                                          )),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Tooltip(
                                        message: getTooltipMessage(orderDetailModel.modeId),
                                        showDuration: const Duration(seconds: 5),
                                        triggerMode: TooltipTriggerMode.tap,
                                        child: Icon(
                                          Icons.info_outline,
                                          color: Colors.black38,
                                          size: 14,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Text(
                                      getModeMessage(orderDetailModel.listStatusOrder ?? [], widget.order.status!, orderDetailModel.modeId!, orderDetailModel.dayfilter!, orderDetailModel.time!,
                                          orderDetailModel.fromHour!, orderDetailModel.toHour!),
                                      style: const TextStyle(fontFamily: "SF Bold", fontSize: 15, color: Colors.black87)),
                                ],
                              ),
                              flex: 1,
                            )
                          ],
                        )),
                    Container(
                      // child: Text("Thông tin người nhận ",
                      //     style: const TextStyle(
                      //         fontFamily: "SF SemiBold",
                      //         fontSize: 17,
                      //         color: Colors.black54)),
                      padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 10),
                    ),
                    Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.account_circle_rounded,
                                  color: Color.fromRGBO(200, 200, 200, 1),
                                  size: 35,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.order.customerName!, style: const TextStyle(fontFamily: "SF SemiBold", fontSize: 16, color: Colors.black87)),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text("Người nhận", style: const TextStyle(fontFamily: "SF Regular", fontSize: 14, color: Color.fromRGBO(180, 180, 180, 1)))
                                  ],
                                )
                              ],
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    _makePhoneCall(widget.order.phone ?? "");
                                  },
                                  child: Icon(
                                    Icons.phone_in_talk_outlined,
                                    size: 24,
                                    color: Colors.green,
                                  ),
                                )
                              ],
                            )
                          ],
                        )),
                    Container(
                        decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.black12))),
                        padding: EdgeInsets.all(15),
                        child: Row(
                          children: [
                            Text("Tin nhắn từ khách hàng", style: const TextStyle(fontFamily: "SF SemiBold", fontSize: 16, color: Color.fromRGBO(150, 150, 150, 1))),
                          ],
                        )),
                    Container(
                        padding: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
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
                                    child: Text(orderDetailModel.note != "" ? orderDetailModel.note.toString() : "Không có",
                                        style: const TextStyle(fontFamily: "SF SemiBold", fontSize: 15, color: Colors.black)),
                                  )
                                ],
                              ),
                            )
                          ],
                        )),
                    Container(
                      // child: Text("Tóm tắt đơn hàng ",
                      //     style: const TextStyle(
                      //         fontFamily: "SF SemiBold",
                      //         fontSize: 17,
                      //         color: Colors.black54)),
                      padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 10),
                    ),
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                bottomLeft: Radius.circular(50),
                                topRight: Radius.circular(50),
                                bottomRight: Radius.circular(50),
                              ),

                              // padding: const EdgeInsets.only(right: 15, left: 0),
                              child: Container(
                                height: 30,
                                width: 30,
                                child: Image.asset(
                                  'assets/images/danhsachmon.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text("Danh sách món", style: const TextStyle(color: MaterialColors.black, fontFamily: "SF Bold", fontSize: 16)),
                          ),
                        ],
                      ),
                    ),
                    if (listProductOrder.isNotEmpty)
                      ...listProductOrder.map((e) {
                        return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.only(top: 18, bottom: 18, left: 22, right: 15),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Text("${e.quantity.toString()}", style: const TextStyle(fontFamily: "SF Medium", fontSize: 16, color: Colors.black)),
                                      Padding(padding: EdgeInsets.all(2)),
                                      Text("x", style: const TextStyle(fontFamily: "SF Medium", fontSize: 16, color: Color.fromRGBO(100, 100, 100, 1))),
                                      Padding(padding: EdgeInsets.all(5)),
                                      Text(e.productName ?? "", style: const TextStyle(fontFamily: "SF Medium", fontSize: 16, color: Colors.black)),
                                    ],
                                  ),
                                ),
                                Text(currencyFormatter.format((e.price!).toInt()).toString() + "₫", style: const TextStyle(fontFamily: "SF Medium", fontSize: 16, color: Colors.black)),
                              ],
                            ));
                      }),
                    // Container(
                    //     decoration: BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Colors.black12), top: BorderSide(color: Colors.black12))),
                    //     padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Text("Hình thức thanh toán", style: const TextStyle(fontFamily: "SF Bold", fontSize: 15, color: Colors.black87)),
                    //         Row(
                    //           crossAxisAlignment: CrossAxisAlignment.center,
                    //           children: [
                    //             Container(margin: EdgeInsets.only(right: 10), width: 20, child: Image.asset(widget.order.paymentName == 0 ? "assets/images/cash.png" : "assets/images/vnpay.png")),
                    //             Text(widget.order.paymentName == 0 ? "Tiền mặt" : "VN Pay", style: const TextStyle(fontFamily: "SF Bold", fontSize: 15, color: Colors.black87)),
                    //           ],
                    //         )
                    //       ],
                    //     )),
                    Container(
                        decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.black12))),
                        padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Tổng cộng", style: const TextStyle(fontFamily: "SF Bold", fontSize: 16, color: Colors.black87)),
                            Text(currencyFormatter.format((widget.order.total!).toInt()).toString() + "₫", style: const TextStyle(fontFamily: "SF Bold", fontSize: 18, color: Colors.green)),
                          ],
                        )),
                    Container(
                      // child: Text("Tài xế ",
                      //     style: const TextStyle(
                      //         fontFamily: "SF SemiBold",
                      //         fontSize: 17,
                      //         color: Colors.black54)),
                      padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 10),
                    ),
                    Container(
                      color: Colors.white,
                      // decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     border: Border(
                      //         bottom: BorderSide(color: Colors.black12))),
                      padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 15),
                                width: 30,
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  child: Image.asset(
                                    'assets/images/taixe.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(shipperName, style: const TextStyle(fontFamily: "SF SemiBold", fontSize: 16, color: Colors.black87)),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text("Tài xế", style: const TextStyle(fontFamily: "SF Regular", fontSize: 14, color: Color.fromRGBO(180, 180, 180, 1)))
                                ],
                              )
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              _makePhoneCall(orderDetailModel.shipperPhone ?? "0");
                            },
                            child: Icon(
                              Icons.phone_in_talk_outlined,
                              size: 24,
                              color: Colors.green,
                            ),
                          )
                        ],
                      ),
                    ),
                    // if (statusId == 0 || statusId == 1 || statusId == 2 || statusId == 3) ...[
                    //   Container(
                    //     padding: EdgeInsets.only(bottom: 25, top: 25),
                    //     // height: 100,

                    //     child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                    //       InkWell(
                    //         onTap: () {
                    //           showModal();
                    //         },
                    //         child: Column(
                    //           children: [
                    //             Icon(
                    //               Icons.cancel_outlined,
                    //               size: 28,
                    //               color: Colors.red[800],
                    //             ),
                    //             SizedBox(
                    //               height: 5,
                    //             ),
                    //             Text("Hủy đơn",
                    //                 style: TextStyle(
                    //                   fontFamily: "SF Medium",
                    //                   fontSize: 16,
                    //                   color: Colors.red[800],
                    //                 ))
                    //           ],
                    //         ),
                    //       ),
                    //       Column(
                    //         children: [
                    //           Icon(
                    //             Icons.help_outline,
                    //             size: 28,
                    //             color: Color.fromRGBO(100, 100, 100, 1),
                    //           ),
                    //           SizedBox(
                    //             height: 5,
                    //           ),
                    //           Text(
                    //             "Trợ giúp",
                    //             style: TextStyle(
                    //               fontFamily: "SF Medium",
                    //               fontSize: 16,
                    //               color: Color.fromRGBO(100, 100, 100, 1),
                    //             ),
                    //           )
                    //         ],
                    //       ),
                    //     ]),
                    //   ),
                    // ],
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            if (isLoading)
              SpinKitDualRing(
                color: MaterialColors.primary,
                size: 45.0,
              ),
          ],
        ));
  }
}
