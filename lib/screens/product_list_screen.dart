import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:store_app/apis/apiService.dart';
import 'package:store_app/constants/Theme.dart';
import 'package:store_app/models/productModel.dart';
import 'package:store_app/screens/update_product_screen.dart';
import 'package:store_app/widgets/product/product_list.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen>
    with TickerProviderStateMixin {
  late List<ProductModel> listProduct = [];
  late bool isLoading = true;
  late bool _isLoadingMore = false;
  late bool isListFull = false;
  late int page = 1;
  final ScrollController scrollController = ScrollController();
  late final AnimationController _controller;
  late final Animation<double> _animation;

  getListProduct() {
    ApiServices.getListProduct("s4", page, 8).then((value) => {
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

  @override
  void initState() {
    super.initState();
    getListProduct();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    )..forward(from: 0);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent &&
          !_isLoadingMore &&
          !isListFull) {
        setState(() {
          _isLoadingMore = true;
        });
        List<ProductModel> products = [];
        List<ProductModel> newProducts = [];
        ApiServices.getListProduct("s4", page, 8).then((value) => {
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
    _controller.stop();
    _controller.dispose();
    // scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          centerTitle: true,
          title: Text(
            "Danh sách sản phẩm",
            style:
                TextStyle(color: MaterialColors.black, fontFamily: "SF Bold"),
          ),
        ),
        body: Stack(
          children: [
            if (!isLoading) ...[
              FadeTransition(
                opacity: _animation,
                child: ListView(
                  controller: scrollController,
                  children: [
                    Padding(padding: EdgeInsets.all(10)),
                    ProductList(
                      productList: listProduct,
                      onTap: (pro) => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UpdateProductScreen(productModel: pro),
                          ),
                        )
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
              ),
            ],

            // Container(
            //   height: MediaQuery.of(context).size.height,
            //   width: MediaQuery.of(context).size.width,
            //   color: Colors.white,
            // ),
            if (isLoading) ...[
              SpinKitDualRing(
                color: MaterialColors.primary,
                size: 50.0,
              ),
            ],
            Positioned(
                right: 15,
                bottom: 15,
                child: Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width * 0.42,
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
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "SF Bold",
                                fontSize: 17),
                          ),
                        ],
                      ),
                      onPressed: () => {
                            // Navigator.pushNamed(context, "/new-product")
                            Navigator.pushNamed(context, '/new-product')
                                .then((_) => setState(() {
                                      isLoading = true;
                                      _isLoadingMore = false;
                                      page = 1;
                                      listProduct = [];
                                      ApiServices.getListProduct("s4", 1, 8)
                                          .then((value) => {
                                                if (value != null)
                                                  {
                                                    setState(() {
                                                      listProduct = value;
                                                      isLoading = false;
                                                      isListFull = false;
                                                    })
                                                  }
                                              });
                                    }))
                          }),
                ))
          ],
        ));
  }
}
