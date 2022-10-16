import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:store_app/constants/Theme.dart';
import 'package:store_app/models/productModel.dart';
import 'package:store_app/screens/update_product_screen.dart';

class ProductItem extends StatefulWidget {
  final ProductModel product;
  final Function(ProductModel product)? onTap;
  const ProductItem({
    Key? key,
    required this.product,
    required this.onTap,
  }) : super(key: key);

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  final currencyFormatter = NumberFormat('#,##0', 'ID');
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onTap!(widget.product),

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) =>
      //         UpdateProductScreen(productModel: widget.product),
      //   ),
      // );
      // },
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 5,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 7, top: 7),
          child: Container(
              height: 100,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
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
                        child: Image(
                          // color:70olors.red,
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                          image: NetworkImage(widget.product.image ??
                              "https://firebasestorage.googleapis.com/v0/b/lucky-science-341916.appspot.com/o/assets%2FImagesProducts%2Fa9bf8b5b-f24e-4452-92af-bfcd779983ff?alt=media&token=f17ac3db-4684-4e12-9262-98b2c94b2e57"),
                        )),
                  ),
                  Padding(padding: EdgeInsets.all(8)),
                  Container(
                      // width: 100,
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          widget.product.name!,
                          style: TextStyle(fontFamily: "SF Bold", fontSize: 16),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: Text(
                          widget.product.unit != "" ? widget.product.unit! : "",
                          style: TextStyle(
                              fontFamily: "SF Regular",
                              fontSize: 15,
                              color: Colors.grey),
                        ),
                      ),
                      Container(
                        child: Text(
                          currencyFormatter
                              .format((widget.product.pricePerPack!).toInt())
                              .toString(),
                          style: TextStyle(
                              fontFamily: "SF Semibold",
                              fontSize: 16,
                              color: MaterialColors.primary),
                        ),
                      ),
                    ],
                  )),
                ],
              ))),
    );
  }
}
