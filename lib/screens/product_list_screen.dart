import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:store_app/apis/apiService.dart';
import 'package:store_app/constants/Theme.dart';
import 'package:store_app/models/messageModel.dart';
import 'package:store_app/models/productModel.dart';
import 'package:store_app/provider/appProvider.dart';
import 'package:store_app/screens/update_product_screen.dart';
import 'package:store_app/widgets/product/product_list.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProductListScreen extends StatefulWidget {
  String storeId;
  ProductListScreen({Key? key, required this.storeId}) : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late List<ProductModel> listProduct = [];
  late bool isLoading = true;
  late bool _isLoadingMore = false;
  late bool isListFull = false;
  late int page = 1;
  final ScrollController scrollController = ScrollController();

  getListProduct() {
    ApiServices.getListProduct(widget.storeId, page, 8).then((value) => {
          if (value != null)
            {
              setState(() {
                listProduct = value;
                isLoading = false;
                page++;
              })
            }
        });
  }

  Map<String, dynamic> toJson(message) {
    return {
      jsonEncode("message"): jsonEncode(message),
    };
  }

  void handleDelete(id) {
    setState(() {
      isLoading = true;
    });
    MessageModel mess = MessageModel();
    ApiServices.deleteProduct(id).then((value) => {
          if (value != null)
            {
              // print("toJson(value): " + toJson(value).toString()),
              // mess = value,
              if (value == "Deleted products sucessfull !!")
                {
                  setState(() {
                    _isLoadingMore = false;
                    page = 1;
                  }),
                  Fluttertoast.showToast(
                      msg: "Xóa sản phẩm thành công",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0),
                  ApiServices.getListProduct(widget.storeId, 1, 8).then((value) => {
                        if (value != null)
                          {
                            setState(() {
                              listProduct = value;
                              isLoading = false;
                              isListFull = false;
                            })
                          }
                      })
                }
              else
                {
                  setState(() {
                    isLoading = false;
                  }),
                  Fluttertoast.showToast(
                      msg: "Hiện tại sản phẩm đang có trong menu. Vui lòng xóa sản phẩm khỏi menu và thử lại",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0)
                }
            }
        });
  }

  @override
  void initState() {
    super.initState();
    getListProduct();

    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent && !_isLoadingMore && !isListFull) {
        setState(() {
          _isLoadingMore = true;
        });
        List<ProductModel> products = [];
        List<ProductModel> newProducts = [];
        ApiServices.getListProduct(widget.storeId, page, 8).then((value) => {
              if (value != null)
                {
                  products = value,
                  if (products.isEmpty)
                    {
                      setState(() {
                        isListFull = true;
                        isLoading = false;
                        _isLoadingMore = false;
                      })
                    }
                  else
                    {
                      newProducts = [...listProduct, ...products],
                      setState(() {
                        isLoading = false;
                        _isLoadingMore = false;
                        isListFull = false;
                        listProduct = newProducts;
                        page++;
                      })
                    }
                }
              else
                {
                  setState(() {
                    isLoading = false;
                    _isLoadingMore = false;
                    isListFull = true;
                    listProduct = [];
                  })
                }
            });
      }
    });
    // futureMentor = fetchData();
  }

  // @override
  // void didChangeDependencies() {
  //   _controller.dispose();
  //   super.didChangeDependencies();
  // }

  @override
  void dispose() {
    // scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [MaterialColors.primary, Color(0xfff7892b)]),
            ),
          ),
          centerTitle: true,
          title: Text(
            "Danh sách sản phẩm",
            style: TextStyle(color: MaterialColors.white, fontFamily: "SF Bold"),
          ),
        ),
        body: Stack(
          children: [
            if (!isLoading) ...[
              ListView(
                controller: scrollController,
                children: [
                  Padding(padding: EdgeInsets.all(10)),
                  ProductList(
                    productList: listProduct,
                    onTap: (pro, delete) => {
                      if (delete)
                        {handleDelete(pro.id)}
                      else
                        {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UpdateProductScreen(
                                        productModel: pro,
                                      ))).then((_) => setState(() {
                                isLoading = true;
                                _isLoadingMore = false;
                                page = 1;
                                listProduct = [];
                                ApiServices.getListProduct(widget.storeId, 1, 8).then((value) => {
                                      if (value != null)
                                        {
                                          setState(() {
                                            listProduct = value;
                                            isLoading = false;
                                            _isLoadingMore = false;
                                            isListFull = false;
                                            page++;
                                          }),
                                        }
                                    });
                              })),
                        }
                    },
                  ),
                  if (_isLoadingMore)
                    Center(
                        child: Container(
                            margin: EdgeInsets.only(bottom: 20, top: 20),
                            child: CircularProgressIndicator(
                              strokeWidth: 5.0,
                              color: MaterialColors.primary,
                            ))),
                ],
              ),
            ],

            // Container(
            //   height: MediaQuery.of(context).size.height,
            //   width: MediaQuery.of(context).size.width,
            //   color: Colors.white,
            // ),
            if (isLoading) ...[
              SizedBox(
                child: SpinKitDualRing(
                  color: MaterialColors.primary,
                  size: 45.0,
                ),
              ),
            ],
            Positioned(
                right: 15,
                bottom: 15,
                child: Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: MaterialColors.secondary,
                        textStyle: TextStyle(color: Colors.black),
                        shadowColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              child: Icon(
                            Icons.add,
                            color: Colors.white,
                          )),
                          Padding(padding: EdgeInsets.all(3)),
                          Text(
                            "Tạo sản phẩm",
                            style: TextStyle(color: Colors.white, fontFamily: "SF Bold", fontSize: 17),
                          ),
                        ],
                      ),
                      onPressed: () => {
                            // Navigator.pushNamed(context, "/new-product")
                            Navigator.pushNamed(context, '/new-product').then((_) => setState(() {
                                  isLoading = true;
                                  _isLoadingMore = false;
                                  page = 1;
                                  listProduct = [];
                                  ApiServices.getListProduct(widget.storeId, 1, 8).then((value) => {
                                        if (value != null)
                                          {
                                            setState(() {
                                              listProduct = value;
                                              isLoading = false;
                                              _isLoadingMore = false;
                                              isListFull = false;
                                              page++;
                                            }),
                                          }
                                      });
                                }))
                          }),
                ))
          ],
        ));
  }
}
