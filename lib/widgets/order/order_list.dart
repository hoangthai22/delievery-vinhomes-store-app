import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:store_app/apis/apiService.dart';
import 'package:store_app/constants/Theme.dart';
import 'package:store_app/constants/Variable.dart';
import 'package:store_app/models/orderModel.dart';
import 'package:store_app/provider/appProvider.dart';

class OrderList extends StatefulWidget {
  String storeId;
  final Function(OrderModel order)? onTap;
  OrderList({Key? key, required this.onTap, required this.storeId})
      : super(key: key);

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  bool isLoading = true;
  List<OrderModel> orderList = [];
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  late StreamSubscription fcmListener;
  void getListOrder() {
    setState(() {
      // menus = [];
      isLoading = true;
    });
    ApiServices.getListOrderByStatus(
            widget.storeId, Status.SHIPPERACCEPT, 1, 50)
        .then((value) => {
              if (value != null)
                {
                  setState(() {
                    orderList = value;
                    context.read<AppProvider>().setCountOrder(orderList.length);
                    isLoading = false;
                  })
                }
              else
                {
                  setState(() {
                    orderList = [];
                    isLoading = false;
                  })
                }
            });
  }

  void registerNotification() async {
    await Firebase.initializeApp();
    messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
        alert: true, badge: true, provisional: false, sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      fcmListener = FirebaseMessaging.onMessage
          .asBroadcastStream()
          .listen((RemoteMessage message) {
        getListOrder();
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
    getListOrder();
  }

  @override
  void dispose() {
    super.dispose();
    print('EVERYTHING disposed');
    fcmListener.cancel();
    // other disposes()
  }

  String getTime(String time) {
    var result = "";
    var day = time.toString().split(" ")[0];
    if (day != null) {
      result =
          "${time.toString().split(" ")[1]}, ${day.toString().split("/")[2]} thg ${day.toString().split("/")[1]}";
    } else {
      result = time;
    }

    return result;
  }

  String changeEndTime(orderTime) {
    var newDateTimeObj = DateFormat().add_yMd().add_Hm().parse(orderTime);
    DateTime customDateTime = DateTime(
        newDateTimeObj.year,
        newDateTimeObj.month,
        newDateTimeObj.day,
        newDateTimeObj.hour,
        newDateTimeObj.minute);
    var start = TimeOfDay.fromDateTime(
        customDateTime.add(const Duration(seconds: 600)));
    var end =
        TimeOfDay.fromDateTime(customDateTime.add(const Duration(minutes: 20)));
    var timeStart = "";
    var timeEnd = "";
    if (start.minute < 10) {
      timeStart = "${start.hour}:0${start.minute}";
    } else {
      timeStart = "${start.hour}:${start.minute}";
    }
    if (end.minute < 10) {
      timeEnd = "${end.hour}:0${end.minute}";
    } else {
      timeEnd = "${end.hour}:${end.minute}";
    }
    return "$timeStart - $timeEnd";
  }

  Future<void> _refreshRandomNumbers() => ApiServices.getListOrderByStatus(
          widget.storeId, Status.SHIPPERACCEPT, 1, 50)
      .then((value) => {
            if (value != null)
              {
                setState(() {
                  orderList = value;
                  context.read<AppProvider>().setCountOrder(orderList.length);
                  isLoading = false;
                })
              }
            else
              {
                setState(() {
                  orderList = [];
                  isLoading = false;
                })
              }
          });
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, provider, child) {
      return Stack(
        children: [
          if (orderList.isNotEmpty)
            RefreshIndicator(
                onRefresh: _refreshRandomNumbers,
                child: Container(
                  padding: EdgeInsets.only(top: 10),
                  child: ListView.builder(
                      itemCount: orderList.length,
                      itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              widget.onTap!(orderList[index]);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 7, top: 7),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 3,
                                    blurRadius: 5,
                                    offset: Offset(
                                        0, 2), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, bottom: 10, top: 10),
                                height: 120,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(children: [
                                              Text(
                                                "FD-${orderList[index].id.toString().substring(0, 4)}",
                                                style: const TextStyle(
                                                    fontFamily: "SF Bold",
                                                    fontSize: 16,
                                                    color: Colors.black54),
                                              ),
                                              const Padding(
                                                  padding: EdgeInsets.all(5)),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    bottom: 5,
                                                    top: 5),
                                                decoration: BoxDecoration(
                                                  color: Status.getStatusColor(
                                                      orderList[index]
                                                          .statusName),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                ),
                                                child: Text(
                                                  Status.getStatusName(
                                                      orderList[index]
                                                          .statusName),
                                                  style: const TextStyle(
                                                      fontFamily: "SF SemiBold",
                                                      fontSize: 14,
                                                      color: Colors.white),
                                                ),
                                              )
                                            ]),
                                            Text(
                                              getTime(orderList[index]
                                                  .time
                                                  .toString()),
                                              style: const TextStyle(
                                                  fontFamily: "SF Regular",
                                                  fontSize: 14,
                                                  color: Colors.black54),
                                            )
                                          ]),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  "3 món",
                                                  style: TextStyle(
                                                      fontFamily: "SF Bold",
                                                      fontSize: 15,
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  " cho ${orderList[index].customerName ?? ""}",
                                                  style: const TextStyle(
                                                      fontFamily: "SF Medium",
                                                      fontSize: 15,
                                                      color: Colors.black),
                                                ),
                                              ]),
                                          const Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            size: 15,
                                            color: Colors.black38,
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Text(
                                              "Tài xế sẽ đến vào ",
                                              style: TextStyle(
                                                  fontFamily: "SF Medium",
                                                  fontSize: 15,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              changeEndTime(
                                                  orderList[index].time),
                                              style: const TextStyle(
                                                  fontFamily: "SF Bold",
                                                  fontSize: 15,
                                                  color: Colors.black),
                                            ),
                                          ]),
                                    ]),
                              ),
                            ),
                          )),
                )),
          if (isLoading)
            Container(
              color: Colors.white.withOpacity(0.5),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SpinKitDualRing(
                color: MaterialColors.primary,
                size: 50.0,
              ),
            ),
          if (!isLoading && orderList.isEmpty)
            Container(
              padding: EdgeInsets.only(top: 50),
              child: Center(
                  child: Column(
                children: [
                  Icon(Icons.shopping_bag_outlined),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Không có đơn hàng nào"),
                ],
              )),
            ),
        ],
      );
    });
  }
}
