import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:store_app/constants/Theme.dart';
import 'package:store_app/models/categoryModel.dart';
import 'package:store_app/models/productModel.dart';
import 'package:store_app/provider/appProvider.dart';
import 'package:store_app/screens/select_photo_options_screen.dart';
import 'package:store_app/widgets/accordion/accordion.dart';
import 'package:store_app/apis/apiService.dart';
import 'package:store_app/widgets/upload/re_usable_select_photo_button.dart';
import 'package:dotted_border/dotted_border.dart';

class NewProductScreen extends StatefulWidget {
  const NewProductScreen({Key? key}) : super(key: key);

  @override
  _NewProductScreenState createState() => _NewProductScreenState();
}

class _NewProductScreenState extends State<NewProductScreen> {
  List<CategoryModel> listCategory = [];
  List listPackNetWeight = [];
  List listUnit = [
    {"id": "1", "value": "Kg"},
    {"id": "4", "value": "Gam"},
    {"id": "2", "value": "Ly"},
    {"id": "3", "value": "Chai"},
    {"id": "5", "value": "Hộp"},
    {"id": "6", "value": "Hủ"},
    {"id": "7", "value": "Cái"},
    {"id": "8", "value": "Phần"},
  ];
  List listPackNetWeightKg = [
    {"id": "1", "value": "0.1kg", "pack": 0.1},
    {"id": "2", "value": "0.2kg", "pack": 0.2},
    {"id": "3", "value": "0.5kg", "pack": 0.5},
    {"id": "4", "value": "1kg", "pack": 1},
    {"id": "5", "value": "2kg", "pack": 2},
    {"id": "6", "value": "5kg", "pack": 5},
    {"id": "7", "value": "10kg", "pack": 10},
  ];
  List listPackNetWeightGam = [
    {"id": "1", "value": "50g", "pack": 50},
    {"id": "2", "value": "100g", "pack": 100},
    {"id": "3", "value": "200g", "pack": 200},
    {"id": "4", "value": "500g", "pack": 500},
    {"id": "5", "value": "1000g", "pack": 1000},
  ];
  final _formKey = GlobalKey<FormState>();
  File? _image;
  bool valid = false;
  bool validImage = true;
  bool isLoading = false;
  String _category = '';
  String _unit = '';
  String _name = '';
  double _pricePerPack = 0;
  final _controllerPricePerPack = TextEditingController();
  String _price = '';
  double _packNetWeight = 0;
  String packNetWeightItem = "";
  double _maximumQuantity = 0;
  double _minimumQuantity = 1;
  double _minimumDeIn = 1;
  String _packDescription = "";
  String _description = "";
  void initState() {
    super.initState();
    ApiServices.getListCategory(1, 100).then((value) => {
          if (value != null)
            {
              setState(() {
                listCategory = value;
              })
            }
        });
  }

