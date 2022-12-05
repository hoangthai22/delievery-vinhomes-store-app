import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:store_app/apis/apiService.dart';
import 'package:store_app/constants/Theme.dart';
import 'package:store_app/models/productModel.dart';
import 'package:store_app/screens/update_product_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductItem extends StatefulWidget {
  final ProductModel product;
  final Function(ProductModel product, bool delete)? onTap;
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
      onTap: () => widget.onTap!(widget.product, false),

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
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              child: Container(
                  height: 100,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(padding: EdgeInsets.all(5)),
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
                                  "https://firebasestorage.googleapis.com/v0/b/deliveryfood-9c436.appspot.com/o/food%2Ftopic-2.webp?alt=media&token=54a5086f-f2ea-4009-9479-28624019703e"),
                            )),
                      ),
                      Padding(padding: EdgeInsets.all(8)),
                      Expanded(
                        child: Container(
                            // width: 100,
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                widget.product.name!,
                                maxLines: 1,
                                style: TextStyle(fontFamily: "SF Bold", fontSize: 16, overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 5, bottom: 5),
                              child: Text(
                                widget.product.packDescription != "" ? widget.product.packDescription! : widget.product.unit!,
                                style: TextStyle(fontFamily: "SF Regular", fontSize: 15, color: Colors.grey),
                              ),
                            ),
                            Container(
                              child: Text(
                                currencyFormatter.format((widget.product.pricePerPack!).toInt()).toString() + "₫",
                                style: TextStyle(fontFamily: "SF Semibold", fontSize: 16, color: MaterialColors.primary),
                              ),
                            ),
                          ],
                        )),
                      )
                    ],
                  )),
            ),
            InkWell(
              onTap: () {
                Dialogs.materialDialog(
                    dialogShape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    msg: 'Bạn có chắc muốn xóa sản phẩm khỏi thực đơn?',
                    msgAlign: TextAlign.center,
                    title: "Xóa sản phẩm",
                    color: Colors.white,
                    context: context,
                    actions: [
                      IconsOutlineButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        text: 'Hủy',
                        iconData: Icons.cancel_outlined,
                        textStyle: TextStyle(color: Colors.grey),
                        iconColor: Colors.grey,
                      ),
                      IconsButton(
                        onPressed: () {
                          Navigator.pop(context);
                          widget.onTap!(widget.product, true);
                        },
                        text: 'Xóa',
                        iconData: Icons.delete,
                        color: Colors.red,
                        textStyle: TextStyle(color: Colors.white),
                        iconColor: Colors.white,
                      ),
                    ]);
              },
              child: Container(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.delete_outline, color: Colors.grey),
              ),
            )
          ])),
    );
  }
}
