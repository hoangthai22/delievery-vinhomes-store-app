import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/constants/Theme.dart';
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
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, provider, child) {
      var storeId = context.read<AppProvider>().getUserId;
      return DefaultTabController(
          initialIndex: 0,
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              centerTitle: true,
              title: Text(
                "Đơn hàng",
                style: TextStyle(
                    color: MaterialColors.black, fontFamily: "SF Bold"),
              ),
              bottom: const TabBar(
                tabs: <Widget>[
                  Tab(
                    // icon: Icon(Icons.cloud_outlined),
                    text: "Hiện tại",
                  ),
                  Tab(
                    // icon: Icon(Icons.beach_access_sharp),
                    text: "Đang giao",
                  ),
                  Tab(
                    // icon: Icon(Icons.brightness_5_sharp),
                    text: "Lịch sử",
                  ),
                ],
              ),
            ),
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
