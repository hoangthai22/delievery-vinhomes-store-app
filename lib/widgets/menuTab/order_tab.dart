import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:store_app/apis/apiService.dart';
import 'package:store_app/constants/Theme.dart';
import 'package:store_app/models/orderModel.dart';
import 'package:store_app/screens/order_detail_screen.dart';
import 'package:store_app/widgets/order/order_list.dart';
import 'package:store_app/widgets/order/order_list_mode3.dart';
import 'package:store_app/widgets/order/order_list_shipping.dart';

class OrderTab extends StatefulWidget {
  String storeId;
  int tab;
  OrderTab({Key? key, required this.storeId, required this.tab}) : super(key: key);

  @override
  _OrderTabState createState() => _OrderTabState();
}

class _OrderTabState extends State<OrderTab> {
  bool isLoading = true;
  List<OrderModel> orderListDone = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.tab == 1)
          OrderList(
            onTap: (order) => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetailScreen(order: order),
                ),
              )
            },
            storeId: widget.storeId,
          )
        else if (widget.tab == 2)
          OrderListShipping(
            onTap: (order) => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetailScreen(order: order),
                ),
              )
            },
            storeId: widget.storeId,
          )
        else if (widget.tab == 3)
          OrderListMode3(
            onTap: (order) => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetailScreen(order: order),
                ),
              )
            },
            storeId: widget.storeId,
          ),
      ],
    );
  }
}
