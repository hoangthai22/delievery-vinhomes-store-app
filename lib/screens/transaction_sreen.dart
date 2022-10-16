import 'package:flutter/cupertino.dart';

class TransactionSreen extends StatefulWidget {
  const TransactionSreen({Key? key}) : super(key: key);

  @override
  _TransactionSreenState createState() => _TransactionSreenState();
}

class _TransactionSreenState extends State<TransactionSreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Transaction")),
    );
  }
}
