import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:store_app/constants/Theme.dart';
import 'package:store_app/models/productMenuModel.dart';

class MenuModalItem extends StatefulWidget {
  late ValueChanged<String> function;
  late ProductMenuModel product;
  MenuModalItem({Key? key, required this.product, required this.function})
      : super(key: key);

  @override
  _MenuModalItemState createState() => _MenuModalItemState();
}

class _MenuModalItemState extends State<MenuModalItem> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat('#,##0', 'ID');
    return InkWell(
      onTap: () => {
        setState(() {
          isChecked = !isChecked;
          widget.function(widget.product.id!);
        })
      },

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
              border:
                  Border(bottom: BorderSide(color: Colors.black12, width: 1))),
          padding: const EdgeInsets.only(left: 0, right: 15, bottom: 7, top: 7),
          child: Container(
              height: 80,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(children: [
                      Container(
                        // width: 100,
                        padding: EdgeInsets.only(left: 10),
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
                              height: 70,
                              width: 70,
                              fit: BoxFit.cover,
                              image: NetworkImage(widget.product.image!),
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
                            width: MediaQuery.of(context).size.width - 190,
                            child: Text(
                              widget.product.name!,
                              maxLines: 1,
                              style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontFamily: "SF Bold",
                                  fontSize: 16),
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(5)),
                          Container(
                            child: Text(
                              currencyFormatter
                                      .format((widget.product.pricePerPack!)
                                          .toInt())
                                      .toString() +
                                  "₫",
                              style: TextStyle(
                                  fontFamily: "SF Semibold",
                                  fontSize: 16,
                                  color: MaterialColors.primary),
                            ),
                          ),
                        ],
                      )),
                    ]),
                  ),
                  Container(
                    child: Checkbox(
                      checkColor: Colors.white,
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                          widget.function(widget.product.id!);
                        });
                      },
                    ),
                  )
                ],
              ))),
    );
  }
}
