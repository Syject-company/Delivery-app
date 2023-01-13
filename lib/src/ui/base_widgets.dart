import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twsl_flutter/src/model/models/users.dart';
import 'package:twsl_flutter/src/model/utils/extensions.dart';
import 'package:twsl_flutter/src/model/web_apis/result.dart';
import 'package:twsl_flutter/src/ui/ui_utils.dart';

Widget baseTextField(
  TextEditingController controller,
  double paddingTop,
  double paddingBottom,
  String hint, {
  TextInputType? inputType,
  List<TextInputFormatter>? inputFormatter,
  bool isPass = false,
  String? prefix,
  Function(String)? validator,
}) {
  return Padding(
    padding: EdgeInsets.fromLTRB(16, paddingTop, 16, paddingBottom),
    child: TextFormField(
      controller: controller,
      keyboardType: inputType,
      inputFormatters: inputFormatter,
      obscureText: isPass,
      enableSuggestions: !isPass,
      autocorrect: !isPass,
      decoration: InputDecoration(
        prefixText: prefix,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        errorMaxLines: 7,
      ),
      // validator: validator,
    ),
  );
}

Widget simpleGreyText(String text) {
  return Text(
    text,
    style: TextStyle(
      fontSize: 16,
      color: getColorFromHex("959DAD"),
    ),
  );
}

Widget screenTitle(String text1, String text2) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          text1,
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
        ),
        Text(
          text2,
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
        ),
      ],
    ),
  );
}

Widget textWithClickableText(BuildContext context, String baseText,
        String clickableText, TapGestureRecognizer recognizer) =>
    textWithClickableTextAndMutable(
        context, baseText, null, clickableText, recognizer);

Widget text14And500(String text) {
  return text14And500WithColor(text, "454F63");
}

Widget text14And500WithColor(String text, String color) {
  return Text(
    text,
    style: TextStyle(fontSize: 14, color: color.getColor()),
  );
}

Widget text14And500WithColorC(String text, Color color) {
  return Text(
    text,
    style: TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.w500),
  );
}

Widget text14And400(String text) => text14And400WithColor(
      text,
      "454F63".getColor(),
    );

Widget text14And400WithColor(String text, Color color) {
  return Text(
    text,
    style: TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.w400),
  );
}

Widget text12And400(String text) {
  return text12And400AndColor(text, "454F63");
}

Widget text12And400AndColor(String text, String color) {
  return Text(
    text,
    style: TextStyle(
      fontSize: 12,
      color: color.getColor(),
      fontWeight: FontWeight.w400,
    ),
  );
}

Widget text14And600WithColor(String text, Color color) {
  return Text(
    text,
    style: TextStyle(
      fontSize: 14,
      color: color,
      fontWeight: FontWeight.w600,
    ),
  );
}

Widget text16w400(
  String text, {
  Color? color,
  TextAlign? align = TextAlign.center,
}) =>
    Text(
      text,
      textAlign: align,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.w400,
        fontSize: 16,
      ),
    );

Widget text16w500(String text, {Color? color}) => Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
    );

Widget text16w800(String text, {Color? color}) => Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.w800,
        fontSize: 16,
      ),
    );

Widget text18w600(String text) => Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: "454F63".getColor(),
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
    );

Widget textWithClickableTextAndMutable(BuildContext context, String baseText,
    String? mutable, String clickableText, TapGestureRecognizer recognizer) {
  var mutableText;
  if (mutable == null) {
    mutableText = " ";
  } else {
    mutableText = " $mutable ";
  }
  return RichText(
    text: TextSpan(
      style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: "959DAD".getColor()),
      children: [
        TextSpan(text: FlutterI18n.translate(context, baseText)),
        TextSpan(
          text: mutableText,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: "454F63".getColor(),
          ),
        ),
        TextSpan(
          text: FlutterI18n.translate(context, clickableText),
          recognizer: recognizer,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: getColorFromHex("454F63"),
          ),
        ),
      ],
    ),
  );
}

Widget buttonSolid(BuildContext context, double paddingTop,
    String labelTranslateKey, Function fun,
    {double paddingBottom = 40,
    double horizontalPadding = 16,
    Color? color,
    bool isProgress = false}) {
  return Padding(
    padding: EdgeInsets.fromLTRB(
      horizontalPadding,
      paddingTop,
      horizontalPadding,
      paddingBottom,
    ),
    child: SizedBox(
      height: 48,
      child: TextButton(
        style: TextButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          foregroundColor: Colors.white,
          backgroundColor: color ?? "BC2954".getColor(),
        ),
        onPressed: fun as void Function()?,
        child: isProgress
            ? CircularProgressIndicator()
            : Text(FlutterI18n.translate(context, labelTranslateKey)),
      ),
    ),
  );
}

