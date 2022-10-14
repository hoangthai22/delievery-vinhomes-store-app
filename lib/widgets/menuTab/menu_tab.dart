import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:store_app/widgets/accordion/accordion_menu.dart';
import 'package:store_app/widgets/accordion/accordion_menu_item.dart';

class MenuTab extends StatefulWidget {
  const MenuTab({Key? key}) : super(key: key);

  @override
  _MenuTabState createState() => _MenuTabState();
}

class _MenuTabState extends State<MenuTab> {
  bool status = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
          child: Container(
        margin: EdgeInsets.only(bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 25, left: 15, right: 15, bottom: 15),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(children: [
                        Text(
                          "Menu 1 ",
                          style: TextStyle(
                              fontFamily: "SF SemiBold", fontSize: 18),
                        ),
                        Text(
                          " (8 Danh mục)",
                          style:
                              TextStyle(fontFamily: "SF Regular", fontSize: 16),
                        )
                      ]),
                    ),
                    Container(
                      child: Row(children: [
                        Text(
                          "Đổi menu",
                          style: TextStyle(
                              fontFamily: "SF SemiBold",
                              fontSize: 18,
                              color: Colors.blue),
                        ),
                      ]),
                    )
                  ]),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              // padding: EdgeInsets.only(top: 25, left: 15, right: 15, bottom: 15),
              color: Colors.white,
              child: AccordionMenu(
                count: "8 món",
                content: Container(
                    margin: EdgeInsets.only(
                        top: 0, left: 30, right: 15, bottom: 15),
                    child: Column(
                      children: [
                        AccordionMenuItem(
                          name: "Combo ga nguyen con",
                          price: "100.000",
                          isActive: true,
                        ),
                        AccordionMenuItem(
                          name: "Combo ga nguyen con",
                          price: "100.000",
                          isActive: true,
                        ),
                        AccordionMenuItem(
                          name: "Combo ga nguyen con",
                          price: "100.000",
                          isActive: false,
                        ),
                      ],
                    )),
                title: "Gà Rán",
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              // padding: EdgeInsets.only(top: 25, left: 15, right: 15, bottom: 15),
              color: Colors.white,
              child: AccordionMenu(
                count: "8 món",
                content: Container(
                    margin: EdgeInsets.only(
                        top: 0, left: 30, right: 15, bottom: 15),
                    child: Column(
                      children: [
                        AccordionMenuItem(
                          name: "Combo ga nguyen con",
                          price: "100.000",
                          isActive: true,
                        ),
                        AccordionMenuItem(
                          name: "Combo ga nguyen con",
                          price: "100.000",
                          isActive: true,
                        ),
                        AccordionMenuItem(
                          name: "Combo ga nguyen con",
                          price: "100.000",
                          isActive: false,
                        ),
                      ],
                    )),
                title: "Gà Rán",
              ),
            ),
          ],
        ),
      )),
    );
  }
}
