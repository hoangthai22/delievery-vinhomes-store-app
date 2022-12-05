import 'dart:ui';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:store_app/constants/Theme.dart';

class Status {
  static const String CREATEORDER = "1";
  static const String SHIPPERACCEPT = "2";
  static const String SHIPPING = "3";
  static const String DONE = "4";
  static const String CANCEL = "5";

  static String getStatusName(status) {
    if (status == 0 || status == 1 || status == 2 || status == 3) {
      return "Đang chuẩn bị";
    } else if (status == 4 || status == 7 || status == 8 || status == 9) {
      return "Đang giao";
    } else if (status == 5) {
      return "Hoàn thành";
    } else if (status == 10) {
      return "Tự động hủy";
    } else if (status == 11) {
      return "Bạn đã hủy";
    } else if (status == 12) {
      return "Tài xế hủy";
    } else if (status == 13) {
      return "Khách hàng hủy";
    } else {
      return "Đã hủy";
    }
  }

  static Color? getStatusColorText(status) {
    if (status == 0 || status == 1 || status == 2 || status == 3) {
      return MaterialColors.primary;
    } else if (status == 7 || status == 8 || status == 9 || status == 4) {
      return MaterialColors.secondary;
    } else if (status == 5) {
      return MaterialColors.success;
    } else {
      return Colors.red[600];
    }
  }

  static List<Color>? getStatusColor(status) {
    if (status == 0 || status == 1 || status == 2 || status == 3) {
      return [MaterialColors.primary, Color(0xfff7892b)];
    } else if (status == 7 || status == 8 || status == 9 || status == 4) {
      return [Color.fromARGB(255, 32, 129, 209), MaterialColors.secondary];
    } else if (status == 5) {
      return [Colors.green, MaterialColors.success];
    } else {
      return [Colors.redAccent, Colors.red];
    }
  }
}

String changeEndTime(orderTime, modeId, fromHour, toHour) {
  var inputFormat = DateFormat('yyyy-MM-ddTHH:mm:ss');
  var inputDate = inputFormat.parse(orderTime); // <-- dd/MM 24H format

  if (modeId == "1") {
    var startTime = inputDate.add(const Duration(seconds: 900));

    var outputFormatStart = DateFormat('HH:mm');
    var outputDateStart = outputFormatStart.format(startTime);

    var endTime = inputDate.add(const Duration(seconds: 1800));
    var outputFormatEnd = DateFormat('HH:mm');
    var outputDateEnd = outputFormatEnd.format(endTime);
    return "$outputDateStart - $outputDateEnd";
  } else {
    // var outputFormat = DateFormat('dd/MM/yyyy hh:mm a');
    // var outputDate = outputFormat.format(inputDate);
    return "${fromHour} - ${toHour}";
  }
  // DateTime customDateTime = DateTime(newDateTimeObj.year, newDateTimeObj.month,
  //     newDateTimeObj.day, newDateTimeObj.hour, newDateTimeObj.minute);
  // var start =
  //     TimeOfDay.fromDateTime(customDateTime.add(const Duration(seconds: 600)));
  // var end =
  //     TimeOfDay.fromDateTime(customDateTime.add(const Duration(minutes: 20)));
  // var timeStart = "";
  // var timeEnd = "";
  // if (start.minute < 10) {
  //   timeStart = "${start.hour}:0${start.minute}";
  // } else {
  //   timeStart = "${start.hour}:${start.minute}";
  // }
  // if (end.minute < 10) {
  //   timeEnd = "${end.hour}:0${end.minute}";
  // } else {
  //   timeEnd = "${end.hour}:${end.minute}";
  // }
  // return "$timeStart - $timeEnd";
}