  void hanldeSubmit(String storeId) {
    FocusScope.of(context).unfocus();
    setState(() {
      isLoading = true;
    });
    if (_image != null) {
      var bytes = File(_image!.path).readAsBytesSync();
      String img64 = base64Encode(bytes);

      ProductModel product = ProductModel(
          image: img64 ?? "",
          name: _name,
          categoryId: _category,
          packNetWeight: _packNetWeight ?? 0.0,
          packDescription: _packDescription ?? "",
          maximumQuantity: _maximumQuantity ?? 1.0,
          minimumQuantity: _minimumQuantity ?? 1.0,
          minimumDeIn: _minimumDeIn == 0 ? 1.0 : _minimumDeIn,
          unit: _unit ?? "",
          pricePerPack: _pricePerPack ?? 0.0,
          storeId: storeId,
          rate: 0.0,
          description: _description);

      ApiServices.postCreateProduct(product).then((value) => {
            if (value != null)
              {
                setState(() {
                  isLoading = false;
                  Fluttertoast.showToast(
                      msg: "Thêm sản phẩm thành công",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }),
                Navigator.pop(context)
              }
          });
    } else {
      setState(() {
        isLoading = false;
      });
    }
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
              "Tạo sản phẩm",
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
                                  width: 165,
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
                                              topLeft: Radius.circular(8),
                                              bottomLeft: Radius.circular(8),
                                              topRight: Radius.circular(8),
                                              bottomRight: Radius.circular(8),
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
                        if (_image == null)
                          Stack(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 10, bottom: 15, top: 10),
                                  width: 165,
                                  height: 155,
                                  // color: Colors.amber,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      DottedBorder(
                                        color: !validImage ? Colors.red : MaterialColors.secondary,
                                        radius: Radius.circular(20),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(Radius.circular(12)),
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
                                    "Tên sản phẩm",
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
                                    return "Tên sản phẩm không được để trống";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(fontSize: 16),
                                  hintText: 'Ví dụ: Cơm Tấm',
                                ),
                                // controller: controller,
                                onChanged: (e) => {
                                  setState(() => {_name = e})
                                },
                                // obscureText: isPassword,
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
                                                  "Giá bán",
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
                                            keyboardType: TextInputType.number,
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
                                            onChanged: (e) => {
                                              if (e != "")
                                                {
                                                  setState(() => {_pricePerPack = double.parse(e)})
                                                }
                                            },
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
                                                  "Đơn vị",
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
                                                return "Đơn vị không được để trống";
                                              }
                                              return null;
                                            },
                                            value: _unit == '' ? null : _unit,
                                            isDense: true,
                                            onChanged: (value) {
                                              setState(() {
                                                _unit = value!;
                                                if (value.isEmpty) {
                                                  valid = false;
                                                } else {
                                                  valid = true;
                                                }
                                                if (_unit == listUnit[0]["value"]) {
                                                  listPackNetWeight = listPackNetWeightKg;
                                                } else if (_unit == listUnit[1]["value"]) {
                                                  listPackNetWeight = listPackNetWeightGam;
                                                } else {
                                                  listPackNetWeight = [];
                                                }
                                                packNetWeightItem = "";
                                                _packNetWeight = 0;
                                                _packDescription = "";
                                              });
                                            },
                                            items: listUnit.map((value) {
                                              return DropdownMenuItem<String>(
                                                value: value["value"],
                                                child: Text(value["value"].toString()),
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                              ),
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
                                                  "Danh mục",
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
                                                return "Danh mục không được để trống";
                                              }
                                              return null;
                                            },
                                            value: _category == '' ? null : _category,
                                            isDense: true,
                                            onChanged: (value) {
                                              setState(() {
                                                _category = value!;
                                                if (value.isEmpty) {
                                                  valid = false;
                                                } else {
                                                  valid = true;
                                                }
                                              });
                                            },
                                            items: listCategory.map((value) {
                                              return DropdownMenuItem<String>(
                                                value: value.id,
                                                child: Text(value.name.toString()),
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                              ),
                              if (listPackNetWeight.length > 0)
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
                                                    "Đóng gói",
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
                                                  return "Đóng gói không được để trống";
                                                }
                                                return null;
                                              },
                                              value: packNetWeightItem == '' ? null : packNetWeightItem,
                                              isDense: true,
                                              onChanged: (value) {
                                                setState(() {
                                                  packNetWeightItem = value!;
                                                  _packDescription = value;
                                                  for (var element in listPackNetWeight) {
                                                    if (element["value"] == value) {
                                                      var tmp = element["pack"].toDouble();
                                                      _packNetWeight = tmp;
                                                    }
                                                  }
                                                  if (value.isEmpty) {
                                                    valid = false;
                                                  } else {
                                                    valid = true;
                                                  }
                                                });
                                              },
                                              items: listPackNetWeight.map((value) {
                                                return DropdownMenuItem<String>(
                                                  value: value["value"],
                                                  child: Text(value["value"].toString()),
                                                );
                                              }).toList(),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              // Column(
                              //   children: [
                              //     Container(
                              //       child: Row(
                              //         children: [
                              //           Text(
                              //             "Đóng gói",
                              //             style: TextStyle(
                              //               fontFamily: "SF Semibold",
                              //               fontSize: 18,
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              //     ),
                              //     TextFormField(
                              //       keyboardType: TextInputType.number,
                              //       decoration: InputDecoration(
                              //         hintStyle: TextStyle(fontSize: 16),
                              //         hintText: 'Ví dụ: 1 Ly, 500g,...',
                              //       ),
                              //       // controller: controller,
                              //       onChanged: (e) => {
                              //         if (e != "")
                              //           {
                              //             setState(() => {
                              //                   _packNetWeight = double.parse(e)
                              //                 })
                              //           }
                              //       },
                              //       // obscureText: isPassword,
                              //     )
                              //   ],
                              // )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                        ),
                        Accordion(
                            title: 'Thêm thông tin',
                            content: Container(
                              color: Colors.white,
                              padding: EdgeInsets.only(left: 15, right: 15, bottom: 25),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      // Padding(padding: EdgeInsets.all(15)),
                                      Expanded(
                                          flex: 1,
                                          child: Column(
                                            children: [
                                              Container(
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "+/- Tối thiểu",
                                                      style: TextStyle(
                                                        fontFamily: "SF Semibold",
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              TextFormField(
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                  hintStyle: TextStyle(fontSize: 16),
                                                  hintText: '1',
                                                ),
                                                // controller: controller,
                                                onChanged: (e) => {
                                                  if (e != "")
                                                    {
                                                      setState(() => {_minimumDeIn = double.parse(e)})
                                                    }
                                                },
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
                                                      "Mua nhiều nhất",
                                                      style: TextStyle(
                                                        fontFamily: "SF Semibold",
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              TextFormField(
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                  hintStyle: TextStyle(fontSize: 16),
                                                  hintText: '0',
                                                ),
                                                // controller: controller,
                                                onChanged: (e) => {
                                                  if (e != "")
                                                    {
                                                      setState(() => {_maximumQuantity = double.parse(e)})
                                                    }
                                                },
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
                                                      "Mua ít nhất",
                                                      style: TextStyle(
                                                        fontFamily: "SF Semibold",
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              TextFormField(
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                  hintStyle: TextStyle(fontSize: 16),
                                                  hintText: '1',
                                                ),
                                                // controller: controller,
                                                onChanged: (e) => {
                                                  if (e != "")
                                                    {
                                                      setState(() => {_minimumQuantity = double.parse(e)})
                                                    }
                                                },
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
                                                      "Miêu tả sản phẩm",
                                                      style: TextStyle(
                                                        fontFamily: "SF Semibold",
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              TextFormField(
                                                keyboardType: TextInputType.multiline,
                                                minLines: 2,
                                                maxLines: 5,
                                                decoration: InputDecoration(
                                                  hintStyle: TextStyle(fontSize: 16),
                                                  hintText: '',
                                                ),
                                                // controller: controller,
                                                onChanged: (e) => {
                                                  if (e != "")
                                                    {
                                                      setState(() => {_description = e})
                                                    }
                                                },
                                                // obscureText: isPassword,
                                              )
                                            ],
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  )),
                ),
              ),
              Positioned(
                  bottom: 0,
                  child: Container(
                      decoration: BoxDecoration(color: Colors.white),
                      padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        height: 45,
                        child: InkWell(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              hanldeSubmit(context.read<AppProvider>().getUserId ?? "");
                            }

                            if (_image == null) {
                              setState(() {
                                validImage = false;
                              });
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
                              'Hoàn tất',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontFamily: "SF SemiBold",
                              ),
                            ),
                          ),
                        ),
                      ))),
              if (isLoading) ...[
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white.withOpacity(0.5),
                  child: SpinKitDualRing(
                    color: MaterialColors.primary,
                    size: 45.0,
                  ),
                )
              ],
            ],
          ));
    });
  }
}
