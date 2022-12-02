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
import 'package:store_app/models/orderReportModel.dart';
import 'package:store_app/provider/appProvider.dart';
import 'package:store_app/screens/order_detail_screen.dart';

class OrderHistoryScreen extends StatefulWidget {
  OrderHistoryScreen({
    Key? key,
  }) : super(key: key);

  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List<OrderModel> orderListDone = [];
  List<OrderModel> orderListDoneToday = [];
  late OrderReportModel orderReportModel = OrderReportModel(totalOrderNew: 0, totalOrderCancel: 0, totalOrderCompleted: 0, totalOrder: 0);
  bool isLoading = true;
  late bool isListFull = false;
  late int page = 1;
  void getListOrder(storeId) {
    setState(() {
      isLoading = true;
    });
    List<OrderModel> orderListTmp = [];
    var now = DateTime.now();
    var inputFormat = DateFormat('yyyy-MM-ddTHH:mm:ss');
    var outputFormatEnd = DateFormat('dd/MM/yyyy');
    DateTime inputDate;
    String outputDateTime;
    ApiServices.getListOrderDone(storeId, 1, 100).then((ordersDone) => {
          if (ordersDone != null)
            {
              orderListTmp = ordersDone,
              orderListTmp
                  .map((e) => {
                        inputDate = inputFormat.parse(e.time!),
                        print(e.status),
                        outputDateTime = outputFormatEnd.format(inputDate),
                        if (outputDateTime.toString() == "${now.day.toString()}/${now.month.toString()}/${now.year.toString()}")
                          {
                            setState(() {
                              orderListDoneToday = [...orderListDoneToday, e];
                            }),
                          }
                        else
                          {
                            setState(() {
                              orderListDone = [...orderListDone, e];
                            }),
                          }
                      })
                  .toList(),
              setState(() {
                isLoading = false;
              }),
            }
          else
            {
              setState(() {
                orderListDone = [];
                isLoading = false;
              })
            }
        });
  }

  void getOrderReport(storeId) {
    setState(() {
      isLoading = true;
    });

    ApiServices.getOrderReports(storeId, "")
        .then((ordersReport) => {
              if (ordersReport != null)
                {
                  setState(() {
                    orderReportModel = ordersReport;
                  })
                }
              else
                {
                  setState(() {
                    isLoading = false;
                  })
                }
            })
        .then((value) => {getListOrder(storeId)});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var storeId = context.read<AppProvider>().getUserId;
    getOrderReport(storeId);
  }

