import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store_app/constants/Theme.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        title: Text(
          "Home",
          style: TextStyle(color: MaterialColors.black),
        ),
      ),
      body: Container(
          child: InkWell(
        child: Center(
          child: Text("Hello"),
        ),
      )),
    );
  }
}
