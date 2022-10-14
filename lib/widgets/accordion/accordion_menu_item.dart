import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class AccordionMenuItem extends StatefulWidget {
  String name;
  String price;
  bool isActive;
  AccordionMenuItem(
      {Key? key,
      required this.name,
      required this.price,
      required this.isActive})
      : super(key: key);

  @override
  _AccordionMenuItemState createState() => _AccordionMenuItemState();
}

class _AccordionMenuItemState extends State<AccordionMenuItem> {
  bool status = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      status = widget.isActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12, width: 1))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.name,
                  style: TextStyle(
                    fontFamily: "SF SemiBold",
                    fontSize: 17,
                  ),
                ),
                Padding(padding: EdgeInsets.all(2)),
                Text(
                  widget.price + "đ",
                  style: TextStyle(
                      fontFamily: "SF Medium",
                      fontSize: 17,
                      color: Colors.black45),
                )
              ],
            ),
          ),
          Container(
            child: FlutterSwitch(
              width: 60.0,
              height: 30.0,
              valueFontSize: 15.0,
              toggleSize: 25.0,
              value: status,
              borderRadius: 30.0,
              padding: 5.0,
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
      ),
    );
  }
}
