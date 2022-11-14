import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store_app/constants/Theme.dart';
import 'package:url_launcher/url_launcher.dart';

class TransactionSreen extends StatefulWidget {
  const TransactionSreen({Key? key}) : super(key: key);

  @override
  _TransactionSreenState createState() => _TransactionSreenState();
}

class _TransactionSreenState extends State<TransactionSreen> {
  var filterActive = 0;
  transactionTitle() {
    return Container(
      decoration: BoxDecoration(
          // color: Color.fromARGB(255, 243, 247, 251),
          ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  child: Text(
                    "Tháng 9/2022",
                    style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 20,
                        fontFamily: "SF Bold"),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.all(10),
            color: Color.fromRGBO(255, 170, 76, 1).withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Xem báo cáo tháng này",
                  style: TextStyle(
                      fontSize: 17,
                      color: MaterialColors.primary,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  child: Icon(
                    Icons.navigate_next,
                    color: MaterialColors.primary,
                    size: 28,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  var deliver = Row(
    // mainAxisAlignment: MainAxisAlignment.center,
    // crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(kSpacingUnit * 1),
          color: Color.fromARGB(255, 243, 247, 251),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Chuyển tiền đến công ty",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Text("11:11  - 01/01/2022"),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 243, 247, 251),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Text("Số dư ví: **********"),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Text(
                              "- 111.111 vnd",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ],
  );

  transactionItem(index) {
    return Container(
      padding: EdgeInsets.only(right: 15, top: 15, bottom: 15, left: 15),
      color: index % 2 == 1 ? Colors.white : Color.fromRGBO(250, 250, 250, 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            // color: Color.fromRGBO(200, 200, 200, 1),
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(kSpacingUnit * 1),
            // ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                        height: 50,
                        width: 50,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                  width: 1,
                                  color: Color.fromRGBO(230, 230, 230, 1))),
                          child: Center(
                            child: Container(
                              height: 17,
                              width: 17,
                              child: Image.asset(
                                'assets/images/wallet.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 20,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Text(
                            "Rút tiền từ ví về TP Bank",
                            style: TextStyle(
                                fontFamily: "SF SemiBold", fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Row(
                        children: [
                          Text(
                            "11:11, 01/01/2022",
                            style: TextStyle(
                                color: Color.fromRGBO(150, 150, 150, 1),
                                fontFamily: "SF Regular",
                                fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(
                    //   height: 5,
                    // ),
                    // Container(
                    //   child: Row(
                    //     children: [
                    //       Text(
                    //         "Số dư ví: **********",
                    //         style: TextStyle(
                    //             fontFamily: "SF Regular", fontSize: 14),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                )
              ],
            ),
          ),
          Text(
            "-100.000",
            style: TextStyle(fontFamily: "SF SemiBold", fontSize: 16),
          ),
        ],
      ),
    );
  }

  var revenue = Container(
    margin: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
    padding: EdgeInsets.all(15),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
      border: Border.all(color: Color.fromRGBO(200, 200, 200, 1)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hôm nay",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontFamily: "SF SemiBold"),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          "0.00 đ",
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontFamily: "SF Bold"),
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.event_available,
                  size: 20,
                  color: Color.fromRGBO(80, 80, 80, 1),
                ),
                SizedBox(
                  width: 10,
                ),
                Row(
                  children: [
                    Text(
                      "0",
                      style: TextStyle(
                          color: Color.fromRGBO(80, 80, 80, 1), fontSize: 14),
                    ),
                    Text(
                      " đơn hàng hoàn tất",
                      style: TextStyle(
                          color: Color.fromRGBO(80, 80, 80, 1), fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  child: OutlinedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(
                          MaterialColors.primary),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    onPressed: null,
                    child: Text('Xem chi tiết',
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 16,
                            fontFamily: "SF SemiBold")),
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    ),
  );

  filter() {
    return Container(
      color: Color.fromARGB(255, 243, 247, 251),
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                filterActive = 0;
              });
            },
            child: Container(
              width: 90,
              padding:
                  EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
              decoration: BoxDecoration(
                  color:
                      filterActive == 0 ? MaterialColors.primary : Colors.white,
                  border: Border.all(
                      color: filterActive == 0
                          ? MaterialColors.primary
                          : Color.fromRGBO(230, 230, 230, 1)),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Text('Tất cả',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: filterActive == 0 ? Colors.white : Colors.black,
                      fontSize: 15,
                      fontFamily: "SF Regular")),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              setState(() {
                filterActive = 1;
              });
            },
            child: Container(
              width: 90,
              padding:
                  EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
              decoration: BoxDecoration(
                  color:
                      filterActive == 1 ? MaterialColors.primary : Colors.white,
                  border: Border.all(
                      color: filterActive == 1
                          ? MaterialColors.primary
                          : Color.fromRGBO(230, 230, 230, 1)),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Text('Nhận tiền',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: filterActive == 1 ? Colors.white : Colors.black,
                      fontSize: 15,
                      fontFamily: "SF Regular")),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              setState(() {
                filterActive = 2;
              });
            },
            child: Container(
              width: 90,
              padding:
                  EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
              decoration: BoxDecoration(
                  color:
                      filterActive == 2 ? MaterialColors.primary : Colors.white,
                  border: Border.all(
                      color: filterActive == 2
                          ? MaterialColors.primary
                          : Color.fromRGBO(230, 230, 230, 1)),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Text('Rút tiền',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: filterActive == 2 ? Colors.white : Colors.black,
                      fontSize: 15,
                      fontFamily: "SF Regular")),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          centerTitle: true,
          title: Text(
            "Giao dịch",
            style:
                TextStyle(color: MaterialColors.black, fontFamily: "SF Bold"),
          ),
          // bottom:
        ),
        body: SingleChildScrollView(
            child: Container(
          color: Colors.white,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 25,
              ),
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  "Tổng kết doanh thu",
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: "SF Bold",
                      fontSize: 20),
                ),
              ),

              revenue,

              filter(),
              transactionTitle(),
              ...[1, 2, 3, 4, 5].map((item) => transactionItem(item)).toList(),
              SizedBox(
                height: 5,
              ),
              // deliver1,
              // SizedBox(
              //   height: kSpacingUnit * 0.5,
              // ),
              // deliver2
            ],
          ),
        )));
  }
}
