import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:store_app/apis/apiService.dart';
import 'package:store_app/constants/Theme.dart';
import 'package:store_app/provider/appProvider.dart';
import 'package:store_app/screens/update_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  bool status = true;
  bool isLoading = false;

  void initState() {
    super.initState();
    setState(() {
      status = context.read<AppProvider>().getStatus;
    });
  }

  toastError(error) {
    Fluttertoast.showToast(
        msg: error ?? "Đã xảy ra lỗi gì đó!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void updateStatus(bool val) {
    setState(() {
      isLoading = true;
    });
    ApiServices.putUpdateStatusStore(context.read<AppProvider>().getUserId, val)
        .then((value) => {
              if (value != null)
                {
                  if (value["statusCode"] == "Fail")
                    {
                      setState(() {
                        isLoading = false;
                        toastError(value["message"]);
                      })
                    }
                  else
                    {
                      setState(() {
                        status = val;
                        context.read<AppProvider>().setStatus(val);
                        isLoading = false;
                      })
                    }
                }
              else
                {
                  setState(() {
                    isLoading = false;
                    toastError("Đã xảy ra lỗi gì đó!");
                  })
                }
            })
        .catchError((onError) {
      setState(() {
        toastError("Đã xảy ra lỗi gì đó!");
        isLoading = false;
      });
    });
  }

  void handleToggle(val) {
    if (status) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          actions: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 7),
              child: Text(
                'Bạn có chắc muốn đóng cửa hàng?',
                style: TextStyle(
                    color: Colors.black, fontFamily: "SF Bold", fontSize: 17),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: Text(
                "Bạn sẽ không thể nhận được đơn hàng cho đến khi mở lại",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "SF Regular",
                    fontSize: 14),
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          child: Text(
                            "Hủy",
                            style: TextStyle(
                                color: Colors.black45,
                                fontFamily: "SF Medium",
                                fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            textStyle: TextStyle(color: Colors.black),
                            shadowColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(
                                    color: Colors.black45, width: 1)),
                          ),
                          onPressed: () => {Navigator.pop(context)},
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(7)),
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          child: const Text(
                            "Đồng ý",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: "SF Medium",
                                fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: MaterialColors.primary,
                            textStyle: TextStyle(color: Colors.black),
                            shadowColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: () =>
                              {Navigator.pop(context), updateStatus(val)},
                        ),
                      ),
                    )
                  ]),
            )
          ],
        ),
      );
    } else {
      updateStatus(val);
    }
  }

  void handleLogout() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    // await auth.signOut();
    Navigator.pop(context);
    setState(() {
      isLoading = true;
    });

    var docSnapshot =
        await db.collection("users").doc(auth.currentUser!.uid).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      var fcmToken = data?['fcmToken'];
      var userId = auth.currentUser!.uid;
      await db
          .collection("users")
          .doc(auth.currentUser!.uid)
          .delete()
          .then((value) => {
                auth.signOut().then((value) => {
                      setState(() {
                        isLoading = false;
                      }),
                      Navigator.pushReplacementNamed(context, '/')
                    })
              });
    }
  }

  @override
  Widget build(BuildContext context) {
    String image = context.read<AppProvider>().getAvatar.toString();
    return Consumer<AppProvider>(builder: (context, provider, child) {
      return Stack(
        children: [
          Scaffold(
            body: Container(
                color: Colors.white,
                padding: const EdgeInsets.only(top: 30),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                          padding: const EdgeInsets.only(
                              top: 15, bottom: 15, left: 15, right: 15),
                          child: Row(
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                margin: const EdgeInsets.only(right: 15),
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
                                      fit: BoxFit.cover,
                                      image: NetworkImage(image),
                                    )),
                              ),
                              Expanded(
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UpdateProfileScreen(),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            context.read<AppProvider>().getName,
                                            style: const TextStyle(
                                                color: MaterialColors.black,
                                                fontFamily: "SF Bold",
                                                fontSize: 22),
                                          ),
                                          Padding(padding: EdgeInsets.all(2)),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Chỉnh sửa tài khoản",
                                                style: const TextStyle(
                                                    color: Colors.black54,
                                                    fontFamily: "SF Medium",
                                                    fontSize: 15),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                size: 12,
                                                color: Colors.black54,
                                              )
                                            ],
                                          )
                                        ],
                                      )))
                            ],
                          )),
                      Container(
                          padding: const EdgeInsets.only(
                              top: 15, bottom: 15, left: 15, right: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
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
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    status ? "Mở cửa" : "Tạm đóng",
                                    style: TextStyle(
                                        color: status
                                            ? Colors.green
                                            : Colors.amber,
                                        fontFamily: "SF Bold",
                                        fontSize: 18),
                                  ),
                                  Padding(padding: EdgeInsets.all(4)),
                                  FlutterSwitch(
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
                                      handleToggle(val);
                                      // setState(() {
                                      //   status = val;
                                      // });
                                    },
                                  )
                                ],
                              ),
                            ],
                          )),
                      Container(
                          color: MaterialColors.grey,
                          padding: const EdgeInsets.all(5)),
                      Container(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "Cài đặt",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontFamily: "SF Medium",
                                  fontSize: 17),
                            ),
                            const Padding(padding: EdgeInsets.all(15)),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.storefront,
                                        size: 24,
                                      ),
                                      Padding(padding: EdgeInsets.all(8)),
                                      InkWell(
                                        onTap: () {},
                                        child: Text(
                                          "Cài đặt cửa hàng",
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontFamily: "SF SemiBold",
                                              fontSize: 16),
                                        ),
                                      )
                                    ],
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 16,
                                    color: Colors.black45,
                                  ),
                                ]),
                            Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.black12, width: 1))),
                                margin: EdgeInsets.only(top: 20, bottom: 20)),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.history,
                                        size: 24,
                                      ),
                                      Padding(padding: EdgeInsets.all(8)),
                                      Text(
                                        "Lịch sử đơn hàng",
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontFamily: "SF SemiBold",
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 16,
                                    color: Colors.black45,
                                  ),
                                ]),
                            Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.black12, width: 1))),
                                margin:
                                    const EdgeInsets.only(top: 20, bottom: 20)),
                            InkWell(
                              onTap: () {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text(
                                      'Đăng xuất ngay',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "SF Bold",
                                          fontSize: 18),
                                    ),
                                    actions: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: SizedBox(
                                                  height: 40,
                                                  child: ElevatedButton(
                                                    child: Text(
                                                      "Hủy",
                                                      style: TextStyle(
                                                          color: Colors.black45,
                                                          fontFamily:
                                                              "SF Medium",
                                                          fontSize: 16),
                                                    ),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: Colors.white,
                                                      textStyle: TextStyle(
                                                          color: Colors.black),
                                                      shadowColor: Colors.white,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              side: BorderSide(
                                                                  color: Colors
                                                                      .black45,
                                                                  width: 1)),
                                                    ),
                                                    onPressed: () => {
                                                      Navigator.pop(context)
                                                    },
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.all(7)),
                                              Expanded(
                                                child: SizedBox(
                                                  height: 40,
                                                  child: ElevatedButton(
                                                    child: const Text(
                                                      "Đồng ý",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily:
                                                              "SF Medium",
                                                          fontSize: 16),
                                                    ),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: MaterialColors
                                                          .primary,
                                                      textStyle: TextStyle(
                                                          color: Colors.black),
                                                      shadowColor: Colors.white,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                    ),
                                                    onPressed: () =>
                                                        {handleLogout()},
                                                  ),
                                                ),
                                              )
                                            ]),
                                      )
                                    ],
                                  ),
                                );
                              },
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.logout,
                                          size: 24,
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.all(8)),
                                        const Text(
                                          "Đăng xuất",
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontFamily: "SF SemiBold",
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 16,
                                      color: Colors.black45,
                                    ),
                                  ]),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ),
          if (isLoading)
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.white.withOpacity(0.5),
              child: SpinKitFoldingCube(
                color: MaterialColors.primary,
                size: 50.0,
              ),
            )
        ],
      );
    });
  }
}
