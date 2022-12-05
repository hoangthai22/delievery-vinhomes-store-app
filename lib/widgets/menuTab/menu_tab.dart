import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:store_app/apis/apiService.dart';
import 'package:store_app/constants/Theme.dart';
import 'package:store_app/models/menuDetailModel.dart';
import 'package:store_app/models/menuModel.dart';
import 'package:store_app/provider/appProvider.dart';
import 'package:store_app/widgets/accordion/accordion_menu.dart';
import 'package:store_app/widgets/accordion/accordion_menu_item.dart';
import 'package:store_app/widgets/modals/menu_modal.dart';

class MenuTab extends StatefulWidget {
  String menuIndex;
  String storeId;
  MenuTab({Key? key, required this.menuIndex, required this.storeId}) : super(key: key);

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
                  ApiServices.getListProductByMenu(list.elementAt(0).id, widget.storeId, 1, 20).then((value) => {
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
    ApiServices.getListProductByMenu(menuId, widget.storeId, 1, 20).then((value) => {
          if (value != null)
            {
              setState(() {
                print(value);
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

  void showMemberInfo(menuId, context, storeId) {
    return _Modal(context, menuId, storeId);
  }

  void _Modal(context, menuId, storeId) {
    print(storeId);
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(15.0))),
        builder: (BuildContext bc) {
          return MenuModal(
              storeId: storeId,
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
    return Consumer<AppProvider>(builder: (context, provider, child) {
      bool isActiveStore = context.read<AppProvider>().getStatus;
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
                        margin: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 10),
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              // width: MediaQuery.of(context).size.width,
                              child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                                          padding: EdgeInsets.only(bottom: 10, top: 10, left: 15, right: 15),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: tabActive == index ? MaterialColors.secondary : Colors.white,
                                              borderRadius: BorderRadius.all(Radius.circular(8)),
                                              border: Border.all(
                                                color: tabActive == index ? Colors.white : MaterialColors.secondary,
                                              )),
                                          child: Text(
                                            pro.name.toString(),
                                            style: TextStyle(color: tabActive == index ? Colors.white : MaterialColors.secondary, fontFamily: "SF SemiBold", fontSize: 16),
                                          )),
                                    );
                                  }),
                              ]),
                            ))),
                    if (menus.isNotEmpty)
                      Container(
                        margin: EdgeInsets.only(top: 25, left: 15, right: 15, bottom: 15),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Container(
                            child: Row(children: [
                              Text(
                                menus[tabActive].name!,
                                style: TextStyle(fontFamily: "SF SemiBold", fontSize: 18),
                              ),
                              Padding(padding: EdgeInsets.all(2)),
                              Text(
                                "(" + menuDetailList.length.toString() + " Danh mục)",
                                style: TextStyle(fontFamily: "SF Regular", fontSize: 15),
                              )
                            ]),
                          ),
                          InkWell(
                            onTap: () {
                              showMemberInfo(menuId, context, context.read<AppProvider>().getUserId);
                            },
                            child: Container(
                              child: Row(children: [
                                Text(
                                  "Thêm món",
                                  style: TextStyle(fontFamily: "SF SemiBold", fontSize: 18, color: MaterialColors.secondary),
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
                          decoration: BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Colors.black12, width: 1))),
                          child: AccordionMenu(
                            count: menu.listProducts!.length.toString(),
                            content: Container(
                                margin: EdgeInsets.only(top: 0, left: 30, right: 15, bottom: 15),
                                child: Column(
                                  children: [
                                    if (menu.listProducts!.isNotEmpty)
                                      ...menu.listProducts!.map((dynamic item) {
                                        var index = menu.listProducts!.indexOf(item);
                                        return AccordionMenuItem(
                                          callBack: () {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            ApiServices.deleteProductInMenu(item["id"], menuId)
                                                .then(
                                                  (value) => {getListProductByMenu(menuId)},
                                                )
                                                .catchError((err) => {
                                                      setState(() {
                                                        isLoading = false;
                                                      })
                                                    });
                                          },
                                          isBorder: index == menu.listProducts!.length - 1 ? false : true,
                                          name: item["name"],
                                          image: item["image"],
                                          isActiveStore: isActiveStore,
                                          price: currencyFormatter.format((item["pricePerPack"]!).toInt()).toString(),
                                          isActive: item["status"],
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
              size: 45.0,
            ),
          ],
        ],
      );
    });
  }
}
