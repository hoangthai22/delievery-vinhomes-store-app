import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store_app/constants/Theme.dart';
import 'package:store_app/models/productModel.dart';
import 'package:store_app/widgets/product/product_item.dart';

class ProductList extends StatefulWidget {
  List<ProductModel> productList = [];

  ProductList({Key? key, required this.productList}) : super(key: key);

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        if (widget.productList.length > 0)
          ...widget.productList.map(
            (ProductModel pro) => ProductItem(
              image: pro.image,
              // ? pro.image
              // : "https://firebasestorage.googleapis.com/v0/b/lucky-science-341916.appspot.com/o/assets%2FImagesProducts%2Fa9bf8b5b-f24e-4452-92af-bfcd779983ff?alt=media&token=f17ac3db-4684-4e12-9262-98b2c94b2e57",
              productName: pro.name,
              productDes: pro.unit,
              productPrice: pro.pricePerPack,
            ),
          )
      ],
    ));
  }
}
