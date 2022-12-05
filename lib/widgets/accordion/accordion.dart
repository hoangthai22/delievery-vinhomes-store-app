import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store_app/constants/Theme.dart';

class Accordion extends StatefulWidget {
  const Accordion({Key? key, required this.content, required this.title})
      : super(key: key);
  final String title;
  final Widget content;
  @override
  _AccordionState createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> {
  bool _showContent = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        color: Colors.white,
        child: Column(children: [
          ListTile(
              contentPadding: EdgeInsets.only(left: 15),
              title: InkWell(
                onTap: () {
                  setState(() {
                    _showContent = !_showContent;
                  });
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontFamily: "SF SemiBold",
                        fontSize: 18,
                        color: MaterialColors.secondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Padding(padding: EdgeInsets.all(5)),
                    Icon(
                        _showContent
                            ? Icons.keyboard_arrow_up_outlined
                            : Icons.keyboard_arrow_down_outlined,
                        color: MaterialColors.secondary),
                  ],
                ),
              )),
          _showContent
              ? Container(
                  child: widget.content,
                )
              : Container()
        ]),
      ),
    );
  }
}
