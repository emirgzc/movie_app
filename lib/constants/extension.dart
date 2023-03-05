import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

buildLastProcessCardEffect(Widget widget, BuildContext context) {
  return Shimmer.fromColors(
    baseColor: Colors.grey.withOpacity(0.2),
    highlightColor: Colors.grey.withOpacity(0.05),
    child: widget,
  );
}

  String toRevolveDate(String dateTime) {
    dateTime = dateTime.split(" ")[0];
    var splitList = dateTime.split('-');
    if (splitList.length <= 1) return '---';
    String month = splitList[1];
    String changeMonth = "";
    String date = "";
    switch (month) {
      case "01":
        changeMonth = "Ocak";
        break;
      case "02":
        changeMonth = "Şubat";
        break;
      case "03":
        changeMonth = "Mart";
        break;
      case "04":
        changeMonth = "Nisan";
        break;
      case "05":
        changeMonth = "Mayıs";
        break;
      case "06":
        changeMonth = "Haziran";
        break;
      case "07":
        changeMonth = "Temmuz";
        break;
      case "08":
        changeMonth = "Ağustos";
        break;
      case "09":
        changeMonth = "Eylül";
        break;
      case "10":
        changeMonth = "Ekim";
        break;
      case "11":
        changeMonth = "Kasım";
        break;
      case "12":
        changeMonth = "Aralık";
        break;
      default:
    }
    if (splitList[2][0].contains("0")) {
      date = splitList[2][1];
    } else {
      date = splitList[2];
    }
    //date = dateTime.split("-")[2];

    return "$date $changeMonth ${splitList[0]}";
  }

