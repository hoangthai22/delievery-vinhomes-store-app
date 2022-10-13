import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:store_app/constants/Theme.dart';

class ProductItem extends StatefulWidget {
  final image;
  final productName;
  final productPrice;
  final productDes;

  const ProductItem(
      {Key? key,
      required this.image,
      required this.productDes,
      required this.productName,
      required this.productPrice})
      : super(key: key);

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  final currencyFormatter = NumberFormat('#,##0', 'ID');
  @override
  Widget build(BuildContext context) {
    return Container(
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
                        image: NetworkImage(widget.image ??
                            "https://firebasestorage.googleapis.com/v0/b/lucky-science-341916.appspot.com/o/assets%2FImagesProducts%2Fa9bf8b5b-f24e-4452-92af-bfcd779983ff?alt=media&token=f17ac3db-4684-4e12-9262-98b2c94b2e57"),
                      )),
                ),
                Container(
                    // width: 100,
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        widget.productName,
                        style: TextStyle(fontFamily: "SF Bold", fontSize: 16),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      child: Text(
                        widget.productDes != "" ? widget.productDes : "",
                        style: TextStyle(
                            fontFamily: "SF Regular",
                            fontSize: 15,
                            color: MaterialColors.grey),
                      ),
                    ),
                    Container(
                      child: Text(
                        currencyFormatter
                            .format((widget.productPrice).toInt())
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
            )));
  }
}
