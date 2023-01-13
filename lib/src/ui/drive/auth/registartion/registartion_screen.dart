import 'dart:io';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:twsl_flutter/src/model/base_constants.dart';
import 'package:twsl_flutter/src/model/utils/extensions.dart';
import 'package:twsl_flutter/src/model/utils/validators.dart';
import 'package:twsl_flutter/src/ui/base_widgets.dart';
import 'package:twsl_flutter/src/ui/drive/auth/registartion/registration_model.dart';
import 'package:twsl_flutter/src/ui/ui_utils.dart';

class RegistrationScreen extends StatefulWidget {
  RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreen createState() => _RegistrationScreen();
}

class _RegistrationScreen extends State<RegistrationScreen> {
  GlobalKey _key1 = GlobalKey<FormState>();
  GlobalKey _key2 = GlobalKey<FormState>();

  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegistrationModel(
        Provider.of(context),
        Provider.of(context),
      ),
      builder: (context, _) {
        var model = Provider.of<RegistrationModel>(context, listen: false);
        var dialog = wayVerificationDialog(context, model);

        model.statusController.stream.listen((event) {
          if (model.isProgress) {
            if (event.isSuccessful) {
              showDialog(context: context, builder: (context) => dialog)
                  .then((value) {
                if (value == true) {
                  Navigator.pushNamed(
                    context,
                    Routes.VERIFICATION,
                    arguments: {
                      "address":
                          model.wayToVerification == WayToVerification.email
                              ? model.emailEdCon.text
                              : model.contactNumberEdCon.text,
                      "wayVerification": model.wayToVerification,
                    },
                  ).then((value) {
                    print("Value = $value");
                    if (value != null) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, Routes.DRIVER_HOME, (route) => false);
                    }
                  });
                }
              });
            } else {
              showToast(event.message!);
            }
            model.isProgress = false;
          }
        });

        return WillPopScope(
          onWillPop: () => onWillPopScope(model),
          child: Directionality(
            textDirection: getTextDirection(context),
            child: Scaffold(
              appBar: AppBar(),
              body: PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  firstScreen(context, model),
                  secondScreen(context, model),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool> onWillPopScope(RegistrationModel model) async {
    if (model.screenNumber == 1) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 200),
        curve: Curves.linear,
      );
      model.screenNumber = 0;
      return false;
    } else {
      return true;
    }
  }

  Widget firstScreen(BuildContext context, RegistrationModel model) {
    print("Redraw");
    return SingleChildScrollView(
      child: Column(
        children: [
          screenTitle(
            "Let’s Start with".localize(context),
            "Register".localize(context),
          ),
          Padding(
              padding: EdgeInsets.only(top: 6),
              child: Center(
                  child: profileCover(model.photo, 80, () {
                Navigator.pushNamed(context, Routes.CAMERA).then((value) {
                  if (value != null) {
                    setState(() {
                      model.photo = value as File?;
                    });
                  }
                });
              }))),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Form(
                key: _key1,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    baseTextField(
                      model.nameEdCon,
                      40,
                      0,
                      "Name".localize(context),
                    ),
                    baseTextField(model.contactNumberEdCon, 24, 0,
                        "Contact Number".localize(context),
                        inputType: TextInputType.phone, validator: (value) {
                      return Validator.phone(value)?.localize(context);
                    }),
                    baseTextField(
                        model.emailEdCon, 24, 0, "Email".localize(context),
                        validator: (value) {
                      return Validator.email(value)?.localize(context);
                    }),
                    formDropDown(
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
                      FlutterI18n.currentLocale(context).toString(),
                      validator: (value) {
                        return Validator.notEmpty(value.cityName);
                      },
                      value: model.city,
                    ),
                    baseTextField(model.postalCodeEdCon, 24, 0,
                        "Postal code".localize(context), validator: (value) {
                      return Validator.notEmpty(value)!.localize(context);
                    }),
                    baseTextField(
                        model.addressEdCon, 24, 0, "Address".localize(context),
                        validator: (value) {
                      return Validator.notEmpty(value)!.localize(context);
                    }),
                    baseTextField(
                      model.passEdCon,
                      24,
                      0,
                      "Password".localize(context),
                      isPass: true,
                      validator: (value) {
                        return Validator.pass(value)!.localize(context);
                      },
                    ),
                    baseTextField(model.confPassEdCon, 24, 0,
                        "Confirm Password".localize(context), isPass: true,
                        validator: (value) {
                      return value == model.passEdCon.text
                          ? null
                          : "Passwords do not match".localize(context);
                    }),
                    buttonSolid(context, 26, "Next", () {
                      FormState state = _key1.currentState as FormState;
                      if (state.validate()) {
                        if (model.photo != null) {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.linear,
                          );
                          model.screenNumber = 1;
                        } else {
                          showToast(
                              "You need add profile photo".localize(context));
                        }
                      }
                    }),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 54, 16, 0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  color: Colors.white),
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 28, 0, 48),
                child: Center(
                  child: textWithClickableText(
                    context,
                    "Have an account?",
                    "Login",
                    TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pop(context);
                      },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget secondScreen(BuildContext context, RegistrationModel model) {
    return SingleChildScrollView(
      child: Column(
        children: [
          screenTitle(
            "Let’s Start with".localize(context),
            "Register".localize(context),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 30),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Form(
                key: _key2,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    baseTextField(model.nationalIdEdCon, 40, 0,
                        "IQMA/National ID".localize(context)),
                    baseTextField(model.vehicalPlataNumberedCon, 24, 0,
                        "Vehicle Plate Number".localize(context),
                        validator: (value) {
                      return Validator.notEmpty(value);
                    }),
                    baseTextField(model.vehicalModelEdCon, 24, 0,
                        "Vehicle Model".localize(context), validator: (value) {
                      return Validator.notEmpty(value);
                    }),
                    baseTextField(model.ibanNumberEdCon, 24, 0,
                        "IBEN Number".localize(context), validator: (value) {
                      return Validator.notEmpty(value);
                    }),
                    Padding(
                      padding: EdgeInsets.only(top: 25),
                      child: Row(
                        children: [
                          Checkbox(
                              //TODO fixed by design
                              value: model.isConfirmTerms,
                              onChanged: (value) {
                                model.isConfirmTerms = value;
                                setState(() {});
                              }),
                          textWithClickableText(
                            context,
                            "I agree with",
                            "Terms and Conditions",
                            TapGestureRecognizer()
                              ..onTap = () {
                                showToast("Redirection to Terms");
                              },
                          ),
                        ],
                      ),
                    ),
                    StreamBuilder<bool>(
                      stream: model.isProgressController.stream,
                      builder: (ctx, data) {
                        print(data.data);
                        if (data.data != true) {
                          return buttonSolid(
                            context,
                            54,
                            "Register",
                            () {
                              FormState state = _key2.currentState as FormState;
                              if (state.validate() && model.isConfirmTerms!) {
                                model.registration();
                              }
                            },
                          );
                        } else {
                          return Padding(
                            padding: EdgeInsets.fromLTRB(0, 54, 0, 40),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget wayVerificationDialog(BuildContext context, RegistrationModel model) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      child: Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
                child: Text(
                    "Choose your way to get verification code via:"
                        .localize(context),
                    style: TextStyle(fontSize: 16)),
              ),
              ListTile(
                title: Text("Phone".localize(context)),
                onTap: () {
                  model.wayToVerification = WayToVerification.phone;
                  setState(() {});
                },
                leading: Radio(
                  value: WayToVerification.phone,
                  groupValue: model.wayToVerification,
                  onChanged: (dynamic value) {
                    model.wayToVerification = value;
                    setState(() {});
                  },
                ),
              ),
              ListTile(
                title: Text("Email".localize(context)),
                onTap: () {
                  model.wayToVerification = WayToVerification.email;
                  setState(() {});
                },
                leading: Radio(
                  value: WayToVerification.email,
                  groupValue: model.wayToVerification,
                  onChanged: (dynamic value) {
                    model.wayToVerification = value;
                    setState(() {});
                  },
                ),
              ),
              buttonSolid(context, 36, "Continue", () {
                Navigator.pop(context, true);
              })
            ],
          );
        }),
      ),
    );
  }
}
