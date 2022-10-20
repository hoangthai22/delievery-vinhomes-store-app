import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store_app/constants/Theme.dart';

class AccordionMenu extends StatefulWidget {
  const AccordionMenu(
      {Key? key,
      required this.content,
      required this.title,
      required this.count})
      : super(key: key);
  final String title;
  final String count;

  final Widget content;
  @override
  _AccordionMenuState createState() => _AccordionMenuState();
}

class _AccordionMenuState extends State<AccordionMenu> {
  bool _showContent = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(children: [
        InkWell(
          onTap: () {
            setState(() {
              _showContent = !_showContent;
            });
          },
          child: ListTile(
              // contentPadding: EdgeInsets.only(left: 15),
              title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontFamily: "SF SemiBold",
                  fontSize: 16,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              Padding(padding: EdgeInsets.all(5)),
              Container(
                child: Row(children: [
                  Text(
                    widget.count + " món",
                    style: TextStyle(
                      fontFamily: "SF Medium",
                      fontSize: 14,
                      color: Colors.black45,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Padding(padding: EdgeInsets.all(5)),
                  Icon(
                      _showContent
                          ? Icons.keyboard_arrow_up_outlined
                          : Icons.keyboard_arrow_down_outlined,
                      color: Colors.black45),
                ]),
              )
            ],
          )),
        ),
        _showContent
            ? Container(
                child: widget.content,
              )
            : Container()
      ]),
    );
  }
}