  String getTime(String time) {
    var inputFormat = DateFormat('yyyy-MM-ddTHH:mm:ss');
    var inputDate = inputFormat.parse(time);
    var outputFormat = DateFormat('hh:mm a dd/MM/yyyy');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat('#,##0', 'ID');
    return Consumer<AppProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: new AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [MaterialColors.primary, Color(0xfff7892b)]),
            ),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: Text(
            "Lịch sử đơn hàng",
            style: TextStyle(
              color: MaterialColors.white,
              fontFamily: "SF Bold",
            ),
          ),
        ),
        body: Stack(children: [
          SingleChildScrollView(
              child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 15,
                ),
                if (!isLoading)
                  Container(
                    padding: EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                    color: Colors.white,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.only(bottom: 15, top: 15),
                              decoration: BoxDecoration(border: Border(right: BorderSide(color: Color.fromRGBO(245, 245, 245, 1), width: 1))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    orderReportModel.totalOrderCompleted.toString(),
                                    style: TextStyle(fontFamily: "SF Bold", fontSize: 18, color: Color.fromRGBO(50, 50, 50, 1)),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Đơn hàng hoàn tất",
                                    style: TextStyle(fontFamily: "SF Regular", fontSize: 15, color: Color.fromRGBO(50, 50, 50, 1)),
                                  )
                                ],
                              ),
                            )),
                        Expanded(
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(orderReportModel.totalOrderCancel.toString(), style: TextStyle(fontFamily: "SF Bold", fontSize: 18, color: Color.fromRGBO(50, 50, 50, 1))),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Đơn đã hủy",
                                  style: TextStyle(fontFamily: "SF Regular", fontSize: 15, color: Color.fromRGBO(50, 50, 50, 1)),
                                )
                              ],
                            ),
                            padding: EdgeInsets.only(left: 15, bottom: 15, top: 15),
                          ),
                          flex: 1,
                        ),
                      ],
                    ),
                  ),
                SizedBox(
                  height: 15,
                ),
                if (orderListDoneToday.isNotEmpty)
                  Container(
                    padding: EdgeInsets.only(left: 15, bottom: 10, top: 5),
                    child: Text(
                      "Hôm nay",
                      style: TextStyle(fontFamily: "SF SemiBold", fontSize: 17, color: Color.fromRGBO(150, 150, 150, 1)),
                    ),
                  ),
                ...orderListDoneToday.map((OrderModel order) {
                  var index = orderListDoneToday.indexOf(order);
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailScreen(order: order),
                        ),
                      );
                    },
                    child: Container(
                      // margin: const EdgeInsets.only(
                      //   left: 10,
                      //   right: 10,
                      // ),
                      decoration: BoxDecoration(color: Colors.white, border: index != orderListDoneToday.length - 1 ? Border(bottom: BorderSide(color: Colors.black12, width: 1)) : null),
                      child: Container(
                        padding: EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 10),
                        height: 115,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                          Container(
                            child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Text(
                                '#${order.id.toString()}',
                                style: TextStyle(fontFamily: "SF SemiBold", fontSize: 17, color: Color.fromRGBO(50, 50, 50, 1)),
                              )
                            ]),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                  Text(
                                    Status.getStatusName(order.status).toString(),
                                    style: TextStyle(fontFamily: "SF Bold", fontSize: 16, color: Status.getStatusColorText(order.status)),
                                  ),
                                ]),
                              ),
                              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                Text(
                                  "${currencyFormatter.format((order.total! - order.shipCost!).toInt())}₫",
                                  style: const TextStyle(fontFamily: "SF Bold", fontSize: 17, color: Colors.black),
                                ),
                                const Padding(padding: EdgeInsets.all(5)),
                                const Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  size: 15,
                                  color: Colors.black38,
                                )
                              ]),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            "${order.status == 5 ? "Đã giao" : Status.getStatusName(order.status)} lúc ${getTime(order.time.toString())}",
                            style: TextStyle(fontFamily: "SF Medium", fontSize: 15, color: Colors.black38),
                          ),
                        ]),
                      ),
                    ),
                  );
                }),
                if (orderListDone.isNotEmpty)
                  Container(
                    padding: EdgeInsets.only(left: 15, bottom: 10, top: 25),
                    child: Text(
                      "Cũ hơn",
                      style: TextStyle(fontFamily: "SF SemiBold", fontSize: 17, color: Color.fromRGBO(150, 150, 150, 1)),
                    ),
                  ),
                ...orderListDone.map((OrderModel order) {
                  var index = orderListDone.indexOf(order);
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailScreen(order: order),
                        ),
                      );
                    },
                    child: Container(
                      // margin: const EdgeInsets.only(
                      //   left: 10,
                      //   right: 10,
                      // ),
                      decoration: BoxDecoration(color: Colors.white, border: index != orderListDone.length - 1 ? Border(bottom: BorderSide(color: Colors.black12, width: 1)) : null),
                      child: Container(
                        padding: EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 10),
                        height: 115,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                          Container(
                            child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Text(
                                '#${order.id.toString()}',
                                style: TextStyle(fontFamily: "SF SemiBold", fontSize: 17, color: Color.fromRGBO(50, 50, 50, 1)),
                              )
                            ]),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                  Text(
                                    Status.getStatusName(order.status).toString(),
                                    style: TextStyle(fontFamily: "SF Bold", fontSize: 16, color: Status.getStatusColorText(order.status)),
                                  ),
                                ]),
                              ),
                              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                Text(
                                  "${currencyFormatter.format((order.total! - order.shipCost!).toInt())}₫",
                                  style: const TextStyle(fontFamily: "SF Bold", fontSize: 17, color: Colors.black),
                                ),
                                const Padding(padding: EdgeInsets.all(5)),
                                const Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  size: 15,
                                  color: Colors.black38,
                                )
                              ]),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            "${order.status == 5 ? "Đã giao" : Status.getStatusName(order.status)} lúc ${getTime(order.time.toString())}",
                            style: TextStyle(fontFamily: "SF Medium", fontSize: 15, color: Colors.black38),
                          ),
                        ]),
                      ),
                    ),
                  );
                }),
              ],
            ),
          )),
          if (isLoading)
            SpinKitDualRing(
              color: MaterialColors.primary,
              size: 45.0,
            ),
          if (!isLoading && orderListDone.isEmpty && orderListDoneToday.isEmpty)
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
        ]),
      );
    });
  }
}
