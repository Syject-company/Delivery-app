import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart' as intl;

Color getColorFromHex(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll('#', '');

  if (hexColor.length == 6) {
    hexColor = 'FF' + hexColor;
  }

  return Color(int.parse(hexColor, radix: 16));
}

String printDuration(Duration duration) {
  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}

void showToast(String msg) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: const Color(0xFFBC2954),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

Offset getViewParams(GlobalKey key) {
  return (key.currentContext!.findRenderObject() as RenderBox)
      .localToGlobal(Offset.zero);
}

String dateTimeFormat(BuildContext context, DateTime dateTime) {
  return intl.DateFormat(
          "dd-MM-yyyy HH:mm", Localizations.localeOf(context).languageCode)
      .format(dateTime);
}

LinearGradient getAppGradient() {
  return LinearGradient(colors: [
    getColorFromHex("FDBE01"),
    getColorFromHex("FC7F01"),
  ], begin: Alignment.topLeft, end: Alignment.bottomRight);
}

TextDirection getTextDirection(BuildContext context) {
  switch (FlutterI18n.currentLocale(context)!.languageCode) {
    case "ar":
      return TextDirection.rtl;
    default:
      return TextDirection.ltr;
  }
}

bool isRtlLanguage(BuildContext context) {
  return getTextDirection(context) == TextDirection.rtl;
}
