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
import 'package:store_app/screens/order_detail_screen.dart';

class OrderListDone extends StatefulWidget {
  OrderListDone({
    Key? key,
  }) : super(key: key);

  @override
  _OrderListDoneState createState() => _OrderListDoneState();
}

class _OrderListDoneState extends State<OrderListDone> {
  List<OrderModel> orderListDone = [];
  bool isLoading = true;
  late bool isListFull = false;
  late int page = 1;
  void getListOrder(storeId) {
    setState(() {
      isLoading = true;
    });

    ApiServices.getListOrderDone(storeId, 1, 100).then((ordersDone) => {
          if (ordersDone != null)
            {
              setState(() {
                orderListDone = ordersDone;
                print(orderListDone);
                isLoading = false;
              })
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var storeId = context.read<AppProvider>().getUserId;
    getListOrder(storeId);
  }

  String getTime(String time) {
    var result = "";
    var day = time.toString().split(" ")[0];
    if (day != null) {
      result =
          "${time.toString().split(" ")[1]}, ${day.toString().split("/")[2]} thg ${day.toString().split("/")[1]} ${day.toString().split("/")[0]}";
    } else {
      result = time;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat('#,##0', 'ID');
    return Consumer<AppProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: new AppBar(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            "Lịch sử đơn hàng",
            style: TextStyle(
              color: MaterialColors.black,
              fontFamily: "SF Bold",
            ),
          ),
        ),
        body: Stack(children: [
          SingleChildScrollView(
              child: Container(
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                if (orderListDone.isNotEmpty)
                  ...orderListDone.map((OrderModel order) {
                    var index = orderListDone.indexOf(order);
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                OrderDetailScreen(order: order),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: index != orderListDone.length - 1
                                ? Border(
                                    bottom: BorderSide(
                                        color: Colors.black12, width: 1))
                                : null),
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 10, right: 10, bottom: 10, top: 10),
                          height: 115,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          getTime(order.time.toString()),
                                          style: TextStyle(
                                              fontFamily: "SF Bold",
                                              fontSize: 17,
                                              color: Color.fromRGBO(
                                                  50, 50, 50, 1)),
                                        )
                                      ]),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              Status.getStatusName(order.status)
                                                  .toString(),
                                              style: TextStyle(
                                                  fontFamily: "SF Bold",
                                                  fontSize: 16,
                                                  color: Status.getStatusColor(
                                                      order.status)),
                                            ),
                                          ]),
                                    ),
                                    Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "${currencyFormatter.format((order.total! - order.shipCost!).toInt())}₫",
                                            style: const TextStyle(
                                                fontFamily: "SF Bold",
                                                fontSize: 17,
                                                color: Colors.black),
                                          ),
                                          const Padding(
                                              padding: EdgeInsets.all(5)),
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
                                  "${order.status == 5 ? "Đã giao" : Status.getStatusName(order.status)} lúc ${order.time.toString().split(" ")[1]}",
                                  style: TextStyle(
                                      fontFamily: "SF Medium",
                                      fontSize: 15,
                                      color: Colors.black38),
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
              size: 50.0,
            ),
          if (!isLoading && orderListDone.isEmpty)
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
