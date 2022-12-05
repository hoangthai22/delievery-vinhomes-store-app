import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:store_app/apis/apiService.dart';
import 'package:store_app/constants/Theme.dart';
import 'package:store_app/models/buildingModel.dart';
import 'package:store_app/models/categoryModel.dart';
import 'package:store_app/models/storeModel.dart';
import 'package:store_app/models/unitModel.dart';
import 'package:store_app/provider/appProvider.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  List<CategoryModel> listCategory = [];
  List<UnitModel> listUnit = [
    UnitModel(id: "1", value: "Kg"),
    UnitModel(id: "2", value: "Ly"),
    UnitModel(id: "3", value: "Chai"),
    UnitModel(id: "4", value: "Gam"),
    UnitModel(id: "5", value: "Hộp"),
    UnitModel(id: "6", value: "Hủ"),
    UnitModel(id: "7", value: "Cái"),
  ];

  final _formKey = GlobalKey<FormState>();
  File? _image;
  bool valid = false;
  bool validImage = true;
  bool isLoadingSubmit = true;
  String isImage = "";
  List<BuildingModel> listBuilding = [];
  String _unit = '';
  String _brandId = '';
  String _storeCategoryId = '';
  bool _status = true;
  // String _name = '';
  TextEditingController _name = TextEditingController();
  String _buildingId = '';
  TextEditingController _password = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _openTime = TextEditingController();
  TextEditingController _closeTime = TextEditingController();
  TextEditingController _building = TextEditingController();

  TextEditingController _id = TextEditingController();

  // String _price = '';
  // double _packNetWeight = 0;
  // double _maximumQuantity = 0;
  // double _minimumQuantity = 0;
  // double _minimumDeIn = 0;
  // String _packDescription = "";
  void initState() {
    super.initState();
    final currencyFormatter = NumberFormat('##0', 'ID');
    StoreModel store = context.read<AppProvider>().getStoreModel;
    isImage = store.image.toString();
    _name.text = store.name ?? "";
    _id.text = store.id ?? "";
    _phone.text = store.phone ?? "";
    _password.text = store.account!.values.first ?? "";
    print(store.account);
    _openTime.text = store.openTime ?? "";
    _closeTime.text = store.closeTime ?? "";
    _buildingId = store.buildingId ?? "";
    _status = store.status!;
    _brandId = store.brandId ?? "";
    _storeCategoryId = store.storeCategoryId ?? "";
    ApiServices.getListBuilding()
        .then((value) => {
              if (value != null)
                {
                  setState(() {
                    listBuilding = value;
                    isLoadingSubmit = false;
                  })
                }
            })
        .catchError((onError) {
      setState(() {
        listBuilding = [];
        isLoadingSubmit = false;
      });
    });
  }

  @override
  void dispose() {
    // _controller.dispose();
    _unit = "";
    // scrollController.dispose();
    super.dispose();
  }

  Future<void> hanldeUpdate() async {
    FocusScope.of(context).unfocus();
    // print(img64);
    // print("_category" + _category);

    var img64 = null;
    var base64String = null;
    setState(() {
      isLoadingSubmit = true;
    });
    if (_image != null) {
      var bytes = File(_image!.path).readAsBytesSync();
      img64 = base64Encode(bytes);
    } else if (isImage != "") {
      http.Response imageResponse = await http.get(
        Uri.parse(isImage),
      );
      base64String = base64.encode(imageResponse.bodyBytes);
    }
    Map<String, dynamic>? account = {"password": _password.text};

    StoreModel store = StoreModel(
        image: img64 ?? base64String,
        name: _name.text,
        buildingId: _buildingId,
        closeTime: _closeTime.text,
        openTime: _openTime.text,
        phone: _phone.text,
        id: _id.text,
        rate: "",
        slogan: "",
        status: _status,
        brandId: _brandId,
        account: account,
        storeCategoryId: _storeCategoryId);
    // print(widget.productModel.id);
    ApiServices.putStore(store, _id.text, _password.text).then((value) => {
          if (value != null)
            {
              setState(() {
                print(value);
                context.read<AppProvider>().setStoreModel(value);
                context.read<AppProvider>().setName(value.name);
                context.read<AppProvider>().setAvatar(value.image);
                Fluttertoast.showToast(
                    msg: "Cập nhật thông tin thành công",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0);
                isLoadingSubmit = false;
              }),
            }
        });
  }

  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? img = File(image.path);
      // img = await _cropImage(imageFile: img);
      setState(() {
        _image = img;
        validImage = true;

        // Navigator.of(context).pop();
      });
    } on PlatformException catch (e) {
      print(e);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, provider, child) {
      return Scaffold(
          appBar: new AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [MaterialColors.primary, Color(0xfff7892b)]),
              ),
            ),
            centerTitle: true,
            iconTheme: IconThemeData(
              color: Colors.white, //change your color here
            ),
            title: Text(
              "Chỉnh sửa tài khoản",
              style: TextStyle(
                color: MaterialColors.white,
                fontFamily: "SF Bold",
              ),
            ),
          ),
          body: Stack(
            children: [
              Form(
                key: _formKey,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  // controller: scrollController,
                  // physics: const AlwaysScrollableScrollPhysics(),
                  // shrinkWrap: true,
                  // scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                      child: Container(
                    // decoration: BoxDecoration(color: Colors.white),
                    margin: EdgeInsets.only(top: 15, bottom: 100),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_image != null)
                          Stack(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                                  width: 155,
                                  height: 155,
                                  // color: Colors.amber,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        // width: 100,

                                        child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(100),
                                              bottomLeft: Radius.circular(100),
                                              topRight: Radius.circular(100),
                                              bottomRight: Radius.circular(100),
                                            ),

                                            // padding: const EdgeInsets.only(right: 15, left: 0),
                                            child: _image != null
                                                ? Image(
                                                    // color:70olors.red,
                                                    height: 150,
                                                    width: 150,
                                                    fit: BoxFit.cover,
                                                    image: FileImage(_image!),
                                                  )
                                                : Container()),
                                      ),
                                    ],
                                  )),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _image = null;
                                      isImage = "";
                                    });
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(50)), border: Border.all(color: Colors.white)),
                                      child: Icon(
                                        Icons.clear,
                                        color: Colors.white,
                                        size: 16,
                                      )),
                                ),
                              )
                            ],
                          ),
                        if (_image == null && isImage != "")
                          Stack(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                                  width: 155,
                                  height: 155,
                                  // color: Colors.amber,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        // width: 100,
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(100),
                                              bottomLeft: Radius.circular(100),
                                              topRight: Radius.circular(100),
                                              bottomRight: Radius.circular(100),
                                            ),

                                            // padding: const EdgeInsets.only(right: 15, left: 0),
                                            child: isImage != null
                                                ? Image(
                                                    // color:70olors.red,
                                                    height: 150,
                                                    width: 150,
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(isImage))
                                                : Container()),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        if (_image == null && isImage == "")
                          Stack(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 10, bottom: 15, top: 10),
                                  width: 155,
                                  height: 155,
                                  // color: Colors.amber,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      DottedBorder(
                                        borderType: BorderType.RRect,
                                        color: !validImage ? Colors.red : MaterialColors.secondary,
                                        radius: Radius.circular(100),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(Radius.circular(100)),
                                          child: Container(
                                            height: 150,
                                            width: 150,
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Ảnh",
                                              style: TextStyle(color: !validImage ? Colors.red[700] : MaterialColors.secondary, fontFamily: "SF Medium", fontSize: 16),
                                            ),
                                            // color: Colors.amber,
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                            ],
                          ),
                        if (!validImage)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Ảnh không được đê trống",
                                style: TextStyle(color: Colors.red[700], fontSize: 13),
                              )
                            ],
                          ),
                        Padding(padding: EdgeInsets.all(8)),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                _pickImage(ImageSource.gallery);
                                // _showSelectPhotoOptions(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(8)), border: Border.all(color: MaterialColors.secondary)),
                                width: 135,
                                height: 40,
                                margin: EdgeInsets.only(bottom: 15, left: 15),
                                // width: MediaQuery.of(context).size.width * 0.42,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        child: Icon(
                                      Icons.add_photo_alternate,
                                      color: MaterialColors.secondary,
                                    )),
                                    Padding(padding: EdgeInsets.all(5)),
                                    Text(
                                      "Tải ảnh lên",
                                      style: TextStyle(color: MaterialColors.secondary, fontFamily: "SF Bold", fontSize: 17),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                _pickImage(ImageSource.camera);
                                // _showSelectPhotoOptions(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(8)), border: Border.all(color: MaterialColors.secondary)),

                                width: 135,
                                height: 40,
                                margin: EdgeInsets.only(bottom: 15, left: 15),
                                // width: MediaQuery.of(context).size.width * 0.42,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        child: Icon(
                                      Icons.add_a_photo_rounded,
                                      color: MaterialColors.secondary,
                                    )),
                                    Padding(padding: EdgeInsets.all(5)),
                                    Text(
                                      "Chụp ảnh",
                                      style: TextStyle(color: MaterialColors.secondary, fontFamily: "SF Bold", fontSize: 17),
                                    ),
                                    // SelectPhoto(
                                    //   onTap: () => onTap(ImageSource.gallery),
                                    //   icon: Icons.image,
                                    //   textLabel: 'Browse Gallery',
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 25),
                          decoration: BoxDecoration(color: Colors.white),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Tên cửa hàng",
                                    style: TextStyle(
                                      fontFamily: "SF Semibold",
                                      fontSize: 18,
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.all(2)),
                                  Text(
                                    "*",
                                    style: TextStyle(color: Colors.red, fontSize: 20),
                                  )
                                ],
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Tên cửa hàng không được để trống";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(fontSize: 16),
                                ),
                                controller: _name,
                                // controller: _name != null
                                //     ? TextEditingController(text: _name)
                                //     : null,
                                // initialValue: _name != null ? _name : null,
                                onChanged: (e) => {
                                  // setState(() => {_name.text = e})
                                },
                                // obscureText: isPassword,
                              ),
                              Padding(padding: EdgeInsets.all(15)),
                              Row(
                                children: [
                                  Text(
                                    "Tên đăng nhập",
                                    style: TextStyle(
                                      fontFamily: "SF Semibold",
                                      fontSize: 18,
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.all(2)),
                                  Text(
                                    "*",
                                    style: TextStyle(color: Colors.red, fontSize: 20),
                                  )
                                ],
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Tên đăng nhập không được để trống";
                                  }
                                  return null;
                                },
                                readOnly: true,
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(fontSize: 16),
                                ),
                                controller: _id,
                                // controller: _name != null
                                //     ? TextEditingController(text: _name)
                                //     : null,
                                // initialValue: _name != null ? _name : null,
                                onChanged: (e) => {
                                  // setState(() => {_name.text = e})
                                },
                                // obscureText: isPassword,
                              ),
                              Padding(padding: EdgeInsets.all(15)),
                              // Row(
                              //   children: [
                              //     Text(
                              //       "Mật khẩu",
                              //       style: TextStyle(
                              //         fontFamily: "SF Semibold",
                              //         fontSize: 18,
                              //       ),
                              //     ),
                              //     Padding(padding: EdgeInsets.all(2)),
                              //     Text(
                              //       "*",
                              //       style: TextStyle(
                              //           color: Colors.red, fontSize: 20),
                              //     )
                              //   ],
                              // ),
                              // TextFormField(
                              //   obscureText: true,
                              //   readOnly: true,
                              //   validator: (value) {
                              //     if (value == null || value.isEmpty) {
                              //       return "Mật khẩu không được để trống";
                              //     }
                              //     return null;
                              //   },
                              //   decoration: InputDecoration(
                              //     hintStyle: TextStyle(fontSize: 16),
                              //   ),
                              //   controller: _password,
                              //   // controller: _name != null
                              //   //     ? TextEditingController(text: _name)
                              //   //     : null,
                              //   // initialValue: _name != null ? _name : null,
                              //   onChanged: (e) => {
                              //     // setState(() => {_name.text = e})
                              //   },
                              //   // obscureText: isPassword,
                              // ),
                              Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Column(
                                        children: [
                                          Container(
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Địa chỉ",
                                                  style: TextStyle(
                                                    fontFamily: "SF Semibold",
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                Padding(padding: EdgeInsets.all(2)),
                                                Text(
                                                  "*",
                                                  style: TextStyle(color: Colors.red, fontSize: 18),
                                                )
                                              ],
                                            ),
                                          ),
                                          DropdownButtonFormField<String>(
                                            isExpanded: true,
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return "Địa chỉ không được để trống";
                                              }
                                              return null;
                                            },
                                            value: _buildingId == '' ? null : _buildingId,
                                            isDense: true,
                                            onChanged: (value) {
                                              setState(() {
                                                _buildingId = value!;
                                                if (value.isEmpty) {
                                                  valid = false;
                                                } else {
                                                  valid = true;
                                                }
                                              });
                                            },
                                            items: listBuilding.map((value) {
                                              return DropdownMenuItem<String>(
                                                value: value.id,
                                                child: Text(value.name.toString()),
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      )),
                                  Padding(padding: EdgeInsets.all(15)),
                                  Expanded(
                                      flex: 1,
                                      child: Column(
                                        children: [
                                          Container(
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Số điện thoại",
                                                  style: TextStyle(
                                                    fontFamily: "SF Semibold",
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                Padding(padding: EdgeInsets.all(2)),
                                                Text(
                                                  "*",
                                                  style: TextStyle(color: Colors.red, fontSize: 20),
                                                )
                                              ],
                                            ),
                                          ),
                                          TextFormField(
                                            controller: _phone,
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return "Số điện thoại không được để trống";
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              hintStyle: TextStyle(fontSize: 16),
                                            ),
                                            onChanged: (e) => {},
                                            // obscureText: isPassword,
                                          )
                                        ],
                                      )),
                                ],
                              ),
                              Padding(padding: EdgeInsets.all(15)),
                              Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Column(
                                        children: [
                                          Container(
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Giờ mở cửa",
                                                  style: TextStyle(
                                                    fontFamily: "SF Semibold",
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                Padding(padding: EdgeInsets.all(2)),
                                                Text(
                                                  "*",
                                                  style: TextStyle(color: Colors.red, fontSize: 20),
                                                )
                                              ],
                                            ),
                                          ),
                                          TextFormField(
                                            controller: _openTime,
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return "Giờ mở cửa không được để trống";
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              hintStyle: TextStyle(fontSize: 16),
                                            ),
                                            onChanged: (e) => {},
                                            // obscureText: isPassword,
                                          )
                                        ],
                                      )),
                                  Padding(padding: EdgeInsets.all(15)),
                                  Expanded(
                                      flex: 1,
                                      child: Column(
                                        children: [
                                          Container(
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Giờ đóng cửa",
                                                  style: TextStyle(
                                                    fontFamily: "SF Semibold",
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                Padding(padding: EdgeInsets.all(2)),
                                                Text(
                                                  "*",
                                                  style: TextStyle(color: Colors.red, fontSize: 20),
                                                )
                                              ],
                                            ),
                                          ),
                                          TextFormField(
                                            controller: _closeTime,
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return "Giờ đóng cửa không được để trống";
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              hintStyle: TextStyle(fontSize: 16),
                                            ),
                                            onChanged: (e) => {},
                                            // obscureText: isPassword,
                                          )
                                        ],
                                      )),
                                ],
                              ),
                              Padding(padding: EdgeInsets.all(15)),
                              Row(
                                children: [
                                  Text(
                                    "Miêu tả cửa hàng",
                                    style: TextStyle(
                                      fontFamily: "SF Semibold",
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              TextFormField(
                                maxLines: 5, minLines: 2,
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(fontSize: 16),
                                ),
                                controller: _description,
                                // controller: _name != null
                                //     ? TextEditingController(text: _name)
                                //     : null,
                                // initialValue: _name != null ? _name : null,
                                onChanged: (e) => {setState(() => {})},
                                // obscureText: isPassword,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                        ),
                      ],
                    ),
                  )),
                ),
              ),
              Positioned(
                  bottom: 0,
                  child: Container(
                      decoration: const BoxDecoration(color: Colors.white),
                      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                      width: MediaQuery.of(context).size.width,
                      child: SizedBox(
                        height: 45,
                        child: InkWell(
                          onTap: () {
                            if (_image == null && isImage == "") {
                              setState(() {
                                validImage = false;
                              });
                            } else if (_formKey.currentState!.validate() && (_image != null || isImage != "")) {
                              hanldeUpdate();
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(8)),
                                boxShadow: <BoxShadow>[BoxShadow(color: Colors.grey.shade200, offset: const Offset(2, 4), blurRadius: 5, spreadRadius: 2)],
                                gradient: const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [MaterialColors.primary, Color(0xfff7892b)])),
                            child: const Text(
                              'Cập nhật',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                height: 1,
                                fontFamily: "SF SemiBold",
                              ),
                            ),
                          ),
                        ),
                      ))),
              if (isLoadingSubmit)
                Positioned(
                  child: Container(
                    color: Colors.white.withOpacity(0.5),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: SpinKitDualRing(
                      color: MaterialColors.primary,
                      size: 45.0,
                    ),
                  ),
                ),
            ],
          ));
    });
  }
}
