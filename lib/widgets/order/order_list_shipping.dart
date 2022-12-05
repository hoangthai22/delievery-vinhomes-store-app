import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:store_app/apis/apiService.dart';
import 'package:store_app/constants/Theme.dart';
import 'package:store_app/constants/Variable.dart';
import 'package:store_app/models/orderModel.dart';

class OrderListShipping extends StatefulWidget {
  String storeId;
  final Function(OrderModel product)? onTap;
  OrderListShipping({Key? key, required this.onTap, required this.storeId}) : super(key: key);

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
    ApiServices.getListOrder478(widget.storeId, 1, 100).then((value) => {
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

  Future<void> _refreshRandomNumbers() => Future.delayed(Duration(milliseconds: 500), () {
        getListOrder();
      });
  String getTime(String time) {
    var inputFormat = DateFormat('yyyy-MM-ddTHH:mm:ss');
    var inputDate = inputFormat.parse(time);
    var outputFormat = DateFormat('HH:mm');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

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
                            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 3,
                                  blurRadius: 5,
                                  offset: Offset(0, 2), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Container(
                              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
                              height: 120,
                              child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                                Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Text(
                                      "#${orderListShipping[index].id.toString()}",
                                      style: const TextStyle(fontFamily: "SF Bold", fontSize: 18, color: Colors.black87),
                                    ),
                                  ]),
                                  Container(
                                    padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color.fromARGB(255, 32, 129, 209), MaterialColors.secondary]),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: const Text(
                                      "Đang giao",
                                      style: TextStyle(fontFamily: "SF SemiBold", fontSize: 15, color: Colors.white),
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
                                    Text(
                                      "Đã lấy hàng lúc " + getTime(orderListShipping[index].time.toString()),
                                      style: const TextStyle(fontFamily: "SF Regular", fontSize: 15, color: Colors.black),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "${currencyFormatter.format((orderListShipping[index].total! - orderListShipping[index].shipCost!).toInt())}₫",
                                          style: TextStyle(fontFamily: "SF Bold", fontSize: 16, color: Colors.black),
                                        ),
                                        SizedBox(width: 5),
                                        const Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          size: 15,
                                          color: Colors.black38,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                  const Text(
                                    "Tài xế đang giao hàng",
                                    style: TextStyle(fontFamily: "SF Regular", fontSize: 15, color: Colors.black),
                                  ),
                                ]),
                              ]),
                            ),
                          ),
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
        if (!isLoading && orderListShipping.isEmpty)
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
  }
}
