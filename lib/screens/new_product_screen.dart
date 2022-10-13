import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store_app/constants/Theme.dart';
import 'package:store_app/models/categoryModel.dart';
import 'package:store_app/widgets/accordion/accordion.dart';
import 'package:store_app/apis/apiService.dart';

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

  bool valid = false;
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
    Navigator.pop(context);
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
                  margin: EdgeInsets.only(top: 30, bottom: 100),

                  child: Column(
                    children: [
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
                                                "Giá vốn",
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
                                              return "Giá vốn không được để trống";
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            hintStyle: TextStyle(fontSize: 16),
                                            hintText: '0.000',
                                          ),
                                          // controller: controller,
                                          onChanged: (e) => {},
                                          // obscureText: isPassword,
                                        )
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
                                Padding(padding: EdgeInsets.all(15)),
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
                                              value: value["id"],
                                              child: Text(
                                                  value["value"].toString()),
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
                            {hanldeSubmit()}
                        },
                      ),
                    ))),
          ],
        ));
  }
}
