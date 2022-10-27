import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:url_launcher/url_launcher.dart';

class CancelConfirmOrderScreen extends StatefulWidget {
  const CancelConfirmOrderScreen({Key? key}) : super(key: key);

  @override
  _CancelConfirmOrderScreenState createState() =>
      _CancelConfirmOrderScreenState();
}

class _CancelConfirmOrderScreenState extends State<CancelConfirmOrderScreen> {
  Future<void> _makePhoneCall(String phoneNumber) async {
    if (phoneNumber != "") {
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: phoneNumber,
      );
      await launchUrl(launchUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(top: 30, bottom: 15, left: 15, right: 15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back_ios),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Vui lòng gọi cho khách để hủy đơn",
                          style: const TextStyle(
                              fontFamily: "SF Bold",
                              fontSize: 24,
                              color: Colors.black)),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(229, 243, 253, 1),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        padding: EdgeInsets.only(
                            left: 15, right: 15, bottom: 20, top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Văn Dương",
                                    style: const TextStyle(
                                        fontFamily: "SF Medium",
                                        fontSize: 16,
                                        color: Colors.black)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text("+0938328238",
                                    style: const TextStyle(
                                        fontFamily: "SF Bold",
                                        fontSize: 20,
                                        color: Colors.black))
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                _makePhoneCall("0353270393");
                              },
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                    color: Color.fromRGBO(39, 171, 220, 1)),
                                child: Icon(
                                  Icons.phone,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 30, top: 30),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Color.fromRGBO(230, 230, 230, 1)))),
                      ),
                      Text("Bạn có muốn chúng tôi gợi ý?",
                          style: const TextStyle(
                              fontFamily: "SF Bold",
                              fontSize: 18,
                              color: Colors.black)),
                      Container(
                        margin: const EdgeInsets.only(bottom: 15),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(230, 230, 230, 1),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        padding: EdgeInsets.only(
                            left: 15, right: 15, bottom: 20, top: 20),
                        child: Text(
                          "Chào bạn, rất tiếc phải thông báo rằng quán đã hết món mà bạn đặt. Quán mình sẽ hủy đơn nên quý bạn sẽ không bị tính phí nhé! Mình sẽ cập nhật thực đơn nên nếu bạn muốn thử món khác thì hãy quay lại và đặt đơn nhé.",
                          style: TextStyle(
                              fontFamily: "SF Reuglar",
                              fontSize: 16,
                              height: 1.5,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height - 505,
                  child: SlideAction(
                    alignment: Alignment.bottomCenter,
                    textStyle: TextStyle(
                        fontSize: 18,
                        fontFamily: "SF Bold",
                        color: Colors.white),
                    // innerColor: Color.fromRGBO(219, 98, 71, 1),
                    outerColor: Color.fromRGBO(219, 98, 71, 1),
                    text: "Xác nhận hủy",
                    height: 55,
                    sliderButtonIconSize: 27,
                    sliderRotate: false,
                    sliderButtonIconPadding: 10,
                    sliderButtonYOffset: -3,
                    onSubmit: () {
                      Future.delayed(
                        Duration(milliseconds: 500),
                        () => {
                          Navigator.pop(context),
                          Fluttertoast.showToast(
                              msg: "Đơn hàng của bạn đã hủy thành công.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0),
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          )),
    );
  }
}
