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
              bottom: TabBar(
                tabs: <Widget>[
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
                                context
                                    .read<AppProvider>()
                                    .getCountOrder
                                    .toString(),
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
                          padding: EdgeInsets.only(top: 3),
                          width: 85,
                          child: Text(
                            "Lịch sử",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
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
