import 'dart:convert';
import 'dart:io';
import 'dart:convert' as convert;
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:store_app/apis/apiService.dart';
import 'package:store_app/constants/Theme.dart';
import 'package:store_app/models/categoryModel.dart';
import 'package:store_app/models/productModel.dart';
import 'package:store_app/models/unitModel.dart';
import 'package:store_app/widgets/accordion/accordion.dart';
import 'package:http/http.dart' as http;

class UpdateProductScreen extends StatefulWidget {
  final ProductModel productModel;
  const UpdateProductScreen({
    Key? key,
    required this.productModel,
  }) : super(key: key);

  @override
  _UpdateProductScreenState createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  List<CategoryModel> listCategory = [];
  List<UnitModel> listUnit = [
    UnitModel(id: "1", value: "Kg"),
    UnitModel(id: "4", value: "Gam"),
    UnitModel(id: "2", value: "Ly"),
    UnitModel(id: "3", value: "Chai"),
    UnitModel(id: "5", value: "Hộp"),
    UnitModel(id: "6", value: "Hủ"),
    UnitModel(id: "7", value: "Cái"),
    UnitModel(id: "8", value: "Phần"),
  ];
  List listPackNetWeight = [];

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
  bool isLoadingSubmit = true;
  String isImage = "";
  String _category = '';
  String _storeId = '';
  String _unit = '';
  String _id = '';
  // String _name = '';
  String packNetWeightItem = "";
  final TextEditingController _name = TextEditingController();
  // TextEditingController _unit = TextEditingController();
  // double _pricePerPack = 0;
  final TextEditingController _pricePerPack = TextEditingController();
  final TextEditingController _packNetWeight = TextEditingController();
  final TextEditingController _maximumQuantity = TextEditingController();
  final TextEditingController _minimumQuantity = TextEditingController();
  final TextEditingController _minimumDeIn = TextEditingController();
  final TextEditingController _packDescription = TextEditingController();
  final TextEditingController _description = TextEditingController();
  // String _price = '';
  // double _packNetWeight = 0;
  // double _maximumQuantity = 0;
  // double _minimumQuantity = 0;
  // double _minimumDeIn = 0;
  // String _packDescription = "";
  void initState() {
    super.initState();
    final currencyFormatter = NumberFormat('##0', 'ID');
    ApiServices.getListCategory(1, 100).then((value) => {
          if (value != null)
            {
              setState(() {
                _storeId = widget.productModel.storeId.toString();
                _id = widget.productModel.id.toString();
                listCategory = value;
                _name.text = widget.productModel.name ?? "";
                _packDescription.text = widget.productModel.packDescription ?? "";
                _pricePerPack.text = currencyFormatter.format((widget.productModel.pricePerPack!).toInt()).toString();
                _packNetWeight.text = currencyFormatter.format((widget.productModel.packNetWeight!).toInt()).toString();
                _maximumQuantity.text = currencyFormatter.format((widget.productModel.maximumQuantity!).toInt()).toString();
                _minimumQuantity.text = currencyFormatter.format((widget.productModel.minimumQuantity!).toInt()).toString();
                _minimumDeIn.text = currencyFormatter.format((widget.productModel.minimumDeIn!).toInt()).toString();
                _unit = widget.productModel.unit.toString();
                if (_unit == listUnit[0].value) {
                  listPackNetWeight = listPackNetWeightKg;
                  packNetWeightItem = widget.productModel.packDescription!;
                } else if (_unit == listUnit[1].value) {
                  listPackNetWeight = listPackNetWeightGam;
                  packNetWeightItem = widget.productModel.packDescription!;
                }
                _category = widget.productModel.categoryId.toString();
                isImage = widget.productModel.image.toString();
                _description.text = widget.productModel.description!;
                isLoadingSubmit = false;
              })
            }
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

    ProductModel product = ProductModel(
        id: _id,
        image: img64 ?? base64String,
        name: _name.text,
        categoryId: _category,
        packNetWeight: double.parse(_packNetWeight.text),
        packDescription: _packDescription.text,
        maximumQuantity: double.parse(_maximumQuantity.text),
        minimumQuantity: double.parse(_minimumQuantity.text),
        minimumDeIn: _minimumDeIn.text != "" ? double.parse(_minimumDeIn.text) : 1,
        unit: _unit,
        pricePerPack: double.parse(_pricePerPack.text),
        storeId: _storeId,
        rate: 0.0,
        description: _description.text);
    Map valueMap;
    ApiServices.putUpdateProduct(product, widget.productModel.id ?? "").then((value) => {
          if (value != null)
            {
              valueMap = convert.jsonDecode(value),
              setState(() {
                isLoadingSubmit = false;

                if (valueMap["message"] == "Hiện tại danh mục đang có trong menu !!Vui lòng xóa danh mục khỏi menu và thử lại ") {
                  Fluttertoast.showToast(
                      msg: valueMap["message"],
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else {
                  Fluttertoast.showToast(
                      msg: "Cập nhật sản phẩm thành công",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  Navigator.pop(context);
                }
                ;
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
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
                                width: 165,
                                height: 155,
                                // color: Colors.amber,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    DottedBorder(
                                      color: !validImage ? Colors.red : MaterialColors.secondary,
                                      radius: Radius.circular(16),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(Radius.circular(12)),
                                        child: Container(
                                          height: 150,
                                          width: 150,
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Ảnh",
                                            style: TextStyle(color: !validImage ? Colors.red[700] : MaterialColors.secondary, fontFamily: "SF Medium", fontSize: 15),
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
                                    size: 16,
                                  )),
                                  Padding(padding: EdgeInsets.all(5)),
                                  Text(
                                    "Tải ảnh lên",
                                    style: TextStyle(color: MaterialColors.secondary, fontFamily: "SF Bold", fontSize: 16),
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
                                    size: 16,
                                  )),
                                  Padding(padding: EdgeInsets.all(5)),
                                  Text(
                                    "Chụp ảnh",
                                    style: TextStyle(color: MaterialColors.secondary, fontFamily: "SF Bold", fontSize: 16),
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
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Tên sản phẩm không được để trống";
                                }
                                return null;
                              },
                              style: TextStyle(
                                fontSize: 15,
                              ),
                              decoration: InputDecoration(
                                hintStyle: TextStyle(fontSize: 15),
                                hintText: 'Ví dụ: Cơm Tấm',
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
                                              if (_unit == listUnit[0].value) {
                                                listPackNetWeight = listPackNetWeightKg;
                                              } else if (_unit == listUnit[1].value) {
                                                listPackNetWeight = listPackNetWeightGam;
                                              } else {
                                                listPackNetWeight = [];
                                              }
                                              packNetWeightItem = "";
                                              _packNetWeight.text = "0";
                                              _packDescription.text = "";
                                            });
                                          },
                                          items: listUnit.map((value) {
                                            return DropdownMenuItem<String>(
                                              value: value.value,
                                              child: Text(
                                                value.value.toString(),
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
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
                                              child: Text(
                                                value.name.toString(),
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
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
                                                _packDescription.text = value;
                                                for (var element in listPackNetWeight) {
                                                  if (element["value"] == value) {
                                                    var tmp = element["pack"].toDouble();
                                                    _packNetWeight.text = tmp.toString();
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
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            TextFormField(
                                              keyboardType: TextInputType.number,
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                              decoration: InputDecoration(
                                                hintStyle: TextStyle(fontSize: 16),
                                                hintText: '0',
                                              ),
                                              controller: _minimumDeIn,
                                              onChanged: (e) => {},
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
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            TextFormField(
                                              keyboardType: TextInputType.number,
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                              decoration: InputDecoration(
                                                hintStyle: TextStyle(fontSize: 15),
                                                hintText: '0',
                                              ),
                                              controller: _maximumQuantity,
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
                                                    "Mua ít nhất",
                                                    style: TextStyle(
                                                      fontFamily: "SF Semibold",
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            TextFormField(
                                              keyboardType: TextInputType.number,
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                              decoration: InputDecoration(
                                                hintStyle: TextStyle(fontSize: 15),
                                                hintText: '0',
                                              ),
                                              controller: _minimumQuantity,
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
                                                    "Miêu tả sản phẩm",
                                                    style: TextStyle(
                                                      fontFamily: "SF Semibold",
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            TextFormField(
                                              keyboardType: TextInputType.multiline,
                                              minLines: 2,
                                              maxLines: 5,
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                              decoration: InputDecoration(
                                                hintStyle: TextStyle(fontSize: 15),
                                                hintText: '',
                                              ),
                                              controller: _description,
                                              onChanged: (e) => {},
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
                              height: 1,
                              color: Colors.white,
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
                    size: 40.0,
                  ),
                ),
              ),
          ],
        ));
  }
}
