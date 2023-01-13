import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:twsl_flutter/src/model/base_constants.dart';
import 'package:twsl_flutter/src/model/utils/extensions.dart';
import 'package:twsl_flutter/src/ui/splash/splash_model.dart';
import 'package:twsl_flutter/src/ui/ui_utils.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SplashModel>(builder: (ctx, model, _) {
        print("Current locale = ${FlutterI18n.currentLocale(context)}");
        print("new locale = ${model.appLanguage}");
        // if (model.appLanguage != null &&
        //     Locale(model.appLanguage as String) !=
        //         FlutterI18n.currentLocale(context)) {
        //   print("Change locale");
        //   FlutterI18n.refresh(context, Locale(model.appLanguage as String))
        //       .then((value) {
        //     setState(() {});
        //   });
        // }
        model.addListener(() async {
          log('${model.isAuth}');
          if (model.isAuth == true) {
            await Navigator.pushNamedAndRemoveUntil(
                context, Routes.DRIVER_HOME, (route) => false);
          }
        });
        if (model.isAuth == null) {
          return Container(
            constraints: BoxConstraints.expand(),
            color: "BC2954".getColor(),
            child: Image.asset("assets/images/im_splash.png"),
          );
        } else {
          return _selectTypeApp(context, model);
        }
      }),
    );
  }

  Widget _selectTypeApp(BuildContext context, SplashModel model) {
    return Container(
      color: "FFCE06".getColor(),
      constraints: BoxConstraints.expand(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 64),

            // child: CustomSwitch(
            //   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //   value: model.appLanguage == "en",
            //   trackHeight: 31,
            //   trackWidth: 64,
            //   thumbRadius: 14,
            //   trueText: "EN",
            //   falseText: "AR",
            //   onChanged: (value) {
            //     print(value);
            //     var lang = value ? "en" : "ar";
            //     print(lang);
            //     model.appLanguage = lang;
            //     model.saveAppLanguage(lang);
            //     setState(() {});
            //   },
            //   activeThumbImage: AssetImage("assets/images/im_england.png"),
            //   inactiveThumbImage: AssetImage("assets/images/arabia.png"),
            //   activeTrackColor: Colors.white24,
            //   inactiveTrackColor: Colors.white24,
            // ),
          ),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Center(
                child: Padding(
                  child: Image.asset("assets/images/im_bags.png"),
                  padding: EdgeInsets.only(bottom: 26),
                ),
              ),
              _buttonsTypeApp(context),
            ],
          ),
          const SizedBox(),
        ],
      ),
    );
  }

  Widget _buttonsTypeApp(BuildContext context) {
    return Column(
      children: [
        _button(context, "assets/icons/ic_user.svg",
            "Customer login to approve and track shipment", () {
          Navigator.pushNamed(context, Routes.TYPE_TRACK);
        }),
        Padding(
          padding: EdgeInsets.only(top: 24),
          child: _button(
              context, "assets/icons/ic_truck.svg", "Driver login/sign up", () {
            Navigator.pushNamed(context, Routes.DRIVER_AUTH);
          }),
        ),
      ],
    );
  }

  Widget _button(
      BuildContext context, String imAssetName, String text, VoidCallback fun) {
    return TextButton(
      onPressed: fun,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Container(
              height: 64,
              width: 64,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: getColorFromHex("BC2954"),
              ),
              child: SvgPicture.asset(imAssetName),
            ),
          ),
          Flexible(child: Text(text.localize(context), maxLines: 2)),
        ],
      ),
    );
  }
}
