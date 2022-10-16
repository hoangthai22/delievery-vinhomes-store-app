import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class AccordionMenuItem extends StatefulWidget {
  String name;
  String price;
  bool isActive;
  bool isBorder;
  AccordionMenuItem(
      {Key? key,
      required this.name,
      required this.price,
      required this.isBorder,
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
      decoration: widget.isBorder
          ? BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: Colors.black12, width: 1)))
          : null,
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
                    fontFamily: "SF Medium",
                    fontSize: 17,
                  ),
                ),
                Padding(padding: EdgeInsets.all(2)),
                Text(
                  widget.price + "đ",
                  style: TextStyle(
                      fontFamily: "SF Medium",
                      fontSize: 16,
                      color: Colors.black45),
                )
              ],
            ),
          ),
          Container(
            child: FlutterSwitch(
              width: 55.0,
              height: 25.0,
              valueFontSize: 15.0,
              toggleSize: 20.0,
              value: status,
              borderRadius: 30.0,
              padding: 4.0,
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
