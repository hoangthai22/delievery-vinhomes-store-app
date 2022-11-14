import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Status {
  static const String CREATEORDER = "1";
  static const String SHIPPERACCEPT = "2";
  static const String SHIPPING = "3";
  static const String DONE = "4";
  static const String CANCEL = "5";

  static String getStatusName(status) {
    if (status == 0 || status == 1 || status == 2 || status == 3) {
      return "Đang chuẩn bị";
    } else if (status == 4 || status == 7 || status == 8) {
      return "Đang giao";
    } else if (status == 5) {
      return "Hoàn thành";
    } else if (status == 10) {
      return "Tài xế hủy";
    } else if (status == 11) {
      return "Bạn đã hủy";
    } else if (status == 12) {
      return "Khách hàng hủy";
    } else {
      return "Đã hủy";
    }
  }

  static Color? getStatusColor(status) {
    if (status == 0 || status == 1 || status == 2 || status == 3) {
      return Colors.amber[800];
    } else if (status == 4 || status == 7 || status == 8) {
      return Colors.lightBlue[900];
    } else if (status == 5) {
      return Colors.green;
    } else {
      return Colors.red[600];
    }
  }
}

String changeEndTime(orderTime) {
  var newDateTimeObj = DateFormat().add_yMd().add_Hm().parse(orderTime);
  DateTime customDateTime = DateTime(newDateTimeObj.year, newDateTimeObj.month,
      newDateTimeObj.day, newDateTimeObj.hour, newDateTimeObj.minute);
  var start =
      TimeOfDay.fromDateTime(customDateTime.add(const Duration(seconds: 600)));
  var end =
      TimeOfDay.fromDateTime(customDateTime.add(const Duration(minutes: 20)));
  var timeStart = "";
  var timeEnd = "";
  if (start.minute < 10) {
    timeStart = "${start.hour}:0${start.minute}";
  } else {
    timeStart = "${start.hour}:${start.minute}";
  }
  if (end.minute < 10) {
    timeEnd = "${end.hour}:0${end.minute}";
  } else {
    timeEnd = "${end.hour}:${end.minute}";
  }
  return "$timeStart - $timeEnd";
}

String getIconOrder(modeId) {
  if (modeId == "1") {
    return "assets/images/hamburger.png";
  } else if (modeId == "2") {
    return "assets/images/groceries.png";
  } else {
    return "assets/images/food-delivery.png";
  }
}

String getModeName(modeId) {
  if (modeId == "1") {
    return "Giao ngay";
  } else if (modeId == "2") {
    return "Giao trong ngày";
  } else {
    return "Đơn hàng đặt trước";
  }
}

String getModeMessage(modeId) {
  if (modeId == "1") {
    return "Tài xế sẽ đên vào 18:15 - 18:30";
  } else if (modeId == "2") {
    return "Tài xế sẽ đên vào 14:00 - 16:30";
  } else if (modeId == "3") {
    return "Thứ Tư, 11/16/2022, 15:00 - 18:00";
  } else {
    return "";
  }
}

String getTooltipMessage(modeId) {
  if (modeId == "1") {
    return "Đơn hàng giao trong 30 phút";
  } else if (modeId == "2") {
    return "Đơn hàng giao trong ngày";
  } else if (modeId == "3") {
    return "Đơn hàng được đặt trước và giao khi đến ngày";
  } else {
    return "";
  }
}

String getTime(String time) {
  var result = "";
  var day = time.toString().split(" ")[0];
  if (day != null) {
    result =
        "${time.toString().split(" ")[1]}, ${day.toString().split("/")[2]} thg ${day.toString().split("/")[1]}";
  } else {
    result = time;
  }

  return result;
}
