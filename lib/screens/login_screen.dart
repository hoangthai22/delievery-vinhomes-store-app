import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/constants/Theme.dart';
import 'package:store_app/provider/appProvider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controllerUserName = TextEditingController();
  final _controllerPass = TextEditingController();
  String _textUserName = '';
  bool _validUserName = true;
  String _textPass = '';
  FirebaseAuth auth = FirebaseAuth.instance;

  String? _errorText(TextEditingController controller) {
    // at any time, we can get the text from _controller.value.text
    final text = controller.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (text == "") {
      return 'Không được để trống';
    }
    if (controller == _controllerPass && text.length < 6) {
      return 'Mật khẩu không dưới 6 ký tự';
    }
    // return null if the text is valid
    return null;
  }

  // void handleLogin() {
  //   if (_textUserName.isNotEmpty && _textPass.isNotEmpty) {
  //     try {
  //       User user;
  //       auth
  //           .signInWithEmailAndPassword(
  //               email: _textUserName, password: _textUserName)
  //           .then((value) => {
  //                 if (value.user != null)
  //                   {print("ok"), user = value.user!, print(user.email)}
  //               });
  //     } on FirebaseAuthException catch (e) {
  //       print(e.message);
  //       throw e;
  //     }
  //   }
  // }
  handleSignInEmail() {
    User user;
    auth
        .signInWithEmailAndPassword(email: _textUserName, password: _textPass)
        .then((value) => {
              if (value != null)
                {
                  user = value.user!,
                  context
                      .read<AppProvider>()
                      .setUserLogin(user.email.toString()),
                  print(user.email),
                  Navigator.pushNamed(context, '/home')
                }
            });
  }

  Widget _entryField(
      String title, String error, TextEditingController controller,
      {bool isPassword = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: "SF Bold",
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return error;
                }
                return null;
              },
              controller: controller,
              onChanged: (e) => {
                    if (controller == _controllerUserName)
                      {
                        setState(() => {_textUserName = e})
                      }
                    else if (controller == _controllerPass)
                      {
                        setState(() => {_textPass = e})
                      }
                  },
              obscureText: isPassword,
              decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        style: BorderStyle.none,
                        width: 0,
                      ),
                      borderRadius: BorderRadius.circular(8)),
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        style: BorderStyle.none,
                        width: 0,
                      ),
                      borderRadius: BorderRadius.circular(8)),
                  fillColor: Colors.black12,
                  filled: true))
        ],
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _entryField(
            "Tên đăng nhập",
            "Vui lòng nhập tên đăng nhập",
            _controllerUserName,
          ),
          _entryField(
            "Mật khẩu",
            "Vui lòng nhập mật khẩu",
            _controllerPass,
            isPassword: true,
          ),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () {
        if (_formKey.currentState!.validate()) {
          // Navigator.pushNamed(context, '/home');
          handleSignInEmail();
          print("_textUserName: " + _textUserName);
          print("_textPass: " + _textUserName);
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: const Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [MaterialColors.primary, Color(0xfff7892b)])),
        child: const Text(
          'Đăng nhập',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontFamily: "SF Bold",
          ),
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
          text: 'Vin',
          style: TextStyle(
              fontFamily: "SF Heavy",
              fontSize: 30,
              // fontWeight: FontWeight.w700,
              color: Color(0xffe46b10)),
          children: [
            TextSpan(
              text: 'GP ',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'Deliver',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Consumer<AppProvider>(builder: (context, provider, child) {
      return Scaffold(
          body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
                top: -height * .15,
                right: -MediaQuery.of(context).size.width * .4,
                child: const BezierContainer()),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    _title(),
                    const SizedBox(height: 50),
                    _emailPasswordWidget(),
                    const SizedBox(height: 20),
                    _submitButton(),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.centerRight,
                      child: const Text('Quên mật khẩu ?',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500)),
                    ),
                    SizedBox(height: height * .055),
                  ],
                ),
              ),
            ),
          ],
        ),
      ));
    });
  }
}

class BezierContainer extends StatelessWidget {
  const BezierContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Transform.rotate(
      angle: -pi / 3.5,
      child: ClipPath(
        clipper: ClipPainter(),
        child: Container(
          height: MediaQuery.of(context).size.height * .5,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [MaterialColors.primary, Color(0xffe46b10)])),
        ),
      ),
    ));
  }
}

class ClipPainter extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var height = size.height;
    var width = size.width;
    var path = new Path();

    path.lineTo(0, size.height);
    path.lineTo(size.width, height);
    path.lineTo(size.width, 0);

    /// [Top Left corner]
    var secondControlPoint = const Offset(0, 0);
    var secondEndPoint = Offset(width * .2, height * .3);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    /// [Left Middle]
    var fifthControlPoint = Offset(width * .3, height * .5);
    var fiftEndPoint = Offset(width * .23, height * .6);
    path.quadraticBezierTo(fifthControlPoint.dx, fifthControlPoint.dy,
        fiftEndPoint.dx, fiftEndPoint.dy);

    /// [Bottom Left corner]
    var thirdControlPoint = Offset(0, height);
    var thirdEndPoint = Offset(width, height);
    path.quadraticBezierTo(thirdControlPoint.dx, thirdControlPoint.dy,
        thirdEndPoint.dx, thirdEndPoint.dy);

    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
