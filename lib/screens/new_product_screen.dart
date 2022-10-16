import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store_app/constants/Theme.dart';
import 'package:store_app/models/categoryModel.dart';
import 'package:store_app/models/productModel.dart';
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
  List listUnit = [
    {"id": "1", "value": "Kg"},
    {"id": "2", "value": "Ly"},
    {"id": "3", "value": "Chai"},
    {"id": "4", "value": "Gam"},
    {"id": "5", "value": "Hộp"},
    {"id": "6", "value": "Hủ"},
    {"id": "7", "value": "Cái"},
  ];
  final _formKey = GlobalKey<FormState>();
  File? _image;
  bool valid = false;
  bool validImage = true;
  String _category = '';
  String _unit = '';
  String _name = '';
  double _pricePerPack = 0;
  final _controllerPricePerPack = TextEditingController();
  String _price = '';
  double _packNetWeight = 0;
  double _maximumQuantity = 0;
  double _minimumQuantity = 0;
  double _minimumDeIn = 0;
  String _packDescription = "";
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

  void hanldeSubmit() {
    if (_image != null) {
      var bytes = File(_image!.path).readAsBytesSync();
      String img64 = base64Encode(bytes);
      print(img64);
      print("_category" + _category);
      print("_unit" + _unit);
      print("_name" + _name);
      print("_pricePerPack" + _pricePerPack.toString());
      print("_price" + _price);
      print("_packNetWeight" + _packNetWeight.toString());
      print("_maximumQuantity" + _maximumQuantity.toString());
      print("_minimumQuantity" + _minimumQuantity.toString());
      print("_minimumDeIn" + _minimumDeIn.toString());
      print("_packDescription" + _packDescription.toString());
      ProductModel product = ProductModel(
          image: img64 ?? "",
          name: _name,
          categoryId: _category,
          packNetWeight: _packNetWeight ?? 0.0,
          packDescription: _packDescription ?? "",
          maximumQuantity: _maximumQuantity ?? 1.0,
          minimumQuantity: _minimumQuantity ?? 1.0,
          minimumDeIn: _minimumDeIn ?? 1.0,
          unit: _unit ?? "",
          pricePerPack: _pricePerPack ?? 0.0,
          storeId: "s4",
          rate: 0.0,
          description: "");
      ApiServices.postCreateProduct(product).then((value) => {
            if (value != null) {Navigator.pop(context)}
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
      print(e);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            "Tạo sản phẩm",
            style: TextStyle(
              color: MaterialColors.black,
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
                                margin: EdgeInsets.only(
                                    left: 10, bottom: 10, top: 10),
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
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50)),
                                        border:
                                            Border.all(color: Colors.white)),
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
                                margin: EdgeInsets.only(
                                    left: 10, bottom: 15, top: 10),
                                width: 165,
                                height: 155,
                                // color: Colors.amber,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    DottedBorder(
                                      color: !validImage
                                          ? Colors.red
                                          : MaterialColors.secondary,
                                      radius: Radius.circular(20),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                        child: Container(
                                          height: 150,
                                          width: 150,
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Ảnh",
                                            style: TextStyle(
                                                color: !validImage
                                                    ? Colors.red[700]
                                                    : MaterialColors.secondary,
                                                fontFamily: "SF Medium",
                                                fontSize: 16),
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
                              style: TextStyle(
                                  color: Colors.red[700], fontSize: 13),
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
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  border: Border.all(
                                      color: MaterialColors.secondary)),
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
                                    style: TextStyle(
                                        color: MaterialColors.secondary,
                                        fontFamily: "SF Bold",
                                        fontSize: 17),
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
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  border: Border.all(
                                      color: MaterialColors.secondary)),

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
                                    style: TextStyle(
                                        color: MaterialColors.secondary,
                                        fontFamily: "SF Bold",
                                        fontSize: 17),
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
                        padding: EdgeInsets.only(
                            left: 15, right: 15, top: 15, bottom: 25),
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
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 20),
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
                                              Padding(
                                                  padding: EdgeInsets.all(2)),
                                              Text(
                                                "*",
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 20),
                                              )
                                            ],
                                          ),
                                        ),
                                        TextFormField(
                                          keyboardType: TextInputType.number,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
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
                                                setState(() => {
                                                      _pricePerPack =
                                                          double.parse(e)
                                                    })
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
                                              Padding(
                                                  padding: EdgeInsets.all(2)),
                                              Text(
                                                "*",
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 18),
                                              )
                                            ],
                                          ),
                                        ),
                                        DropdownButtonFormField<String>(
                                          isExpanded: true,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
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
                                            });
                                          },
                                          items: listUnit.map((value) {
                                            return DropdownMenuItem<String>(
                                              value: value["value"],
                                              child: Text(
                                                  value["value"].toString()),
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
                                              Padding(
                                                  padding: EdgeInsets.all(2)),
                                              Text(
                                                "*",
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 18),
                                              )
                                            ],
                                          ),
                                        ),
                                        DropdownButtonFormField<String>(
                                          isExpanded: true,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Danh mục không được để trống";
                                            }
                                            return null;
                                          },
                                          value: _category == ''
                                              ? null
                                              : _category,
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
                                              child:
                                                  Text(value.name.toString()),
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
                            padding: EdgeInsets.only(
                                left: 15, right: 15, bottom: 25),
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
                                                    "Đóng gói",
                                                    style: TextStyle(
                                                      fontFamily: "SF Semibold",
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                hintStyle:
                                                    TextStyle(fontSize: 16),
                                                hintText:
                                                    'Ví dụ: 1 Ly, 500g,...',
                                              ),
                                              // controller: controller,
                                              onChanged: (e) => {
                                                if (e != "")
                                                  {
                                                    setState(() => {
                                                          _packNetWeight =
                                                              double.parse(e)
                                                        })
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
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                hintStyle:
                                                    TextStyle(fontSize: 16),
                                                hintText: '0',
                                              ),
                                              // controller: controller,
                                              onChanged: (e) => {
                                                if (e != "")
                                                  {
                                                    setState(() => {
                                                          _minimumDeIn =
                                                              double.parse(e)
                                                        })
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
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                hintStyle:
                                                    TextStyle(fontSize: 16),
                                                hintText: '0',
                                              ),
                                              // controller: controller,
                                              onChanged: (e) => {
                                                if (e != "")
                                                  {
                                                    setState(() => {
                                                          _maximumQuantity =
                                                              double.parse(e)
                                                        })
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
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                hintStyle:
                                                    TextStyle(fontSize: 16),
                                                hintText: '0',
                                              ),
                                              // controller: controller,
                                              onChanged: (e) => {
                                                if (e != "")
                                                  {
                                                    setState(() => {
                                                          _minimumQuantity =
                                                              double.parse(e)
                                                        })
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
                                              decoration: InputDecoration(
                                                hintStyle:
                                                    TextStyle(fontSize: 16),
                                                hintText: 'Ví dụ: 330ml / Chai',
                                              ),
                                              // controller: controller,
                                              onChanged: (e) => {
                                                if (e != "")
                                                  {
                                                    setState(() =>
                                                        {_packDescription = e})
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
                    padding: EdgeInsets.only(
                        left: 15, right: 15, top: 10, bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      height: 45,
                      child: ElevatedButton(
                        child: Text(
                          "Hoàn tất",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "SF Bold",
                              fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: MaterialColors.primary,
                          textStyle: TextStyle(color: Colors.black),
                          shadowColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => {
                          if (_formKey.currentState!.validate())
                            {hanldeSubmit()},
                          if (_image == null)
                            {
                              setState(() {
                                validImage = false;
                              })
                            }
                        },
                      ),
                    ))),
          ],
        ));
  }
}
