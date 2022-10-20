import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:store_app/constants/Theme.dart';
import 'package:store_app/widgets/menuTab/menu_tab.dart';

const kHeadSubtitleTextStyle = TextStyle(
  fontSize: 18,
  color: Colors.black87,
);

class MenuScreen extends StatefulWidget {
  String storeId;
  MenuScreen({Key? key, required this.storeId}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          centerTitle: true,
          title: Text(
            "Thực đơn",
            style:
                TextStyle(color: MaterialColors.black, fontFamily: "SF Bold"),
          ),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                // icon: Icon(Icons.cloud_outlined),
                text: "Gọi món",
              ),
              Tab(
                // icon: Icon(Icons.beach_access_sharp),
                text: "Đi chợ",
              ),
              Tab(
                // icon: Icon(Icons.brightness_5_sharp),
                text: "Đặt hàng",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            MenuTab(menuIndex: "1", storeId: widget.storeId),
            MenuTab(menuIndex: "2", storeId: widget.storeId),
            MenuTab(menuIndex: "3", storeId: widget.storeId),
          ],
        ),
      ),
    );
  }
}
