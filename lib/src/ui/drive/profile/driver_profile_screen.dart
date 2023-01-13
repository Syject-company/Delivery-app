import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:twsl_flutter/src/model/base_constants.dart';
import 'package:twsl_flutter/src/model/utils/extensions.dart';
import 'package:twsl_flutter/src/ui/base_widgets.dart';
import 'package:twsl_flutter/src/ui/drive/auth/user_model.dart';
import 'package:twsl_flutter/src/ui/ui_utils.dart';

class DriverProfileScreen extends StatefulWidget {
  @override
  _DriverProfileScreen createState() => _DriverProfileScreen();
}

class _DriverProfileScreen extends State<DriverProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: getTextDirection(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "My Profile".localize(context),
            style: TextStyle(color: "454F63".getColor()),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
                child: Consumer<UserModel>(
                  builder: (context, data, _) {
                    var img = data.driver.value?.photoUri;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: (img == null
                              ? AssetImage("assets/images/empty_profile.png")
                              : NetworkImage(img)) as ImageProvider<Object>?,
                          radius: 32,
                        ),
                        CupertinoSwitch(
                          value: data.driver.value?.isActive ?? false,
                          onChanged: (value) {
                            data.turnActiveUser(value);
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 20, 30, 30),
                child: Text(
                  "Barabakhov Vasiliy",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: "454F63".getColor(),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 26),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      item("Trip History".localize(context),
                          "assets/icons/clock.svg", "FFF3E1".getColor(), () {
                        Navigator.pushNamed(context, Routes.TRIP_HISTORY);
                      }),
                      item(
                          "Payment History".localize(context),
                          "assets/icons/credit_card.svg",
                          "EEE8FF".getColor(), () {
                        Navigator.pushNamed(context, Routes.PAYMENT_HISTORY);
                      }),
                      item(
                        "Edit Profile".localize(context),
                        "assets/icons/person.svg",
                        "FEEBDD".getColor(),
                        () {
                          Navigator.pushNamed(
                              context, Routes.EDIT_DRIVER_PROFILE);
                        },
                      ),
                      item(
                          "Change Number".localize(context),
                          "assets/icons/smartphone.svg",
                          "E4ECFF".getColor(), () {
                        Navigator.pushNamed(context, Routes.CHANGE_PHONE);
                      }),
                      item("Change Password".localize(context),
                          "assets/icons/lock.svg", "FFF3E1".getColor(), () {
                        Navigator.pushNamed(context, Routes.CHANGE_PASS);
                      }),
                      item(
                          "Switch to Arabic".localize(context),
                          "assets/icons/message_circle.svg",
                          "EEE8FF".getColor(), () {
                        var newLang = isRtlLanguage(context) ? "en" : "ar";
                        FlutterI18n.refresh(context, Locale(newLang))
                            .then((value) {
                          setState(() {});
                        });
                      }),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return cupertinoCancelingDialog(context);
                            }).then((value) {
                          if (value == true) {
                            Provider.of<UserModel>(context, listen: false)
                                .logout(context);
                          }
                        });
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 13, vertical: 9),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: "FFEDED".getColor(),
                            ),
                            child: SvgPicture.asset("assets/icons/logout.svg"),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            "Log Out".localize(context),
                            style: TextStyle(
                                fontSize: 16, color: "EB5757".getColor()),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget item(String text, String icon, Color background, Function fun) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextButton(
        // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        style: TextButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: fun as void Function()?,
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: background,
              ),
              child: SvgPicture.asset(icon),
            ),
            const SizedBox(width: 20),
            Text(
              text,
              style: TextStyle(fontSize: 16, color: "454F63".getColor()),
            ),
          ],
        ),
      ),
    );
  }
}
