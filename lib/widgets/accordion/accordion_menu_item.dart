import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class AccordionMenuItem extends StatefulWidget {
  String name;
  String price;
  String image;
  bool isActive;
  bool isBorder;
  AccordionMenuItem(
      {Key? key,
      required this.name,
      required this.price,
      required this.isBorder,
      required this.image,
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
                child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  // width: 100,
                  // padding: EdgeInsets.only(left: 10),
                  child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),

                      // padding: const EdgeInsets.only(right: 15, left: 0),
                      child: Image(
                        // color:70olors.red,
                        height: 55,
                        width: 55,
                        fit: BoxFit.cover,
                        image: NetworkImage(widget.image),
                      )),
                ),
                Padding(padding: EdgeInsets.all(5)),
                Expanded(
                    child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        maxLines: 1,
                        widget.name,
                        style: TextStyle(
                          fontFamily: "SF Medium",
                          overflow: TextOverflow.ellipsis,
                          fontSize: 16,
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(3)),
                      Text(
                        widget.price + "đ",
                        style: TextStyle(
                            fontFamily: "SF Medium",
                            fontSize: 15,
                            color: Colors.black45),
                      )
                    ],
                  ),
                ))
              ],
            )),
          ),
          Container(
            child: FlutterSwitch(
              width: 50.0,
              height: 25.0,
              valueFontSize: 15.0,
              toggleSize: 17.0,
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
