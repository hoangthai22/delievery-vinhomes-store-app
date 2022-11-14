import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store_app/constants/Theme.dart';
import 'package:store_app/models/productModel.dart';
import 'package:store_app/widgets/product/product_item.dart';

class ProductList extends StatefulWidget {
  List<ProductModel> productList = [];
  final Function(ProductModel product, bool delete)? onTap;
  ProductList({Key? key, required this.productList, required this.onTap})
      : super(key: key);

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        if (widget.productList.isNotEmpty)
          ...widget.productList.map(
            (ProductModel pro) => ProductItem(
                product: pro,
                onTap: (pro, delete) => {
                      widget.onTap!(pro, delete),
                    }),
          )
        else ...[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 150,
                  width: 150,
                  child: Image.asset(
                    'assets/images/empty-order.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  "Không có sản phầm nào!",
                  style: TextStyle(
                      color: MaterialColors.black,
                      fontFamily: "SF Regular",
                      fontSize: 15),
                )
              ],
            ),
          )
        ]
      ],
    ));
  }
}
