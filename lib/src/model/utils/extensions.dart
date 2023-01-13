import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:intl/intl.dart';
import 'package:twsl_flutter/src/ui/ui_utils.dart';
import 'package:url_launcher/url_launcher.dart';

extension DateTimeFormat on DateTime {
  String getFormattedDateTime() {
    return DateFormat("MMM dd, hh:mma").format(this);
  }

  String getFormattedDate() {
    return DateFormat("dd MMM").format(this);
  }

  String getFormattedDateForBack() {
    return DateFormat("yyyy-MM-dd").format(this);
  }

  String getFormattedDateTimeWithoutDateToday() {
    var today = DateTime.now();
    if (this.year == today.year &&
        this.month == today.month &&
        this.day == today.day) {
      return DateFormat("hh:mma").format(this);
    } else {
      return DateFormat("MMM dd, hh:mma").format(this);
    }
  }
}

extension StringExtensions on String {
  Color getColor() {
    return getColorFromHex(this);
  }

  String localize(BuildContext context) {
    // if (this == null) {
    //   return null;
    // }
    return FlutterI18n.translate(context, this);
  }

  callingOnPhone() {
    canLaunchUrl(Uri.parse("tel://$this"));
  }
}
