import 'package:easy_localization/easy_localization.dart';
import 'package:movie_app/translations/locale_keys.g.dart';

String toRevolveDate(String dateTime) {
  dateTime = dateTime.split(" ")[0];
  var splitList = dateTime.split('-');
  if (splitList.length <= 1) return '---';
  String month = splitList[1];
  String changeMonth = "";
  String date = "";
  switch (month) {
    case "01":
      changeMonth = LocaleKeys.january.tr();
      break;
    case "02":
      changeMonth = LocaleKeys.february.tr();
      break;
    case "03":
      changeMonth = LocaleKeys.march.tr();
      break;
    case "04":
      changeMonth = LocaleKeys.april.tr();
      break;
    case "05":
      changeMonth = LocaleKeys.may.tr();
      break;
    case "06":
      changeMonth = LocaleKeys.june.tr();
      break;
    case "07":
      changeMonth = LocaleKeys.july.tr();
      break;
    case "08":
      changeMonth = LocaleKeys.august.tr();
      break;
    case "09":
      changeMonth = LocaleKeys.september.tr();
      break;
    case "10":
      changeMonth = LocaleKeys.october.tr();
      break;
    case "11":
      changeMonth = LocaleKeys.november.tr();
      break;
    case "12":
      changeMonth = LocaleKeys.december.tr();
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