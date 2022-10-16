import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:store_app/constants/Theme.dart';
import 'package:store_app/provider/appProvider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool status = true;
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, provider, child) {
      return Scaffold(
        body: Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 30),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      padding: EdgeInsets.only(
                          top: 15, bottom: 15, left: 15, right: 15),
                      child: Row(
                        children: [
                          Container(
                            width: 90,
                            margin: EdgeInsets.only(right: 15),
                            child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  bottomLeft: Radius.circular(50),
                                  topRight: Radius.circular(50),
                                  bottomRight: Radius.circular(50),
                                ),

                                // padding: const EdgeInsets.only(right: 15, left: 0),
                                child: Image(
                                  // color:70olors.red,
                                  height: 70,
                                  width: 70,
                                  fit: BoxFit.contain,
                                  image: NetworkImage(
                                      "https://firebasestorage.googleapis.com/v0/b/deliveryfood-9c436.appspot.com/o/icon%2Fshopping-store.png?alt=media&token=e632dd62-971c-4ba2-8f72-bca9a101d663"),
                                )),
                          ),
                          Expanded(
                            child: Text(
                              context.read<AppProvider>().getUserId,
                              style: TextStyle(
                                  color: MaterialColors.black,
                                  fontFamily: "SF Bold",
                                  fontSize: 22),
                            ),
                          )
                        ],
                      )),
                  Container(
                      padding: EdgeInsets.only(
                          top: 15, bottom: 15, left: 15, right: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Tình trạng quán",
                                  style: TextStyle(
                                      color: MaterialColors.black,
                                      fontFamily: "SF Bold",
                                      fontSize: 18),
                                ),
                                Padding(padding: EdgeInsets.all(3)),
                                Text(
                                  "Tắt để tạm dừng các đơn hàng đến.",
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontFamily: "SF Regular",
                                      fontSize: 15),
                                )
                              ],
                            )),
                          ),
                          Container(
                              child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                status ? "Mở cửa" : "Tạm đóng",
                                style: TextStyle(
                                    color: status ? Colors.green : Colors.amber,
                                    fontFamily: "SF Bold",
                                    fontSize: 18),
                              ),
                              Padding(padding: EdgeInsets.all(4)),
                              Container(
                                child: FlutterSwitch(
                                  width: 60.0,
                                  height: 30.0,
                                  valueFontSize: 15.0,
                                  toggleSize: 25.0,
                                  value: status,
                                  borderRadius: 30.0,
                                  padding: 3.5,
                                  activeColor: Colors.green,
                                  // showOnOff: true,
                                  onToggle: (val) {
                                    setState(() {
                                      status = val;
                                    });
                                  },
                                ),
                              )
                            ],
                          )),
                        ],
                      )),
                  Container(
                      color: MaterialColors.grey, padding: EdgeInsets.all(5)),
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Cài đặt",
                          style: TextStyle(
                              color: Colors.black54,
                              fontFamily: "SF Medium",
                              fontSize: 17),
                        ),
                        Padding(padding: EdgeInsets.all(10)),
                        Container(
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.storefront,
                                        size: 30,
                                      ),
                                      Padding(padding: EdgeInsets.all(5)),
                                      Text(
                                        "Cài đặt cửa hàng",
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontFamily: "SF SemiBold",
                                            fontSize: 18),
                                      )
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 18,
                                  color: Colors.black45,
                                ),
                              ]),
                        ),
                        Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.black12, width: 1))),
                            margin: EdgeInsets.only(top: 20, bottom: 20)),
                        Container(
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.history,
                                        size: 30,
                                      ),
                                      Padding(padding: EdgeInsets.all(5)),
                                      Text(
                                        "Lịch sử đơn hàng",
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontFamily: "SF SemiBold",
                                            fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 18,
                                  color: Colors.black45,
                                ),
                              ]),
                        ),
                        Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.black12, width: 1))),
                            margin: EdgeInsets.only(top: 20, bottom: 20)),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/login');
                            auth.signOut();
                          },
                          child: Container(
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.logout,
                                          size: 30,
                                        ),
                                        Padding(padding: EdgeInsets.all(5)),
                                        Text(
                                          "Đăng xuất",
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontFamily: "SF SemiBold",
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 18,
                                    color: Colors.black45,
                                  ),
                                ]),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )),
      );
    });
  }
}
