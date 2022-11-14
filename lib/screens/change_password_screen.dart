import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:store_app/constants/Theme.dart';
import 'package:store_app/provider/appProvider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController _oldPass = TextEditingController();
  TextEditingController _newPass = TextEditingController();
  TextEditingController _confirmNewPass = TextEditingController();
  bool isloading = false;
  final _formKey = GlobalKey<FormState>();
  hanldeSubmit(String userId) async {
    setState(() {
      isloading = true;
    });
    print(userId);
    print(_oldPass.text);
    print(_newPass.text);
    print(_confirmNewPass.text);

    //Create an instance of the current user.
    var user = FirebaseAuth.instance.currentUser!;
    //Must re-authenticate user before updating the password. Otherwise it may fail or user get signed out.

    try {
      final cred =
          EmailAuthProvider.credential(email: userId, password: _oldPass.text);
      await user.reauthenticateWithCredential(cred).then((value) async {
        await user.updatePassword(_newPass.text).then((_) {
          setState(() {
            isloading = false;
            Navigator.pop(context);
          });
          Fluttertoast.showToast(
              msg: "Đổi mật khẩu thành công",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
        }).catchError((error) {
          print("error" + error);
          setState(() {
            isloading = false;
          });
        });
      }).catchError((err) {
        print("err" + err);
        setState(() {
          isloading = false;
        });
      });
    } on FirebaseAuthException catch (error) {
      print("errorFirebase: " + error.message.toString());
      setState(() {
        isloading = false;
      });
      Fluttertoast.showToast(
          msg: "Mật khẩu cũ không đúng",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      print("e " + e.toString());
      Fluttertoast.showToast(
          msg: "Mật khẩu cũ không đúng",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      print(e);
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, provider, child) {
      return Scaffold(
          appBar: new AppBar(
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            centerTitle: true,
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),
            title: Text(
              "Thay đổi mật khẩu",
              style: TextStyle(
                color: MaterialColors.black,
                fontFamily: "SF Bold",
              ),
            ),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                  child: Form(
                key: _formKey,
                child: Container(
                  padding:
                      EdgeInsets.only(left: 15, right: 15, top: 30, bottom: 15),
                  child: Column(children: [
                    Row(
                      children: [
                        Text(
                          "Nhập lại mật khẩu cũ",
                          style: TextStyle(
                            fontFamily: "SF Semibold",
                            fontSize: 18,
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(2)),
                        Text(
                          "*",
                          style: TextStyle(color: Colors.red, fontSize: 20),
                        )
                      ],
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Mật khẩu cũ không được để trống";
                        } else if (value.length < 6) {
                          return "Mật khẩu phải dài hơn 6 ký tự";
                        }
                        return null;
                      },

                      decoration: InputDecoration(
                        hintStyle: TextStyle(fontSize: 16),
                        hintText: 'Mật khẩu cũ',
                      ),
                      controller: _oldPass,
                      // controller: _name != null
                      //     ? TextEditingController(text: _name)
                      //     : null,
                      // initialValue: _name != null ? _name : null,

                      onChanged: (e) => {
                        // setState(() => {_name.text = e})
                      },
                      obscureText: true,
                    ),
                    Padding(padding: EdgeInsets.all(15)),
                    Row(
                      children: [
                        Text(
                          "Mật khẩu mới",
                          style: TextStyle(
                            fontFamily: "SF Semibold",
                            fontSize: 18,
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(2)),
                        Text(
                          "*",
                          style: TextStyle(color: Colors.red, fontSize: 20),
                        )
                      ],
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Mật khẩu mới không được để trống";
                        } else if (value.length < 6) {
                          return "Mật khẩu phải dài hơn 6 ký tự";
                        }
                        return null;
                      },

                      decoration: InputDecoration(
                        hintStyle: TextStyle(fontSize: 16),
                        hintText: 'Mật khẩu mới',
                      ),
                      controller: _newPass,
                      // controller: _name != null
                      //     ? TextEditingController(text: _name)
                      //     : null,
                      // initialValue: _name != null ? _name : null,

                      onChanged: (e) => {
                        // setState(() => {_name.text = e})
                      },
                      obscureText: true,
                    ),
                    Padding(padding: EdgeInsets.all(15)),
                    Row(
                      children: [
                        Text(
                          "Nhập lại mật khẩu mới",
                          style: TextStyle(
                            fontFamily: "SF Semibold",
                            fontSize: 18,
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(2)),
                        Text(
                          "*",
                          style: TextStyle(color: Colors.red, fontSize: 20),
                        )
                      ],
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Mật khẩu mới không được để trống";
                        } else if (value != _newPass.text) {
                          return "Mật khẩu nhập lại không khớp";
                        } else if (value.length < 6) {
                          return "Mật khẩu phải dài hơn 6 ký tự";
                        }
                        return null;
                      },

                      decoration: InputDecoration(
                        hintStyle: TextStyle(fontSize: 16),
                        hintText: 'Nhập lại mật khẩu mới',
                      ),
                      controller: _confirmNewPass,
                      // controller: _name != null
                      //     ? TextEditingController(text: _name)
                      //     : null,
                      // initialValue: _name != null ? _name : null,

                      onChanged: (e) => {
                        // setState(() => {_name.text = e})
                      },
                      obscureText: true,
                    ),
                    Padding(padding: EdgeInsets.all(30)),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          height: 45,
                          child: ElevatedButton(
                            child: Text(
                              "Đổi mật khẩu",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "SF Bold",
                                  fontSize: 18),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: MaterialColors.primary,
                              textStyle: TextStyle(color: Colors.black),
                              shadowColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () => {
                              if (_formKey.currentState!.validate())
                                {
                                  hanldeSubmit(
                                      context.read<AppProvider>().getUserId ??
                                          "")
                                },
                            },
                          ),
                        )),
                  ]),
                ),
              )),
              if (isloading)
                Positioned(
                  child: Container(
                    color: Colors.white.withOpacity(0.5),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: SpinKitDualRing(
                      color: MaterialColors.primary,
                      size: 50.0,
                    ),
                  ),
                ),
            ],
          ));
    });
  }
}
