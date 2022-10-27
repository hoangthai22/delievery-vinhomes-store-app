import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:store_app/apis/apiService.dart';
import 'package:store_app/constants/Theme.dart';
import 'package:store_app/constants/Variable.dart';
import 'package:store_app/models/orderModel.dart';

class OrderListShipping extends StatefulWidget {
  String storeId;
  final Function(OrderModel product)? onTap;
  OrderListShipping({Key? key, required this.onTap, required this.storeId})
      : super(key: key);

  @override
  _OrderListShippingState createState() => _OrderListShippingState();
}

class _OrderListShippingState extends State<OrderListShipping> {
  bool isLoading = true;
  List<OrderModel> orderListShipping = [];
  void getListOrder() {
    setState(() {
      // menus = [];
      isLoading = true;
    });
    ApiServices.getListOrderByStatus(widget.storeId, Status.SHIPPING, 1, 20)
        .then((value) => {
              if (value != null)
                {
                  setState(() {
                    orderListShipping = value;
                    isLoading = false;
                  })
                }
              else
                {
                  setState(() {
                    orderListShipping = [];
                    isLoading = false;
                  })
                }
            });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getListOrder();
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

  Future<void> _refreshRandomNumbers() =>
      Future.delayed(Duration(milliseconds: 500), () {
        getListOrder();
      });

  @override
  Widget build(BuildContext context) {
    // print(getTime("2022/10/13 22:50"));
    final currencyFormatter = NumberFormat('#,##0', 'ID');
    return Stack(
      children: [
        if (orderListShipping.isNotEmpty)
          RefreshIndicator(
              onRefresh: _refreshRandomNumbers,
              child: Container(
                padding: EdgeInsets.only(top: 10),
                child: ListView.builder(
                    itemCount: orderListShipping.length,
                    itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            widget.onTap!(orderListShipping[index]);
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                              "FD-${orderListShipping[index].id.toString().substring(0, 4)}",
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
                                                color: Colors.lightBlue[900],
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                              child: const Text(
                                                "Đang giao",
                                                style: TextStyle(
                                                    fontFamily: "SF SemiBold",
                                                    fontSize: 15,
                                                    color: Colors.white),
                                              ),
                                            )
                                          ]),
                                          Text(
                                            getTime(orderListShipping[index]
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
                                        Text(
                                          "${currencyFormatter.format((orderListShipping[index].total! - orderListShipping[index].shipCost!).toInt())}₫",
                                          style: TextStyle(
                                              fontFamily: "SF Bold",
                                              fontSize: 15,
                                              color: Colors.black),
                                        ),
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
                                            "Tài xế Văn Dương đang giao ",
                                            style: TextStyle(
                                                fontFamily: "SF Medium",
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
          const SpinKitDualRing(
            color: MaterialColors.primary,
            size: 50.0,
          ),
        if (!isLoading && orderListShipping.isEmpty)
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
  }
}
