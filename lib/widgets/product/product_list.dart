import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store_app/constants/Theme.dart';
import 'package:store_app/models/productModel.dart';
import 'package:store_app/widgets/product/product_item.dart';

class ProductList extends StatefulWidget {
  List<ProductModel> productList = [];
  final Function(ProductModel product)? onTap;
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
            (ProductModel pro) =>
                ProductItem(product: pro, onTap: (pro) => {widget.onTap!(pro)}),
          )
        else ...[
          Container(
            height: 200,
            child: Center(
              child: Text("Không có sản phẩm nào"),
            ),
          )
        ]
      ],
    ));
  }
}
