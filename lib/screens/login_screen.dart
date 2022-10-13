import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store_app/constants/Theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Color.fromARGB(255, 255, 255, 255),
            child: SafeArea(
              child: Container(
                  padding:
                      EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              padding: EdgeInsets.all(15),
                              width: 70,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 255, 255, 255),
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    color: MaterialColors.primary, width: 1),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  bottomLeft: Radius.circular(50),
                                  topRight: Radius.circular(50),
                                  bottomRight: Radius.circular(50),
                                ),
                                child: Image.asset(
                                  'assets/images/chef.png',
                                  fit: BoxFit.cover,
                                ),
                              )),
                          Container(
                            padding: EdgeInsets.only(
                              left: 15,
                            ),
                            child: Text(
                              "UNICO",
                              style: TextStyle(
                                  fontFamily: "SF Heavy",
                                  fontSize: 34,
                                  color: MaterialColors.primary),
                            ),
                          ),
                        ],
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * 1,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                          child: ClipRRect(
                            // borderRadius: BorderRadius.only(
                            //   topLeft: Radius.circular(50),
                            //   bottomLeft: Radius.circular(50),
                            //   topRight: Radius.circular(50),
                            //   bottomRight: Radius.circular(50),
                            // ),
                            child: Image.asset(
                              'assets/images/login.png',
                              fit: BoxFit.cover,
                            ),
                          )),
                      Container(
                        child: Column(
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                    child: Container(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width - 40,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: MaterialColors.primary,
                                      textStyle: TextStyle(
                                          color: MaterialColors.primary),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: Text(
                                      "Đăng nhập",
                                      style: TextStyle(
                                          fontFamily: 'SF Bold',
                                          fontSize: 17,
                                          color: MaterialColors.secondary),
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/register');
                                    },
                                  ),
                                ))),
                            Padding(padding: EdgeInsets.only(top: 20)),
                            Container(
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                    child: Container(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width - 40,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary:
                                          Color.fromARGB(255, 255, 255, 255),
                                      textStyle: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255)),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          side: BorderSide(
                                              width: 1,
                                              color: MaterialColors.primary)),
                                    ),
                                    child: Text(
                                      "Bạn là người mới? Đăng ký ngay",
                                      style: TextStyle(
                                          fontFamily: 'SF Bold',
                                          fontSize: 17,
                                          color: MaterialColors.secondary),
                                    ),
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(
                                          context, '/login');
                                    },
                                  ),
                                ))),
                            Padding(padding: EdgeInsets.only(top: 20)),
                            Container(
                                child: RichText(
                              text: TextSpan(
                                  text:
                                      "Bằng việc đăng ký hoặc đăng nhập, bạn đã đông ý với các ",
                                  style: TextStyle(
                                      color: MaterialColors.secondary,
                                      fontFamily: "SF Reugular",
                                      fontSize: 15),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Điều khoản dịch vụ ',
                                        style: TextStyle(
                                            color: MaterialColors.primary)),
                                    TextSpan(text: 'và '),
                                    TextSpan(
                                        text: 'Chính sách bảo mật',
                                        style: TextStyle(
                                            color: MaterialColors.primary)),
                                  ]),
                            ))
                          ],
                        ),
                      ),
                    ],
                  )),
            )));
  }
}
