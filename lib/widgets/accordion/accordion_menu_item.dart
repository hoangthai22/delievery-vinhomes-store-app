import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:store_app/apis/apiService.dart';
import 'package:store_app/constants/Theme.dart';
import 'package:store_app/screens/profile_screen.dart';
import 'package:material_dialogs/material_dialogs.dart';

class AccordionMenuItem extends StatefulWidget {
  String name;
  String price;
  String image;
  bool isActive;
  bool isBorder;
  bool isActiveStore;
  Function callBack;
  AccordionMenuItem({Key? key, required this.name, required this.callBack, required this.price, required this.isBorder, required this.image, required this.isActive, required this.isActiveStore})
      : super(key: key);

  @override
  _AccordionMenuItemState createState() => _AccordionMenuItemState();
}

class _AccordionMenuItemState extends State<AccordionMenuItem> {
  bool status = true;
  final TextEditingController _pricePerPack = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      status = widget.isActive;
      _pricePerPack.text = widget.price;
    });
  }

  dialogUpdate() {
    return showModalBottomSheet<void>(
        // dialogShape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))),
        // msg: 'Bạn có chắc muốn xóa sản phẩm khỏi thực đơn?',
        // msgAlign: TextAlign.center,
        // title: "Xóa sản phẩm",
        isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))),
        // isDismissible: true,
        // color: Colors.white,
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
              child: AnimatedPadding(
                  padding: MediaQuery.of(context).viewInsets,
                  duration: const Duration(milliseconds: 100),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.all(15),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image(
                                // color:70olors.red,
                                height: 75,
                                width: 75,
                                fit: BoxFit.cover,
                                image: NetworkImage(widget.image)),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 15),
                          width: 80,
                          child: Container(
                              decoration: const BoxDecoration(color: Colors.white),
                              // padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                              width: MediaQuery.of(context).size.width,
                              child: SizedBox(
                                height: 38,
                                child: InkWell(
                                  onTap: () {
                                    dialogDelete();
                                  },
                                  child: Container(
                                      // width: MediaQuery.of(context).size.width,
                                      // padding: const EdgeInsets.symmetric(vertical: 5),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                                          boxShadow: <BoxShadow>[BoxShadow(color: Colors.grey.shade200, offset: const Offset(2, 4), blurRadius: 5, spreadRadius: 2)],
                                          gradient: const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.redAccent, Colors.red])),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                          SizedBox(width: 5),
                                          const Text(
                                            'Xóa',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              height: 1,
                                              fontFamily: "SF SemiBold",
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                              )),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Form(
                          key: _formKey,
                          child: Container(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Text(
                                        "Tên sản phẩm",
                                        style: TextStyle(
                                          fontFamily: "SF Semibold",
                                          fontSize: 16,
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.all(2)),
                                      Text(
                                        "*",
                                        style: TextStyle(color: Colors.red, fontSize: 16),
                                      )
                                    ],
                                  ),
                                ),
                                TextFormField(
                                  readOnly: true,
                                  initialValue: widget.name,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),

                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(fontSize: 16),
                                  ),
                                  onChanged: (e) => {},
                                  // obscureText: isPassword,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Text(
                                        "Giá bán",
                                        style: TextStyle(
                                          fontFamily: "SF Semibold",
                                          fontSize: 16,
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.all(2)),
                                      Text(
                                        "*",
                                        style: TextStyle(color: Colors.red, fontSize: 16),
                                      )
                                    ],
                                  ),
                                ),
                                TextFormField(
                                  controller: _pricePerPack,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Giá bán không được để trống";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(fontSize: 16),
                                    hintText: '0.000',
                                  ),
                                  onChanged: (e) => {},
                                  // obscureText: isPassword,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                        )),
                      ],
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      SizedBox(width: 15),
                      Expanded(
                        child: Container(
                            decoration: const BoxDecoration(color: Colors.white),
                            // padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                            width: MediaQuery.of(context).size.width,
                            child: SizedBox(
                              height: 38,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  // padding: const EdgeInsets.symmetric(vertical: 5),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                                      boxShadow: <BoxShadow>[BoxShadow(color: Colors.grey.shade200, offset: const Offset(2, 4), blurRadius: 5, spreadRadius: 2)],
                                      gradient:
                                          const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color.fromRGBO(220, 220, 220, 1), Color.fromRGBO(200, 200, 200, 1)])),
                                  child: const Text(
                                    'Đóng',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                      height: 1,
                                      fontFamily: "SF SemiBold",
                                    ),
                                  ),
                                ),
                              ),
                            )),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Container(
                            decoration: const BoxDecoration(color: Colors.white),
                            // padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                            width: MediaQuery.of(context).size.width,
                            child: SizedBox(
                              height: 38,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  if (_formKey.currentState!.validate()) {}
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  // padding: const EdgeInsets.symmetric(vertical: 5),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                                      boxShadow: <BoxShadow>[BoxShadow(color: Colors.grey.shade200, offset: const Offset(2, 4), blurRadius: 5, spreadRadius: 2)],
                                      gradient: const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [MaterialColors.primary, Color(0xfff7892b)])),
                                  child: const Text(
                                    'Cập nhật',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      height: 1,
                                      fontFamily: "SF SemiBold",
                                    ),
                                  ),
                                ),
                              ),
                            )),
                      ),
                      SizedBox(width: 15),
                    ]),
                  ])));
        });
  }

  dialogDelete() {
    return Dialogs.materialDialog(
        dialogShape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
        msg: 'Bạn có chắc muốn xóa sản phẩm khỏi thực đơn?',
        msgAlign: TextAlign.center,
        title: "Xóa sản phẩm",
        color: Colors.white,
        context: context,
        actions: [
          Container(
              decoration: const BoxDecoration(color: Colors.white),
              // padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
              width: MediaQuery.of(context).size.width,
              child: SizedBox(
                height: 38,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      // padding: const EdgeInsets.symmetric(vertical: 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          boxShadow: <BoxShadow>[BoxShadow(color: Colors.grey.shade200, offset: const Offset(2, 4), blurRadius: 5, spreadRadius: 2)],
                          gradient: const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color.fromRGBO(220, 220, 220, 1), Color.fromRGBO(200, 200, 200, 1)])),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cancel_outlined,
                            color: Colors.black54,
                            size: 15,
                          ),
                          SizedBox(width: 5),
                          const Text(
                            'Đóng',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              height: 1,
                              fontFamily: "SF SemiBold",
                            ),
                          ),
                        ],
                      )),
                ),
              )),
          Container(
              decoration: const BoxDecoration(color: Colors.white),
              // padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
              width: MediaQuery.of(context).size.width,
              child: SizedBox(
                height: 38,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    widget.callBack();
                  },
                  child: Container(
                      // width: MediaQuery.of(context).size.width,
                      // padding: const EdgeInsets.symmetric(vertical: 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                          boxShadow: <BoxShadow>[BoxShadow(color: Colors.grey.shade200, offset: const Offset(2, 4), blurRadius: 5, spreadRadius: 2)],
                          gradient: const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.redAccent, Colors.red])),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 15,
                          ),
                          SizedBox(width: 5),
                          const Text(
                            'Xóa',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              height: 1,
                              fontFamily: "SF SemiBold",
                            ),
                          ),
                        ],
                      )),
                ),
              )),
        ]);
  }

  dialogConfirm() {
    return Dialogs.materialDialog(
        dialogShape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
        msg: 'Vui lòng chuyển trạng thái cửa hàng sang tạm đóng và thử lại',
        msgAlign: TextAlign.center,
        title: "Bạn muốn chỉnh sửa sản phẩm?",
        color: Colors.white,
        context: context,
        actions: [
          // IconsOutlineButton(
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          //   text: 'Đóng ',
          //   textStyle: TextStyle(color: Colors.white),
          //   iconColor: MaterialColors.primary,
          //   color: MaterialColors.primary,
          // ),
          Container(
              decoration: const BoxDecoration(color: Colors.white),
              // padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
              width: MediaQuery.of(context).size.width,
              child: SizedBox(
                height: 38,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    // padding: const EdgeInsets.symmetric(vertical: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        boxShadow: <BoxShadow>[BoxShadow(color: Colors.grey.shade200, offset: const Offset(2, 4), blurRadius: 5, spreadRadius: 2)],
                        gradient: const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [MaterialColors.primary, Color(0xfff7892b)])),
                    child: const Text(
                      'Đóng',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        height: 1,
                        fontFamily: "SF SemiBold",
                      ),
                    ),
                  ),
                ),
              ))
          // IconsButton(
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          //   text: 'Ok',
          //   color: Colors.red,
          //   textStyle: TextStyle(color: Colors.white),
          //   iconColor: Colors.white,
          // ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      decoration: widget.isBorder ? BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black12, width: 1))) : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
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
                  child: InkWell(
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
                      style: TextStyle(fontFamily: "SF Medium", fontSize: 15, color: Colors.black45),
                    ),
                    Padding(padding: EdgeInsets.all(3)),
                    Text(
                      "Chỉnh sửa",
                      style: TextStyle(fontFamily: "SF Medium", fontSize: 13, color: Color.fromRGBO(24, 144, 255, 1)),
                    ),
                  ],
                ),
                onTap: () {
                  if (widget.isActiveStore) {
                    dialogConfirm();
                  } else {
                    dialogUpdate();
                  }
                },
              ))
            ],
          )),
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
                if (widget.isActiveStore) {
                  dialogConfirm();
                } else {
                  setState(() {
                    status = val;
                  });
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
