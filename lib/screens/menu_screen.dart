import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store_app/constants/Theme.dart';
import 'package:store_app/screens/select_photo_options_screen.dart';
import 'package:store_app/widgets/menuTab/menu_tab.dart';
import 'package:store_app/widgets/upload/common_buttons.dart';
import 'package:store_app/widgets/upload/re_usable_select_photo_button.dart';

const kHeadTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 24,
  fontWeight: FontWeight.bold,
);

const kHeadSubtitleTextStyle = TextStyle(
  fontSize: 18,
  color: Colors.black87,
);

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          centerTitle: true,
          title: Text(
            "Danh sách sản phẩm",
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
        body: const TabBarView(
          children: <Widget>[
            MenuTab(),
            MenuTab(),
            MenuTab(),
          ],
        ),
      ),
    );
  }
}
