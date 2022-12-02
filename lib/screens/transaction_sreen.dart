import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:store_app/apis/apiService.dart';
import 'package:store_app/constants/Theme.dart';
import 'package:store_app/constants/Variable.dart';
import 'package:store_app/models/OrderReportPriceModel.dart';
import 'package:store_app/models/orderModel.dart';
import 'package:store_app/models/orderReportModel.dart';
import 'package:store_app/provider/appProvider.dart';
import 'package:store_app/screens/order_detail_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TransactionSreen extends StatefulWidget {
  const TransactionSreen({Key? key}) : super(key: key);

  @override
  _TransactionSreenState createState() => _TransactionSreenState();
}

class _TransactionSreenState extends State<TransactionSreen> {
  var filterActive = 1;
  int orderDoneToday = 0;
  int dayActive = 1;
  List<OrderModel> orderListDone = [];
  List<OrderModel> orderListDoneToday = [];
  final currencyFormatter = NumberFormat('#,##0', 'ID');
  late OrderReportModel orderReportModel = OrderReportModel(totalOrderNew: 0, totalOrderCancel: 0, totalOrderCompleted: 0, totalOrder: 0);
  late OrderReportPriceModel orderReportPriceModel = OrderReportPriceModel(totalOrder: 0, totalPaymentCash: 0, totalProfitOrder: 0, totalRevenueOrder: 0);
  bool isLoading = true;
  late bool isListFull = false;
  late int page = 1;
  void getOrderReport(storeId, String dayFilter) async {
    setState(() {
      isLoading = true;
    });
    var futures = await Future.wait([ApiServices.getOrderReports(storeId, dayFilter), ApiServices.getOrderReportsPrice(storeId, dayFilter)]);
    if (futures.isNotEmpty) {
      setState(() {
        orderReportModel = futures[0];
        orderReportPriceModel = futures[1];
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  // void getOrderReportRevenue(storeId, dayFilter) {
  //   setState(() {
  //     isLoading = true;
  //   });

  //   ApiServices.getOrderReportsPrice(storeId, dayFilter)
  //       .then((ordersReport) => {
  //             if (ordersReport != null)
  //               {
  //                 setState(() {
  //                   orderReportPriceModel = ordersReport;
  //                 })
  //               }
  //             else
  //               {
  //                 setState(() {
  //                   isLoading = false;
  //                 })
  //               }
  //           })
  //       .then((value) => {getListOrder(storeId)});
  // }

  String getTime(String time) {
    var inputFormat = DateFormat('yyyy-MM-ddTHH:mm:ss');
    var inputDate = inputFormat.parse(time);
    var outputFormat = DateFormat('hh:mm a dd/MM/yyyy');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var storeId = context.read<AppProvider>().getUserId;
    DateTime now = DateTime.now();
    var formatterDate = DateFormat('dd');
    var formatterMonth = DateFormat("MMM");
    var formatterYear = DateFormat("yyyy");
    String actualDate = formatterDate.format(now);
    String actualMonth = formatterMonth.format(now);
    String actualYear = formatterYear.format(now);
    String dayFilter = "${actualMonth} ${actualDate} ${actualYear}";
    getOrderReport(storeId, dayFilter);
    // getOrderReportRevenue(storeId, dayFilter);
  }

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

  transactionTitle() {
    return Container(
      decoration: BoxDecoration(
          // color: Color.fromARGB(255, 243, 247, 251),
          ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  child: Text(
                    "Tháng 9/2022",
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 20, fontFamily: "SF Bold"),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.all(10),
            color: Color.fromRGBO(255, 170, 76, 1).withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Xem báo cáo tháng này",
                  style: TextStyle(fontSize: 17, color: MaterialColors.primary, fontWeight: FontWeight.bold),
                ),
                Container(
                  child: Icon(
                    Icons.navigate_next,
                    color: MaterialColors.primary,
                    size: 28,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  var deliver = Row(
    // mainAxisAlignment: MainAxisAlignment.center,
    // crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(kSpacingUnit * 1),
          color: Color.fromARGB(255, 243, 247, 251),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Chuyển tiền đến công ty",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Text("11:11  - 01/01/2022"),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 243, 247, 251),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Text("Số dư ví: **********"),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Text(
                              "- 111.111 vnd",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ],
  );

  transactionItem(index) {
    return Container(
      padding: EdgeInsets.only(right: 15, top: 15, bottom: 15, left: 15),
      color: index % 2 == 1 ? Colors.white : Color.fromRGBO(250, 250, 250, 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            // color: Color.fromRGBO(200, 200, 200, 1),
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(kSpacingUnit * 1),
            // ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                        height: 50,
                        width: 50,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), border: Border.all(width: 1, color: Color.fromRGBO(230, 230, 230, 1))),
                          child: Center(
                            child: Container(
                              height: 17,
                              width: 17,
                              child: Image.asset(
                                'assets/images/wallet.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 20,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Text(
                            "Rút tiền từ ví về TP Bank",
                            style: TextStyle(fontFamily: "SF SemiBold", fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Row(
                        children: [
                          Text(
                            "11:11, 01/01/2022",
                            style: TextStyle(color: Color.fromRGBO(150, 150, 150, 1), fontFamily: "SF Regular", fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(
                    //   height: 5,
                    // ),
                    // Container(
                    //   child: Row(
                    //     children: [
                    //       Text(
                    //         "Số dư ví: **********",
                    //         style: TextStyle(
                    //             fontFamily: "SF Regular", fontSize: 14),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                )
              ],
            ),
          ),
          Text(
            "-100.000",
            style: TextStyle(fontFamily: "SF SemiBold", fontSize: 16),
          ),
        ],
      ),
    );
  }

  void _modalBottomSheetMenu() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
        builder: (builder) {
          return StatefulBuilder(builder: (BuildContext context, StateSetter mystate) {
            return Container(
              height: 220.0,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.only(top: 15, bottom: 15),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                        "Chọn Khoảng Thời Gian",
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontFamily: "SF Bold", fontSize: 15),
                      ),
                    ]),
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Color.fromRGBO(240, 240, 240, 1)))),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            onTap: () {
                              mystate(() {
                                filterActive = 1;
                                dayActive = 1;
                                Navigator.pop(context);
                                var storeId = context.read<AppProvider>().getUserId;
                                DateTime now = DateTime.now();
                                var formatterDate = DateFormat('dd');
                                var formatterMonth = DateFormat("MMM");
                                var formatterYear = DateFormat("yyyy");
                                String actualDate = formatterDate.format(now);
                                String actualMonth = formatterMonth.format(now);
                                String actualYear = formatterYear.format(now);
                                String dayFilter = "${actualMonth} ${actualDate} ${actualYear}";
                                getOrderReport(storeId, dayFilter);
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Row(children: [
                                    Text(
                                      "Hôm nay",
                                      style: TextStyle(color: Color.fromRGBO(120, 120, 120, 1), fontFamily: "SF Medium", fontSize: 16),
                                    ),
                                  ]),
                                ),
                                Container(
                                  child: Row(children: [
                                    filterActive == 1
                                        ? Icon(Icons.radio_button_checked, size: 20, color: Color.fromRGBO(120, 120, 120, 1))
                                        : Icon(Icons.radio_button_unchecked, size: 20, color: Color.fromRGBO(120, 120, 120, 1)),
                                  ]),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              mystate(() {
                                filterActive = 2;
                                dayActive = 2;
                                Navigator.pop(context);
                                var storeId = context.read<AppProvider>().getUserId;
                                DateTime now = DateTime.now().subtract(Duration(days: 1));
                                var formatterDate = DateFormat('dd');
                                var formatterMonth = DateFormat("MMM");
                                var formatterYear = DateFormat("yyyy");
                                String actualDate = formatterDate.format(now);
                                String actualMonth = formatterMonth.format(now);
                                String actualYear = formatterYear.format(now);
                                String dayFilter = "${actualMonth} ${actualDate} ${actualYear}";
                                getOrderReport(storeId, dayFilter);
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Row(children: [
                                    Text(
                                      "Hôm qua",
                                      style: TextStyle(color: Color.fromRGBO(120, 120, 120, 1), fontFamily: "SF Medium", fontSize: 16),
                                    ),
                                  ]),
                                ),
                                Container(
                                  child: Row(children: [
                                    filterActive == 2
                                        ? Icon(Icons.radio_button_checked, size: 20, color: Color.fromRGBO(120, 120, 120, 1))
                                        : Icon(Icons.radio_button_unchecked, size: 20, color: Color.fromRGBO(120, 120, 120, 1)),
                                  ]),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Row(children: [
                                    Text(
                                      "Tháng này",
                                      style: TextStyle(color: Color.fromRGBO(120, 120, 120, 1), fontFamily: "SF Medium", fontSize: 16),
                                    ),
                                  ]),
                                ),
                                Container(
                                  child: Row(children: [
                                    Icon(Icons.radio_button_unchecked, size: 20, color: Color.fromRGBO(120, 120, 120, 1)),
                                  ]),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              mystate(() {
                                filterActive = 4;
                                dayActive = 4;
                                Navigator.pop(context);
                                var storeId = context.read<AppProvider>().getUserId;

                                getOrderReport(storeId, "");
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Row(children: [
                                    Text(
                                      "Từ trước tới nay",
                                      style: TextStyle(color: Color.fromRGBO(120, 120, 120, 1), fontFamily: "SF Medium", fontSize: 16),
                                    ),
                                  ]),
                                ),
                                Container(
                                  child: Row(children: [
                                    filterActive == 4
                                        ? Icon(Icons.radio_button_checked, size: 20, color: Color.fromRGBO(120, 120, 120, 1))
                                        : Icon(Icons.radio_button_unchecked, size: 20, color: Color.fromRGBO(120, 120, 120, 1)),
                                  ]),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ))
                ],
              ),
            );
          });
        });
  }

  getTimeText(dayActive) {
    DateTime now = DateTime.now();
    if (dayActive == 4) {
      return "Từ trước tới nay";
    } else {
      if (dayActive == 1) {
        return "Hôm nay";
      } else if (dayActive == 2) {
        return "Hôm qua";
      }
    }
  }

  getTimeNow(dayActive) {
    DateTime now = DateTime.now();
    if (dayActive == 4) {
      return "Từ trước tới nay";
    } else {
      if (dayActive == 1) {
        now = DateTime.now();
      } else if (dayActive == 2) {
        now = DateTime.now().subtract(Duration(days: 1));
      }
      var formatterDate = DateFormat('dd');
      var formatterMonth = DateFormat('MM');
      String actualDate = formatterDate.format(now);
      String actualMonth = formatterMonth.format(now);
      return actualDate + " Tháng " + actualMonth;
    }
  }

  statistical_order() {
    return InkWell(
      onTap: () {
        _modalBottomSheetMenu();
      },
      child: Container(
        margin: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
        // padding: EdgeInsets.all(15),
        padding: EdgeInsets.only(left: 15, right: 10, bottom: 10, top: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(color: Color.fromRGBO(230, 230, 230, 1)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              getTimeNow(dayActive),
              style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontFamily: "SF SemiBold", fontSize: 15),
            ),
            SizedBox(
              width: 7,
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 13,
              color: Color.fromRGBO(170, 170, 170, 1),
            ),
          ],
        ),
      ),
    );
  }

  revenue() {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(color: Color.fromRGBO(200, 200, 200, 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getTimeText(dayActive),
            style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: "SF Medium"),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Text(
                currencyFormatter.format((orderReportPriceModel.totalOrder!).toInt()).toString(),
                style: TextStyle(color: MaterialColors.primary, fontSize: 24, fontFamily: "SF Bold"),
              ),
              Text(
                " ₫",
                style: TextStyle(color: MaterialColors.primary, fontSize: 18, fontFamily: "SF Medium"),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.event_available,
                    size: 18,
                    color: Color.fromRGBO(80, 80, 80, 1),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        orderReportModel.totalOrderCompleted.toString(),
                        style: TextStyle(color: Color.fromRGBO(80, 80, 80, 1), fontSize: 14),
                      ),
                      Text(
                        " đơn hàng hoàn tất",
                        style: TextStyle(color: Color.fromRGBO(80, 80, 80, 1), fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                width: 45,
              ),
              Expanded(
                child: Container(
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/order-history');
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          boxShadow: <BoxShadow>[BoxShadow(color: Colors.grey.shade200, offset: const Offset(2, 4), blurRadius: 5, spreadRadius: 2)],
                          gradient: const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [MaterialColors.primary, Color(0xfff7892b)])),
                      child: const Text(
                        'Xem chi tiết',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontFamily: "SF SemiBold",
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  // filter() {
  //   return Container(
  //     color: Color.fromARGB(255, 243, 247, 251),
  //     padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
  //     child: Row(
  //       children: [
  //         InkWell(
  //           onTap: () {
  //             setState(() {
  //               filterActive = 0;
  //             });
  //           },
  //           child: Container(
  //             width: 90,
  //             padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
  //             decoration: BoxDecoration(
  //                 color: filterActive == 0 ? MaterialColors.primary : Colors.white,
  //                 border: Border.all(color: filterActive == 0 ? MaterialColors.primary : Color.fromRGBO(230, 230, 230, 1)),
  //                 borderRadius: BorderRadius.all(Radius.circular(10))),
  //             child: Text('Tất cả', textAlign: TextAlign.center, style: TextStyle(color: filterActive == 0 ? Colors.white : Colors.black, fontSize: 15, fontFamily: "SF Regular")),
  //           ),
  //         ),
  //         SizedBox(
  //           width: 10,
  //         ),
  //         InkWell(
  //           onTap: () {
  //             setState(() {
  //               filterActive = 1;
  //             });
  //           },
  //           child: Container(
  //             width: 90,
  //             padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
  //             decoration: BoxDecoration(
  //                 color: filterActive == 1 ? MaterialColors.primary : Colors.white,
  //                 border: Border.all(color: filterActive == 1 ? MaterialColors.primary : Color.fromRGBO(230, 230, 230, 1)),
  //                 borderRadius: BorderRadius.all(Radius.circular(10))),
  //             child: Text('Nhận tiền', textAlign: TextAlign.center, style: TextStyle(color: filterActive == 1 ? Colors.white : Colors.black, fontSize: 15, fontFamily: "SF Regular")),
  //           ),
  //         ),
  //         SizedBox(
  //           width: 10,
  //         ),
  //         InkWell(
  //           onTap: () {
  //             setState(() {
  //               filterActive = 2;
  //             });
  //           },
  //           child: Container(
  //             width: 90,
  //             padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
  //             decoration: BoxDecoration(
  //                 color: filterActive == 2 ? MaterialColors.primary : Colors.white,
  //                 border: Border.all(color: filterActive == 2 ? MaterialColors.primary : Color.fromRGBO(230, 230, 230, 1)),
  //                 borderRadius: BorderRadius.all(Radius.circular(10))),
  //             child: Text('Rút tiền', textAlign: TextAlign.center, style: TextStyle(color: filterActive == 2 ? Colors.white : Colors.black, fontSize: 15, fontFamily: "SF Regular")),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          // backgroundColor: Color.fromARGB(255, 255, 255, 255),
          centerTitle: true,
          title: Text(
            "Lịch sử",
            style: TextStyle(color: MaterialColors.white, fontFamily: "SF Bold"),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [MaterialColors.primary, Color(0xfff7892b)]),
            ),
          ),
          // bottom:
        ),
        body: Stack(children: [
          if (!isLoading)
            SingleChildScrollView(
                child: Container(
              color: Colors.white,
              child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 25,
                    ),

                    // Container(
                    //   color: MaterialColors.grey,
                    //   height: 10,
                    // ),
                    // SizedBox(
                    //   height: 15,
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //     Row(
                    //       children: [
                    //         Text(
                    //           "₫ ",
                    //           style: TextStyle(color: MaterialColors.primary, fontSize: 18, fontFamily: "SF Medium"),
                    //         ),
                    //         Text(
                    //           currencyFormatter.format((orderReportPriceModel.totalOrder!).toInt()).toString(),
                    //           style: TextStyle(color: MaterialColors.primary, fontSize: 24, fontFamily: "SF Bold"),
                    //         )
                    //       ],
                    //     )
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //     Text(
                    //       "Tổng doanh thu",
                    //       style: TextStyle(color: MaterialColors.black, fontSize: 15, fontFamily: "SF Medium"),
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: 15,
                    // ),
                    // Container(
                    //   color: MaterialColors.grey,
                    //   height: 10,
                    // ),
                    Container(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(
                              "Tổng kết doanh thu",
                              style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontFamily: "SF Bold", fontSize: 20),
                            ),
                          ),
                          statistical_order(),
                        ],
                      ),
                    ),
                    revenue(),

                    Container(
                      height: 10,
                    ),
                    // filter(),
                    // transactionTitle(),
                    // ...[1, 2, 3, 4, 5].map((item) => transactionItem(item)).toList(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isLoading) ...[
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  color: MaterialColors.white,
                                  padding: EdgeInsets.all(15),
                                  child: Text(
                                    "Tổng kết đơn hàng",
                                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontFamily: "SF Bold", fontSize: 20),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              left: 15,
                              right: 15,
                            ),
                            color: MaterialColors.white,
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                      padding: EdgeInsets.only(left: 15, bottom: 15, top: 15),
                                      decoration: BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1), borderRadius: BorderRadius.all(Radius.circular(10))),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            orderReportModel.totalOrder.toString(),
                                            style: TextStyle(fontFamily: "SF Bold", fontSize: 18, color: Color.fromRGBO(50, 50, 50, 1)),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Tổng đơn hàng",
                                            style: TextStyle(fontFamily: "SF Regular", fontSize: 15, color: Color.fromRGBO(50, 50, 50, 1)),
                                          )
                                        ],
                                      ),
                                    )),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    decoration: BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1), borderRadius: BorderRadius.all(Radius.circular(10))),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(orderReportModel.totalOrderNew.toString(), style: TextStyle(fontFamily: "SF Bold", fontSize: 18, color: Color.fromRGBO(50, 50, 50, 1))),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Đơn hàng mới",
                                          style: TextStyle(fontFamily: "SF Regular", fontSize: 15, color: Color.fromRGBO(50, 50, 50, 1)),
                                        )
                                      ],
                                    ),
                                    padding: EdgeInsets.only(left: 15, bottom: 15, top: 15),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              left: 15,
                              right: 15,
                            ),
                            color: MaterialColors.white,
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                      padding: EdgeInsets.only(left: 15, bottom: 15, top: 15),
                                      decoration: BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1), borderRadius: BorderRadius.all(Radius.circular(10))),
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
                                            "Đơn đơn thành công",
                                            style: TextStyle(fontFamily: "SF Regular", fontSize: 15, color: Color.fromRGBO(50, 50, 50, 1)),
                                          )
                                        ],
                                      ),
                                    )),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    decoration: BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1), borderRadius: BorderRadius.all(Radius.circular(10))),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(orderReportModel.totalOrderCancel.toString(), style: TextStyle(fontFamily: "SF Bold", fontSize: 18, color: Color.fromRGBO(50, 50, 50, 1))),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Đơn hàng thất bại",
                                          style: TextStyle(fontFamily: "SF Regular", fontSize: 15, color: Color.fromRGBO(50, 50, 50, 1)),
                                        )
                                      ],
                                    ),
                                    padding: EdgeInsets.only(left: 15, bottom: 15, top: 15),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 15, right: 15),
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, '/order-history');
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                    boxShadow: <BoxShadow>[BoxShadow(color: Colors.grey.shade200, offset: const Offset(2, 4), blurRadius: 5, spreadRadius: 2)],
                                    gradient: const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [MaterialColors.primary, Color(0xfff7892b)])),
                                child: const Text(
                                  'Xem chi tiết',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontFamily: "SF SemiBold",
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Container(
                          //     decoration: BoxDecoration(color: Colors.white),
                          //     padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                          //     width: MediaQuery.of(context).size.width,
                          //     child: Container(
                          //       height: 45,
                          //       child: ElevatedButton(
                          //         child: Text(
                          //           "Xem chi tiết",
                          //           style: TextStyle(color: Colors.white, fontFamily: "SF Bold", fontSize: 16),
                          //         ),
                          //         style: ElevatedButton.styleFrom(
                          //           primary: MaterialColors.primary,
                          //           textStyle: TextStyle(color: Colors.white),
                          //           shadowColor: Colors.white,
                          //           shape: RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.circular(8),
                          //           ),
                          //         ),
                          //         onPressed: () => {Navigator.pushNamed(context, '/order-history')},
                          //       ),
                          //     )),
                          SizedBox(
                            height: 30,
                          ),
                        ]
                      ],
                    ),
                  ]),
            )),
          if (isLoading)
            SpinKitDualRing(
              color: MaterialColors.primary,
              size: 45.0,
            ),
          // if (!isLoading && orderListDone.isEmpty)
          //   Container(
          //     child: Center(
          //         child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: [
          //         Container(
          //           height: 150,
          //           width: 150,
          //           child: Image.asset(
          //             'assets/images/empty-order.png',
          //             fit: BoxFit.cover,
          //           ),
          //         ),
          //         Text(
          //           "Bạn không có đơn hàng nào",
          //           style: TextStyle(fontFamily: "SF Regular", fontSize: 16),
          //         ),
          //       ],
          //     )),
          //   ),
        ]));
  }
}