String getTimeMode3(time) {
  var inputFormat = DateFormat('yyyy-MM-dd');
  var inputDate = inputFormat.parse(time);
  var dayFormat = DateFormat('dd');
  var monthFormat = DateFormat('MM');
  var weekFormat = DateFormat('EEEE');
  var outputDay = dayFormat.format(inputDate);
  var outputMonth = monthFormat.format(inputDate);
  var outputWeek = weekFormat.format(inputDate);
  switch (outputWeek) {
    case "Monday":
      outputWeek = "T2";
      break;
    case "Tuesday":
      outputWeek = "T3";
      break;
    case "Wednesday":
      outputWeek = "T4";
      break;
    case "Thursday":
      outputWeek = "T5";
      break;
    case "Friday":
      outputWeek = "T6";
      break;
    case "Saturday":
      outputWeek = "T7";
      break;
    case "Sunday":
      outputWeek = "CN";
      break;
    default:
  }
  return "$outputWeek, $outputDay Tháng $outputMonth";
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

String getModeMessage(List listStatusOrder, int status, String modeId, String dayFilter, String timeOrder, String fromHour, String toHour) {
  var time = "";
  var outputDateTime = "";
  var outputDateDay = "";
  var outputDateMonth = "";
  var inputFormat = DateFormat('yyyy-MM-ddTHH:mm:ss');
  var outputFormatTime = DateFormat('HH:mm a');
  var outputFormatDay = DateFormat('dd');
  var outputFormatMonth = DateFormat('MM');

  if (status == 5) {
    listStatusOrder.map((dynamic item) {
      if (item["status"] == 5) {
        time = item["time"];
        var inputDate = inputFormat.parse(time); //
        outputDateTime = outputFormatTime.format(inputDate);
        outputDateMonth = outputFormatMonth.format(inputDate);
        outputDateDay = outputFormatDay.format(inputDate);
      }
    }).toList();
    return "Đã hoàn tất vào $outputDateDay Tháng $outputDateMonth, $outputDateTime";
  } else if (status == 6) {
    listStatusOrder.map((dynamic item) {
      if (item["status"] == 6) {
        time = item["time"];
        var inputDate = inputFormat.parse(time); //
        outputDateTime = outputFormatTime.format(inputDate);
        outputDateMonth = outputFormatMonth.format(inputDate);
        outputDateDay = outputFormatDay.format(inputDate);
      }
    }).toList();
    return "Đơn hàng đã hủy vào $outputDateDay Tháng $outputDateMonth, $outputDateTime";
  } else if (status == 7 || status == 8 || status == 9) {
    return "Tài xế đang giao đơn hàng";
  } else if (status == 10) {
    listStatusOrder.map((dynamic item) {
      if (item["status"] == 10) {
        time = item["time"];
        var inputDate = inputFormat.parse(time); //
        outputDateTime = outputFormatTime.format(inputDate);
        outputDateMonth = outputFormatMonth.format(inputDate);
        outputDateDay = outputFormatDay.format(inputDate);
      }
    }).toList();
    return "Đơn hàng đã hủy vào $outputDateDay Tháng $outputDateMonth, $outputDateTime";
  } else if (status == 11) {
    listStatusOrder.map((dynamic item) {
      if (item["status"] == 11) {
        time = item["time"];
        var inputDate = inputFormat.parse(time); //
        outputDateTime = outputFormatTime.format(inputDate);
        outputDateMonth = outputFormatMonth.format(inputDate);
        outputDateDay = outputFormatDay.format(inputDate);
      }
    }).toList();
    return "Bạn đã hủy vào $outputDateDay Tháng $outputDateMonth, $outputDateTime";
  } else if (status == 12) {
    listStatusOrder.map((dynamic item) {
      if (item["status"] == 12) {
        time = item["time"];
        var inputDate = inputFormat.parse(time); //
        outputDateTime = outputFormatTime.format(inputDate);
        outputDateMonth = outputFormatMonth.format(inputDate);
        outputDateDay = outputFormatDay.format(inputDate);
      }
    }).toList();
    return "Tài xế đã hủy vào $outputDateDay Tháng $outputDateMonth, $outputDateTime";
  } else if (status == 13) {
    listStatusOrder.map((dynamic item) {
      if (item["status"] == 13) {
        time = item["time"];

        var inputDate = inputFormat.parse(time); //
        outputDateTime = outputFormatTime.format(inputDate);
        outputDateMonth = outputFormatMonth.format(inputDate);
        outputDateDay = outputFormatDay.format(inputDate);
      }
    }).toList();
    return "Khách hàng đã hủy vào $outputDateDay Tháng $outputDateMonth, $outputDateTime";
  } else {
    if (modeId == "1") {
      var inputFormat = DateFormat('yyyy-MM-ddTHH:mm:ss');
      var inputDate = inputFormat.parse(timeOrder);

      var startTime = inputDate.add(const Duration(seconds: 900));
      var endTime = inputDate.add(const Duration(seconds: 1800));
      var outputFormatStart = DateFormat('HH:mm');
      var outputDateStart = outputFormatStart.format(startTime);
      var outputFormatEnd = DateFormat('HH:mm');
      var outputDateEnd = outputFormatEnd.format(endTime);
      return "Tài xế sẽ đến vào $outputDateStart - $outputDateEnd";
    } else if (modeId == "2") {
      return "Tài xế sẽ đến vào $fromHour - $toHour";
    } else if (modeId == "3") {
      var inputFormat = DateFormat('yyyy-MM-dd');
      var inputDate = inputFormat.parse(dayFilter);
      var outputFormat = DateFormat('dd/MM/yyyy');
      var outputDate = outputFormat.format(inputDate);
      return "${fromHour + " - " + toHour}, $outputDate";
    } else {
      return "";
    }
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

// String getTime(String time) {
//   var result = "";
//   var day = time.toString().split(" ")[0];
//   if (day != null) {
//     result =
//         "${time.toString().split(" ")[1]}, ${day.toString().split("/")[2]} thg ${day.toString().split("/")[1]}";
//   } else {
//     result = time;
//   }

//   return result;
// }