Widget formDropDown(Stream<ResultStatus> stream, List<City> cities, String hint,
    Function(City?) fun, String lang,
    {City? value, Function(City)? validator}) {
  return Padding(
    padding: EdgeInsets.fromLTRB(16, 24, 16, 0),
    child: StreamBuilder<ResultStatus>(
        stream: stream,
        builder: (context, data) {
          return FormField<City>(
            // validator: validator as String? Function(City?)?,
            builder: (FormFieldState<City> state) {
              if ((state.value == null) && value != null) {
                // ignore: invalid_use_of_protected_member
                state.setValue(value);
              } else if (state.value != null &&
                  cities.isNotEmpty &&
                  state.value.runtimeType == value.runtimeType) {
                // ignore: invalid_use_of_protected_member
                state.setValue(cities
                    .where((element) => element.id == state.value!.id)
                    .first);
              }
              return InputDecorator(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  hintText: hint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                isEmpty: state.value == null,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<City>(
                    elevation: 0,
                    value: state.value,
                    isExpanded: true,
                    isDense: true,
                    icon: data.data != null
                        ? data.data!.isSuccessful
                            ? SvgPicture.asset("assets/icons/arrow_down.svg")
                            : GestureDetector(
                                onTap: () {
                                  if (!data.data!.isSuccessful) fun.call(null);
                                },
                                child:
                                    SvgPicture.asset("assets/icons/reload.svg"),
                              )
                        : const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                    onChanged: (City? newValue) {
                      fun.call(newValue);
                      // ignore: invalid_use_of_protected_member
                      state.setState(() {
                        state.didChange(newValue);
                      });
                    },
                    items: cities == null
                        ? []
                        : cities.map((City val) {
                            return DropdownMenuItem<City>(
                              value: val,
                              child: Text(
                                lang == "ar" ? val.cityAr! : val.cityEng!,
                              ),
                            );
                          }).toList(),
                  ),
                ),
              );
            },
          );
        }),
  );
}

Widget cupertinoCancelingDialog(BuildContext context) {
  return CupertinoAlertDialog(
    title: new Text(FlutterI18n.translate(context, "Are you sure?")),
    content: new Text(
      FlutterI18n.translate(
        context,
        "By canceling this trip the next nearby driver will get the request",
      ),
    ),
    actions: <Widget>[
      CupertinoDialogAction(
        isDefaultAction: true,
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text("Cancel"),
      ),
      CupertinoDialogAction(
        onPressed: () {
          Navigator.pop(context, true);
        },
        child: Text("Yes"),
      )
    ],
  );
}

Widget cupertinoConfirmDialog(
  BuildContext context,
  String text,
  Function(bool result) clickCallback,
) {
  return CupertinoAlertDialog(
    title: Text(FlutterI18n.translate(context, "Confirm your delivery")),
    content: Text(
      FlutterI18n.translate(
        context,
        "If you didn’t confirm your delivery it will expire on\n $text",
      ),
    ),
    actions: <Widget>[
      CupertinoDialogAction(
        isDefaultAction: true,
        onPressed: () {
          clickCallback.call(false);
        },
        child: Text("Cancel"),
      ),
      CupertinoDialogAction(
        onPressed: () {
          clickCallback.call(true);
        },
        child: Text(
          "Confirm",
          style: TextStyle(color: "37D09D".getColor()),
        ),
      )
    ],
  );
}

Widget profileCover(File? image, double coverHeight, Function fun,
    {String? photoUri}) {
  return SizedBox(
    height: coverHeight,
    width: coverHeight,
    child: Stack(
      children: [
        SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: SvgPicture.asset("assets/icons/empty_profile_icon.svg"),
        ),
        CircleAvatar(
          backgroundImage: image != null
              ? FileImage(image)
              : (photoUri != null
                      ? NetworkImage(photoUri)
                      : AssetImage("assets/icons/empty_profile_icon.svg"))
                  as ImageProvider<Object>?,
          backgroundColor: Colors.transparent,
          child: const SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: DecoratedBox(
              decoration:
                  BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
            ),
          ),
          radius: coverHeight / 2,
        ),
        Center(
          child: IconButton(
            icon: SvgPicture.asset(
              "assets/icons/ic_add_photo.svg",
              color: Colors.white70,
            ),
            onPressed: fun as void Function()?,
          ),
        ),
      ],
    ),
  );
}

Widget getProgressDialog(BuildContext context) {
  return WillPopScope(
    onWillPop: () async => false,
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      child: Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return CircularProgressIndicator();
        }),
      ),
    ),
  );
}

showProgressOrWidget(
  Widget widget,
  Stream stream, {
  double progressTopPadding = 54,
  double progressBottomPadding = 40,
}) {
  return StreamBuilder<bool>(
    stream: stream as Stream<bool>?,
    builder: (ctx, data) {
      print(data.data);
      if (data.data != true) {
        return widget;
      } else {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            0,
            progressTopPadding,
            0,
            progressBottomPadding,
          ),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    },
  );
}

doneDialog(BuildContext context, Function() buttonClick) {
  return BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
    child: Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 17),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Image.asset("assets/images/successful.png", height: 84),
          ),
          const SizedBox(height: 18),
          text18w600("success".localize(context)),
          const SizedBox(height: 8),
          text16w400("Your delivery is complete ".localize(context)),
          buttonSolid(
            context,
            30,
            "Done".localize(context),
            buttonClick,
            paddingBottom: 30,
          ),
        ],
      ),
    ),
  );
}
