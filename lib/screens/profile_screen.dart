import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
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
    // CollectionReference employees =
    //     FirebaseFirestore.instance.collection('employees');
    // final listener = employees.snapshots().listen((querySnapshot) {
    //   for (var change in querySnapshot.docChanges) {
    //     print("change: " + change.doc.id);
    //   }
    // });
  }

  @override
  void dispose() {
    super.dispose();
    print('EVERYTHING disposed');

    // other disposes()
  }

  toastError(error) {
    Fluttertoast.showToast(
        msg: error ?? "Đã xảy ra lỗi gì đó!", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.TOP, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
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

  handleToggle(val) {
    if (status) {
      return Dialogs.materialDialog(
          dialogShape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
          msg: 'Bạn sẽ không thể nhận được đơn hàng cho đến khi mở lại',
          msgAlign: TextAlign.center,
          title: "Bạn có chắc muốn đóng cửa hàng?",
          color: Colors.white,
          context: context,
          actions: [
            Container(
                decoration: const BoxDecoration(color: Colors.white),
                // padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                width: MediaQuery.of(context).size.width,
                child: SizedBox(
                  height: 38,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        // padding: const EdgeInsets.symmetric(vertical: 5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                            boxShadow: <BoxShadow>[BoxShadow(color: Colors.grey.shade200, offset: const Offset(2, 4), blurRadius: 5, spreadRadius: 2)],
                            gradient: const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color.fromRGBO(220, 220, 220, 1), Color.fromRGBO(200, 200, 200, 1)])),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cancel_outlined,
                              color: Colors.black54,
                              size: 15,
                            ),
                            SizedBox(width: 5),
                            const Text(
                              'Đóng',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                                height: 1,
                                fontFamily: "SF SemiBold",
                              ),
                            ),
                          ],
                        )),
                  ),
                )),
            Container(
                decoration: const BoxDecoration(color: Colors.white),
                // padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                width: MediaQuery.of(context).size.width,
                child: SizedBox(
                  height: 38,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      updateStatus(val);
                    },
                    child: Container(
                        // width: MediaQuery.of(context).size.width,
                        // padding: const EdgeInsets.symmetric(vertical: 5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                            boxShadow: <BoxShadow>[BoxShadow(color: Colors.grey.shade200, offset: const Offset(2, 4), blurRadius: 5, spreadRadius: 2)],
                            gradient: const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.redAccent, Colors.red])),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 15,
                            ),
                            SizedBox(width: 5),
                            const Text(
                              'Đồng ý',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                height: 1,
                                fontFamily: "SF SemiBold",
                              ),
                            ),
                          ],
                        )),
                  ),
                )),
          ]);
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

    var docSnapshot = await db.collection("users").doc(auth.currentUser!.email).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      var fcmToken = data?['fcmToken'];
      var userId = auth.currentUser!.email;
      await db
          .collection("users")
          .doc(userId)
          .delete()
          .then((value) => {
                auth
                    .signOut()
                    .then((value) => {
                          setState(() {
                            isLoading = false;
                          }),
                          Navigator.pushReplacementNamed(context, '/')
                        })
                    .catchError((error) {
                  print("error" + error.toString());
                })
              })
          .catchError((error) {
        print("error" + error.toString());
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
                          padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
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
                                            builder: (context) => UpdateProfileScreen(),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            context.read<AppProvider>().getName,
                                            style: const TextStyle(color: MaterialColors.black, fontFamily: "SF Bold", fontSize: 22),
                                          ),
                                          Padding(padding: EdgeInsets.all(2)),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Chỉnh sửa tài khoản",
                                                style: const TextStyle(color: Colors.black54, fontFamily: "SF Medium", fontSize: 15),
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
                          padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
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
                                      style: TextStyle(color: MaterialColors.black, fontFamily: "SF Bold", fontSize: 18),
                                    ),
                                    Padding(padding: EdgeInsets.all(3)),
                                    Text(
                                      "Tắt để tạm dừng các đơn hàng đến.",
                                      style: TextStyle(color: Colors.black45, fontFamily: "SF Regular", fontSize: 15),
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
                                    style: TextStyle(color: status ? Colors.green : Colors.amber, fontFamily: "SF Bold", fontSize: 18),
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
                                      onToggle: (val) => handleToggle(val)),
                                ],
                              ),
                            ],
                          )),
                      Container(color: MaterialColors.grey, padding: const EdgeInsets.all(5)),
                      Container(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "Cài đặt",
                              style: TextStyle(color: Colors.black54, fontFamily: "SF Medium", fontSize: 17),
                            ),
                            const Padding(padding: EdgeInsets.all(15)),
                            Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                                      style: TextStyle(color: Colors.black87, fontFamily: "SF SemiBold", fontSize: 16),
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
                            Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black12, width: 1))), margin: EdgeInsets.only(top: 20, bottom: 20)),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, '/order-history');
                              },
                              child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.history,
                                      size: 24,
                                    ),
                                    Padding(padding: EdgeInsets.all(8)),
                                    Text(
                                      "Lịch sử đơn hàng",
                                      style: TextStyle(color: Colors.black87, fontFamily: "SF SemiBold", fontSize: 16),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 16,
                                  color: Colors.black45,
                                ),
                              ]),
                            ),
                            Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black12, width: 1))), margin: const EdgeInsets.only(top: 20, bottom: 20)),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, '/change-password');
                              },
                              child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.privacy_tip_outlined,
                                      size: 24,
                                    ),
                                    Padding(padding: EdgeInsets.all(8)),
                                    Text(
                                      "Đổi mật khẩu",
                                      style: TextStyle(color: Colors.black87, fontFamily: "SF SemiBold", fontSize: 16),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 16,
                                  color: Colors.black45,
                                ),
                              ]),
                            ),
                            Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black12, width: 1))), margin: const EdgeInsets.only(top: 20, bottom: 20)),
                            InkWell(
                              onTap: () {
                                Dialogs.materialDialog(
                                    dialogShape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                    // msg: 'Bạn có chắc',
                                    msgAlign: TextAlign.center,
                                    title: "Bạn có chắc muốn đăng xuất?",
                                    color: Colors.white,
                                    context: context,
                                    actions: [
                                      // IconsOutlineButton(
                                      //   onPressed: () {
                                      //     Navigator.pop(context);
                                      //   },
                                      //   text: 'Hủy',
                                      //   textStyle: TextStyle(color: Colors.grey),
                                      //   iconColor: Colors.grey,
                                      // ),
                                      Container(
                                          decoration: const BoxDecoration(color: Colors.white),
                                          // padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                                          width: MediaQuery.of(context).size.width,
                                          child: SizedBox(
                                            height: 38,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context).size.width,
                                                // padding: const EdgeInsets.symmetric(vertical: 5),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                    boxShadow: <BoxShadow>[BoxShadow(color: Colors.grey.shade200, offset: const Offset(2, 4), blurRadius: 5, spreadRadius: 2)],
                                                    gradient: const LinearGradient(
                                                        begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color.fromRGBO(220, 220, 220, 1), Color.fromRGBO(200, 200, 200, 1)])),
                                                child: const Text(
                                                  'Đóng',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black54,
                                                    height: 1,
                                                    fontFamily: "SF SemiBold",
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )),

                                      Container(
                                          decoration: const BoxDecoration(color: Colors.white),
                                          // padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                                          width: MediaQuery.of(context).size.width,
                                          child: SizedBox(
                                            height: 38,
                                            child: InkWell(
                                              onTap: () {
                                                handleLogout();
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context).size.width,
                                                // padding: const EdgeInsets.symmetric(vertical: 5),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                    boxShadow: <BoxShadow>[BoxShadow(color: Colors.grey.shade200, offset: const Offset(2, 4), blurRadius: 5, spreadRadius: 2)],
                                                    gradient: const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [MaterialColors.primary, Color(0xfff7892b)])),
                                                child: const Text(
                                                  'Đăng xuất',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                    height: 1,
                                                    fontFamily: "SF SemiBold",
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ))
                                    ]);
                              },
                              child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.logout,
                                      size: 24,
                                    ),
                                    const Padding(padding: EdgeInsets.all(8)),
                                    const Text(
                                      "Đăng xuất",
                                      style: TextStyle(color: Colors.black87, fontFamily: "SF SemiBold", fontSize: 16),
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
              child: SpinKitDualRing(
                color: MaterialColors.primary,
                size: 40.0,
              ),
            )
        ],
      );
    });
  }
}
