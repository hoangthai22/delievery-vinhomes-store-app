import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:store_app/apis/apiService.dart';
import 'package:store_app/constants/Theme.dart';
import 'package:store_app/models/productMenuModel.dart';
import 'package:store_app/widgets/modals/menu_modal_item.dart';

class CheckedItem {
  String id;
  double price;
  CheckedItem({
    required this.id,
    required this.price,
  });

  CheckedItem.fromJson(Map<String, dynamic> json)
      : id = json['n'],
        price = json['u'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'price': price,
    };
  }

  // factory CheckedItem.fromJson(Map<String, dynamic> json) {
  //   return CheckedItem(
  //     id: json['id'],
  //     price: json['price'] == null ? 0.0 : json['price'].toDouble(),
  //   );
  // }
}

class MenuModal extends StatefulWidget {
  late ValueChanged<void> function;
  late String menuId;
  late String storeId;
  MenuModal(
      {required this.function, required this.menuId, required this.storeId});
  @override
  State<StatefulWidget> createState() => _MenuModal();
}

class _MenuModal extends State<MenuModal> {
  List<ProductMenuModel> productOutOfMenus = [];
  List<CheckedItem> productCheckedList = [];
  bool _isLoadingCircle = true;
  bool _isLoadingSubmit = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ApiServices.getListProductOutOfMenu(widget.menuId, widget.storeId, 1, 100)
        .then((value) => {
              if (value != null)
                {
                  setState(
                    () => {productOutOfMenus = value, _isLoadingCircle = false},
                  )
                }
              else
                {
                  setState(() {
                    setState(() {
                      _isLoadingCircle = false;
                    });
                  })
                }
            });
    // print(widget.id);
  }

  bool checkInclude(ele, arr) {
    for (var index = 0; index < arr.length; index++) {
      if (arr[index].id == ele) {
        return true;
      }
    }
    return false;
  }

  hanldeCallback() {
    setState(() {
      _isLoadingSubmit = true;
    });
    ApiServices.postJoinMenu(productCheckedList, widget.menuId)
        .then((value) => {
              if (value != null)
                {
                  Navigator.pop(context),
                  setState(() {
                    _isLoadingSubmit = false;
                  }),
                  widget.function("")
                }
              else
                {
                  setState(() {
                    _isLoadingSubmit = false;
                  })
                }
            });
  }

  hanldeChecked(id) {
    // print(id);
    if (checkInclude(id, productCheckedList)) {
      for (var index = 0; index < productCheckedList.length; index++) {
        if (productCheckedList[index].id == id) {
          setState(() {
            productCheckedList.remove(productCheckedList[index]);
          });
        }
      }
    } else {
      for (var i = 0; i < productOutOfMenus.length; i++) {
        if (productOutOfMenus[i].id == id) {
          setState(() {
            productCheckedList.add(CheckedItem(
                id: id, price: productOutOfMenus[i].pricePerPack!.toDouble()));
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height * 0.85,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 60),
          child: SingleChildScrollView(
            child: Column(
              // physics: NeverScrollableScrollPhysics(),

              children: <Widget>[
                if (!_isLoadingCircle) ...[
                  Container(
                      child: Text(
                    "Danh sách sản phẩm",
                    style: TextStyle(
                        color: MaterialColors.black,
                        fontFamily: "SF Bold",
                        fontSize: 20),
                  )),
                  if (productOutOfMenus.isNotEmpty)
                    ...productOutOfMenus.map(
                      (ProductMenuModel item) => MenuModalItem(
                        product: item,
                        function: (id) => {hanldeChecked(id)},
                      ),
                    )
                ]
              ],
            ),
          ),
        ),
        if (!_isLoadingCircle && productOutOfMenus.isEmpty)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.5 - 60,
            child: Center(
                child: Container(
              child: Column(
                children: [
                  Icon(Icons.no_food_rounded),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Không có sản phầm nào phù hợp",
                    style: TextStyle(
                        color: MaterialColors.black,
                        fontFamily: "SF Regular",
                        fontSize: 15),
                  )
                ],
              ),
            )),
          ),
        Positioned(
            bottom: 0,
            child: Container(
                decoration: BoxDecoration(color: Colors.white),
                padding:
                    EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 45,
                        child: ElevatedButton(
                          child: Text(
                            "Trờ lại",
                            style: TextStyle(
                                color: MaterialColors.primary,
                                fontFamily: "SF Bold",
                                fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            textStyle: TextStyle(color: Colors.black),
                            shadowColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: MaterialColors.primary, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => {Navigator.pop(context)},
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(7)),
                    Expanded(
                      child: Container(
                        height: 45,
                        child: ElevatedButton(
                            child: Text(
                              "Xác nhận",
                              style: TextStyle(
                                  color: productCheckedList.isNotEmpty
                                      ? Colors.black
                                      : Colors.black.withOpacity(0.5),
                                  fontFamily: "SF Bold",
                                  fontSize: 18),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: productCheckedList.isNotEmpty
                                  ? MaterialColors.primary
                                  : MaterialColors.primary.withOpacity(0.5),
                              textStyle: TextStyle(color: Colors.black),
                              shadowColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () => productCheckedList.isNotEmpty
                                ? hanldeCallback()
                                : null),
                      ),
                    ),
                  ],
                ))),
        if (_isLoadingSubmit) ...[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white.withOpacity(0.5),
            child: SpinKitRing(
              color: MaterialColors.primary,
              size: 50.0,
            ),
          )
        ],
        if (_isLoadingCircle)
          Center(
              child: Container(
                  margin: EdgeInsets.only(bottom: 20, top: 20),
                  child: CircularProgressIndicator(
                    strokeWidth: 5.0,
                    color: MaterialColors.primary,
                  ))),
      ],
    );
  }
}
