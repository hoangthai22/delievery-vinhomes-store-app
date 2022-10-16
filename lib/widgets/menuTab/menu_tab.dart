import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:store_app/apis/apiService.dart';
import 'package:store_app/constants/Theme.dart';
import 'package:store_app/models/menuDetailModel.dart';
import 'package:store_app/models/menuModel.dart';
import 'package:store_app/widgets/accordion/accordion_menu.dart';
import 'package:store_app/widgets/accordion/accordion_menu_item.dart';
import 'package:store_app/widgets/modals/menu_modal.dart';

class MenuTab extends StatefulWidget {
  String menuIndex;
  MenuTab({Key? key, required this.menuIndex}) : super(key: key);

  @override
  _MenuTabState createState() => _MenuTabState();
}

class _MenuTabState extends State<MenuTab> {
  List<MenuModel> menus = [];
  List<MenuDetailModel> menuDetailList = [];
  int tabActive = 0;
  String menuId = "";
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List<MenuModel> list = [];
    ApiServices.getListMenuByMode(widget.menuIndex ?? "0").then((value) => {
          if (value != null)
            {
              list = value,
              setState(() {
                menus = value;
              }),
              if (list.isNotEmpty)
                {
                  setState(() {
                    menuId = list.elementAt(0).id.toString();
                  }),
                  ApiServices.getListProductByMenu(
                          list.elementAt(0).id, "s4", 1, 20)
                      .then((value) => {
                            if (value != null)
                              {
                                setState(() {
                                  menuDetailList = value;
                                  isLoading = false;
                                })
                              }
                            else
                              {
                                setState(() {
                                  menuDetailList = [];
                                  isLoading = false;
                                })
                              }
                          })
                }
              else
                {
                  setState(() {
                    menuDetailList = [];
                    isLoading = false;
                  })
                }
            }
          else
            {
              setState(() {
                menus = [];
                isLoading = false;
              })
            }
        });
  }

  void getListProductByMenu(menuId) {
    setState(() {
      // menus = [];
      isLoading = true;
    });
    ApiServices.getListProductByMenu(menuId, "s4", 1, 20).then((value) => {
          if (value != null)
            {
              setState(() {
                menuDetailList = value;
                isLoading = false;
              })
            }
          else
            {
              setState(() {
                menuDetailList = [];
                isLoading = false;
              })
            }
        });
  }

  void showMemberInfo(menuId) {
    return _Modal(context, menuId);
  }

  void _Modal(context, menuId) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0))),
        builder: (BuildContext bc) {
          return MenuModal(
              menuId: menuId,
              function: (func) {
                getListProductByMenu(menuId);
              });
        });
  }

  bool status = true;
  @override
  Widget build(BuildContext context) {
    // print("menus" + menuDetailList.toString());
    // menuDetailList.elementAt(2).listProducts!.map((item) {
    //   print(item);
    // });
    final currencyFormatter = NumberFormat('#,##0', 'ID');
    return Stack(
      children: [
        if (!isLoading)
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      margin: EdgeInsets.only(
                          top: 20, left: 15, right: 15, bottom: 10),
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            // width: MediaQuery.of(context).size.width,
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (menus.length > 0)
                                    ...menus.map((MenuModel pro) {
                                      var index = menus.indexOf(pro);
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            tabActive = index;
                                            getListProductByMenu(pro.id);
                                            menuId = pro.id.toString();
                                          });
                                        },
                                        child: Container(
                                            margin: EdgeInsets.only(right: 15),
                                            padding: EdgeInsets.only(
                                                bottom: 10,
                                                top: 10,
                                                left: 15,
                                                right: 15),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: tabActive == index
                                                    ? MaterialColors.secondary
                                                    : Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8)),
                                                border: Border.all(
                                                  color: tabActive == index
                                                      ? Colors.white
                                                      : MaterialColors
                                                          .secondary,
                                                )),
                                            child: Text(
                                              "Buổi sáng",
                                              style: TextStyle(
                                                  color: tabActive == index
                                                      ? Colors.white
                                                      : MaterialColors
                                                          .secondary,
                                                  fontFamily: "SF Bold",
                                                  fontSize: 17),
                                            )),
                                      );
                                    }),
                                ]),
                          ))),
                  if (menus.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(
                          top: 25, left: 15, right: 15, bottom: 15),
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
                                Padding(padding: EdgeInsets.all(2)),
                                Text(
                                  "(" +
                                      menuDetailList.length.toString() +
                                      " Danh mục)",
                                  style: TextStyle(
                                      fontFamily: "SF Regular", fontSize: 15),
                                )
                              ]),
                            ),
                            InkWell(
                              onTap: () {
                                showMemberInfo(menuId);
                              },
                              child: Container(
                                child: Row(children: [
                                  Text(
                                    "Thêm món",
                                    style: TextStyle(
                                        fontFamily: "SF SemiBold",
                                        fontSize: 18,
                                        color: MaterialColors.secondary),
                                  ),
                                ]),
                              ),
                            )
                          ]),
                    ),
                  if (menuDetailList.isNotEmpty)
                    ...menuDetailList.map((MenuDetailModel menu) {
                      if (menu.listProducts!.isNotEmpty) {}
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(top: 3, bottom: 3),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.black12, width: 1))),
                        child: AccordionMenu(
                          count: menu.listProducts!.length.toString(),
                          content: Container(
                              margin: EdgeInsets.only(
                                  top: 0, left: 30, right: 15, bottom: 15),
                              child: Column(
                                children: [
                                  if (menu.listProducts!.isNotEmpty)
                                    ...menu.listProducts!.map((dynamic item) {
                                      var index =
                                          menu.listProducts!.indexOf(item);
                                      return AccordionMenuItem(
                                        isBorder: index ==
                                                menu.listProducts!.length - 1
                                            ? false
                                            : true,
                                        name: item["name"],
                                        price: currencyFormatter
                                            .format(
                                                (item["pricePerPack"]!).toInt())
                                            .toString(),
                                        isActive: true,
                                      );
                                    })
                                ],
                              )),
                          title: menu.name.toString(),
                        ),
                      );
                    }),
                ],
              ),
            ),
          ),
        if (isLoading) ...[
          SpinKitDualRing(
            color: MaterialColors.primary,
            size: 50.0,
          ),
        ],
      ],
    );
  }
}
