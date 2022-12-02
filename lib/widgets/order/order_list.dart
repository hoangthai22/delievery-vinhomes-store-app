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
import 'package:lottie/lottie.dart';

class OrderList extends StatefulWidget {
  String storeId;
  final Function(OrderModel order)? onTap;
  OrderList({Key? key, required this.onTap, required this.storeId}) : super(key: key);

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> with TickerProviderStateMixin {
  bool isLoading = true;
  List<OrderModel> orderList = [];
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  late final AnimationController _controller;
  late StreamSubscription fcmListener;
  void getListOrder() {
    setState(() {
      // menus = [];
      isLoading = true;
    });
    List<OrderModel> newOrderList = [];
    ApiServices.getListOrder0123(widget.storeId, 1, 100).then((value) => {
          if (value != null)
            {
              setState(() {
                orderList = value;
                orderList = orderList.where((element) => element.modeId == "1" || element.modeId == "2").toList();

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

    NotificationSettings settings = await messaging.requestPermission(alert: true, badge: true, provisional: false, sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      fcmListener = FirebaseMessaging.onMessage.asBroadcastStream().listen((RemoteMessage message) {
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
    // _controller = AnimationController(vsync: this, duration: Duration(microseconds: 100));
    // _controller.forward();
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

  Future<void> _refreshRandomNumbers() => ApiServices.getListOrder0123(widget.storeId, 1, 100).then((value) => {
        if (value != null)
          {
            setState(() {
              orderList = value;
              orderList = orderList.where((element) => element.modeId == "1" || element.modeId == "2").toList();
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
                  padding: EdgeInsets.only(top: 5),
                  child: ListView.builder(
                      itemCount: orderList.length,
                      itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              widget.onTap!(orderList[index]);
                            },
                            child: Container(
                                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(3.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 3,
                                      blurRadius: 3,
                                      offset: Offset(0, 2), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Container(
                                  padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 10),
                                  height: 120,
                                  child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: [
                                    Container(
                                      // color:70olors.red,
                                      height: 35,
                                      width: 35,
                                      child: Image.asset(
                                        getIconOrder(orderList[index].modeId),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                                        Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                          Text(
                                            "#${orderList[index].id.toString()}",
                                            style: const TextStyle(fontFamily: "SF Bold", fontSize: 18, color: Colors.black87),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [MaterialColors.primary, Color(0xfff7892b)]),
                                              borderRadius: BorderRadius.circular(4.0),
                                            ),
                                            child: Text(
                                              Status.getStatusName(orderList[index].status),
                                              style: const TextStyle(fontFamily: "SF SemiBold", fontSize: 14, color: Colors.white),
                                            ),
                                          )
                                        ]),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                              Text(
                                                "${orderList[index].countProduct} món",
                                                style: TextStyle(fontFamily: "SF SemiBold", fontSize: 15, color: Colors.black),
                                              ),
                                              Text(
                                                " cho ${orderList[index].customerName ?? ""}",
                                                style: const TextStyle(fontFamily: "SF Regular", fontSize: 15, color: Color.fromRGBO(100, 100, 100, 1)),
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
                                        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                                          const Text(
                                            "Tài xế sẽ đến vào ",
                                            style: TextStyle(fontFamily: "SF Regular", fontSize: 15, color: Color.fromRGBO(100, 100, 100, 1)),
                                          ),
                                          Text(
                                            changeEndTime(orderList[index].time, orderList[index].modeId, orderList[index].fromHour, orderList[index].toHour),
                                            style: const TextStyle(fontFamily: "SF SemiBold", fontSize: 15, color: Colors.black),
                                          ),
                                        ]),
                                      ]),
                                    )
                                  ]),
                                )),
                          )),
                )),
          if (isLoading)
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.white.withOpacity(0.5),
              child: SpinKitDualRing(
                color: MaterialColors.primary,
                size: 45.0,
              ),
            ),
          //  Container(
          //           color: Colors.white.withOpacity(0.5),
          //           // height: MediaQuery.of(context).size.height,
          //           // width: MediaQuery.of(context).size.width,
          //           child: Lottie.network(
          //             'https://lottie.host/c26f1a8a-9e2b-4c39-a81e-3407f7256e75/8SD10Zbrkd.json',
          //             width: 50,
          //             height: 50,
          //             fit: BoxFit.cover,
          //           )),
          //     ),
          if (!isLoading && orderList.isEmpty)
            Container(
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    child: Image.asset(
                      'assets/images/empty-order.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    "Bạn không có đơn hàng nào",
                    style: TextStyle(fontFamily: "SF Regular", fontSize: 16),
                  ),
                ],
              )),
            ),
        ],
      );
    });
  }
}
