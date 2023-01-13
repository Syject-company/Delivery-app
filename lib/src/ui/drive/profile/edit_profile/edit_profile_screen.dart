import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:twsl_flutter/src/model/base_constants.dart';
import 'package:twsl_flutter/src/model/utils/extensions.dart';
import 'package:twsl_flutter/src/model/utils/validators.dart';
import 'package:twsl_flutter/src/ui/base_widgets.dart';
import 'package:twsl_flutter/src/ui/drive/auth/user_model.dart';
import 'package:twsl_flutter/src/ui/drive/profile/edit_profile/edit_profile_model.dart';
import 'package:twsl_flutter/src/ui/ui_utils.dart';

class EditDriverProfileScreen extends StatefulWidget {
  @override
  _EditDriverProfileScreen createState() => _EditDriverProfileScreen();
}

class _EditDriverProfileScreen extends State<EditDriverProfileScreen> {
  GlobalKey _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditDriverProfileModel(Provider.of(context)),
      builder: (context, _) {
        var model = Provider.of<EditDriverProfileModel>(context, listen: false);
        model.setProfile(
            Provider.of<UserModel>(context, listen: false).driver.value);
        model.statusController.stream.listen((event) {
          if (model.isProgress) {
            if (event.isSuccessful) {
              showToast("Profile updated successfully!");
            } else {
              showToast(event.message!);
            }
          }
        });
        return Directionality(
          textDirection: getTextDirection(context),
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                "Edit Profile".localize(context),
                style: TextStyle(color: "454F63".getColor()),
              ),
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _key,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Consumer<EditDriverProfileModel>(
                              builder: (context, data, _) {
                            return profileCover(
                              data.photo,
                              64,
                              () {
                                Navigator.pushNamed(context, Routes.CAMERA)
                                    .then((value) {
                                  if (value != null) {
                                    model.photo = value as File?;
                                    setState(() {});
                                  }
                                });
                              },
                              photoUri: data.lastPhoto,
                            );
                          }),
                          Padding(
                            padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                            child: StreamBuilder<bool>(
                              stream: model.isShowProgress.stream,
                              builder: (ctx, data) {
                                print(data.data);
                                if (data.data != true) {
                                  return Container(
                                    constraints: BoxConstraints(
                                      minWidth: 144,
                                    ),
                                    height: 48,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: "BD2755".getColor(),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: () {
                                        FormState state =
                                            _key.currentState as FormState;
                                        if (state.validate()) {
                                          model.upgradeProfile();
                                        }
                                      },
                                      child: Text("Update".localize(context)),
                                    ),
                                  );
                                } else {
                                  return Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 72, 0),
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 30, top: 10, right: 30),
                      child: Text(
                        "User Information".localize(context),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: "B4BBCA".getColor(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            baseTextField(
                              model.nameEdCon,
                              40,
                              0,
                              "Name".localize(context),
                              validator: (value) {
                                return Validator.notEmpty(value);
                              },
                            ),
                            baseTextField(
                              model.emailEdCon,
                              24,
                              0,
                              "Email".localize(context),
                              validator: (value) {
                                return Validator.email(value);
                              },
                            ),
                            Consumer<EditDriverProfileModel>(
                              builder: (ctx, data, _) {
                                return formDropDown(
                                    model.citiesStatusController.stream,
                                    model.cities,
                                    "City".localize(context),
                                    (value) {
                                      if (value != null) {
                                        model.city = value;
                                      } else {
                                        model.getCities();
                                      }
                                    },
                                    FlutterI18n.currentLocale(context)
                                        .toString(),
                                    value: model.city,
                                    validator: (value) {
                                      return Validator.notEmpty(value.cityName);
                                    });
                              },
                            ),
                            baseTextField(
                              model.postalCodeEdCon,
                              24,
                              0,
                              "Postal code".localize(context),
                              validator: (value) {
                                return Validator.notEmpty(value);
                              },
                            ),
                            baseTextField(
                              model.addressEdCon,
                              24,
                              40,
                              "Address".localize(context),
                              validator: (value) {
                                return Validator.notEmpty(value);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 30, right: 30, top: 30),
                      child: Text(
                        "Other Information".localize(context),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: "B4BBCA".getColor(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16, right: 16, top: 10, bottom: 65),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            baseTextField(model.iqmaEdCon, 40, 0,
                                "IQMA/National ID".localize(context)),
                            baseTextField(
                              model.vehicalNumberEdCon,
                              24,
                              0,
                              "Vehicle Plate Number".localize(context),
                              validator: (value) {
                                return Validator.notEmpty(value);
                              },
                            ),
                            baseTextField(
                              model.vehicalModelEdCon,
                              24,
                              0,
                              "Vehicle Model".localize(context),
                              validator: (value) {
                                return Validator.notEmpty(value);
                              },
                            ),
                            baseTextField(
                              model.ibanNumberEdCon,
                              24,
                              40,
                              "IBEN Number".localize(context),
                              validator: (value) {
                                return Validator.notEmpty(value);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  showMessage(Stream<String> message) {
    message.listen((event) {
      showToast(event);
    });
  }
}
