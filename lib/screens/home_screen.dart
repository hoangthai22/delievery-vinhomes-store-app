import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store_app/constants/Theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        onTap: () {
          Navigator.pushNamed(context, '/login');
        },
        child: Center(
          child: Text("Hello"),
        ),
      )),
    );
  }
}
