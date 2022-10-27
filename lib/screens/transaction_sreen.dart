import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store_app/constants/Theme.dart';
import 'package:url_launcher/url_launcher.dart';

class TransactionSreen extends StatefulWidget {
  const TransactionSreen({Key? key}) : super(key: key);

  @override
  _TransactionSreenState createState() => _TransactionSreenState();
}

class _TransactionSreenState extends State<TransactionSreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        centerTitle: true,
        title: Text(
          "Giao dịch",
          style: TextStyle(color: MaterialColors.black, fontFamily: "SF Bold"),
        ),
        // bottom:
      ),
      body: new Center(
        child: TextButton(onPressed: () => {}, child: new Text("Call me")),
      ),
    );
  }
}
