import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/apis/apiService.dart';
import 'package:store_app/constants/Theme.dart';
import 'package:store_app/models/orderModel.dart';
import 'package:store_app/provider/appProvider.dart';
import 'package:store_app/widgets/menuTab/order_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    List<OrderModel> orderListMode3 = [];
    super.initState();
    var storeId = context.read<AppProvider>().getUserId;
    ApiServices.getListOrderByMode(storeId, "3", 1, 100).then((res) => {
          if (res != null)
            {
              orderListMode3 = res,
              if (orderListMode3.isNotEmpty)
                {context.read<AppProvider>().setOrderListMode3(orderListMode3), context.read<AppProvider>().setCountOrderMode3(orderListMode3.length)}
              else
                {context.read<AppProvider>().setOrderListMode3([]), context.read<AppProvider>().setCountOrderMode3(0)}
            }
          else
            {context.read<AppProvider>().setOrderListMode3([])}
        });
  }

  TabBar get _tabBar => TabBar(
        tabs: [
          Tab(
            // icon: Icon(Icons.cloud_outlined),
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 3),
                  width: 85,
                  child: Text(
                    "Hiện tại",
                    textAlign: TextAlign.center,
                  ),
                ),
                if (context.read<AppProvider>().getCountOrder > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      alignment: Alignment.center,
                      height: 15,
                      width: 15,
                      padding: EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 243, 93, 82),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        context.read<AppProvider>().getCountOrder.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
              ],
            ),
            // text: "Hiện tại",
          ),
          Tab(
            // icon: Icon(Icons.beach_access_sharp),
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 3),
                  width: 85,
                  child: Text(
                    "Đang giao",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Tab(
            // icon: Icon(Icons.brightness_5_sharp),
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 3, right: 5),
                  width: 85,
                  child: Text(
                    "Đặt trước",
                    textAlign: TextAlign.center,
                  ),
                ),
                if (context.read<AppProvider>().getOrderListMode3.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      alignment: Alignment.center,
                      height: 15,
                      width: 15,
                      padding: EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 243, 93, 82),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        context.read<AppProvider>().getCountOrderMode3.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
              ],
            ),
          ),
        ],
      );
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, provider, child) {
      var storeId = context.read<AppProvider>().getUserId;
      return DefaultTabController(
          initialIndex: 0,
          length: 3,
          child: Scaffold(
            appBar: AppBar(
                // backgroundColor: Color.fromARGB(255, 255, 255, 255),
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [MaterialColors.primary, Color(0xfff7892b)]),
                  ),
                ),
                centerTitle: true,
                title: Text(
                  "Đơn hàng",
                  style: TextStyle(color: MaterialColors.white, fontFamily: "SF Bold"),
                ),
                bottom: PreferredSize(
                  preferredSize: _tabBar.preferredSize,
                  child: ColoredBox(color: Colors.white, child: _tabBar),
                )),
            body: TabBarView(
              children: <Widget>[
                OrderTab(storeId: storeId, tab: 1),
                OrderTab(storeId: storeId, tab: 2),
                OrderTab(storeId: storeId, tab: 3),
              ],
            ),
          ));
    });
  }
}
