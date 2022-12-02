import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:store_app/apis/apiService.dart';
import 'package:store_app/constants/Theme.dart';
import 'package:store_app/constants/Variable.dart';
import 'package:store_app/models/orderModel.dart';
import 'package:store_app/provider/appProvider.dart';

class OrderListMode3 extends StatefulWidget {
  String storeId;
  final Function(OrderModel product)? onTap;
  OrderListMode3({Key? key, required this.onTap, required this.storeId}) : super(key: key);

  @override
  _OrderListMode3State createState() => _OrderListMode3State();
}

class _OrderListMode3State extends State<OrderListMode3> {
  bool isLoading = true;
  List<OrderModel> orderList = [];
  void getListOrder() {
    setState(() {
      // menus = [];
      isLoading = true;
    });

    setState(() {
      orderList = context.read<AppProvider>().getOrderListMode3;
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getListOrder();
  }

  Future<void> _refreshRandomNumbers() => Future.delayed(Duration(milliseconds: 500), () {
        ApiServices.getListOrderByMode(widget.storeId, "3", 1, 100).then((value) => {
              if (value != null)
                {
                  setState(() {
                    orderList = value;
                    context.read<AppProvider>().setOrderListMode3(orderList);
                    context.read<AppProvider>().setCountOrderMode3(orderList.length);
                    isLoading = false;
                  })
                }
              else
                {
                  setState(() {
                    context.read<AppProvider>().setOrderListMode3([]);
                    context.read<AppProvider>().setCountOrderMode3(0);
                    orderList = [];
                    isLoading = false;
                  })
                }
            });
      });

  @override
  Widget build(BuildContext context) {
    // print(getTime("2022/10/13 22:50"));
    final currencyFormatter = NumberFormat('#,##0', 'ID');
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
                                                style: TextStyle(fontFamily: "SF Bold", fontSize: 15, color: Colors.black),
                                              ),
                                              Text(
                                                " cho ${orderList[index].customerName ?? ""}",
                                                style: const TextStyle(fontFamily: "SF Regular", fontSize: 15, color: Colors.black),
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
                                        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                          const Text(
                                            "Đơn hàng đặt trước: ",
                                            style: TextStyle(fontFamily: "SF Regular", fontSize: 15, color: Colors.black),
                                          ),
                                          Text(
                                            getTimeMode3("2022-11-20"),
                                            style: const TextStyle(fontFamily: "SF Bold", fontSize: 15, color: Colors.black),
                                          ),
                                        ]),
                                      ]),
                                    )
                                  ]),
                                )),
                          )),
                )),
          if (isLoading)
            SpinKitDualRing(
              color: MaterialColors.primary,
              size: 45.0,
            ),
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
