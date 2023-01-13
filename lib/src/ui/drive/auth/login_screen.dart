import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twsl_flutter/src/model/base_constants.dart';
import 'package:twsl_flutter/src/model/utils/extensions.dart';
import 'package:twsl_flutter/src/ui/base_widgets.dart';
import 'package:twsl_flutter/src/ui/drive/auth/login_model.dart';
import 'package:twsl_flutter/src/ui/ui_utils.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginModel(
        Provider.of(context, listen: false),
        Provider.of(context, listen: false),
        Provider.of(context, listen: false),
      ),
      builder: (context, data) {
        var model = Provider.of<LoginModel>(context);
        model.statusController.stream.listen((event) {
          if (model.isProgress) {
            if (event.isSuccessful) {
              Navigator.pushNamedAndRemoveUntil(
                  context, Routes.DRIVER_HOME, (route) => false);
            } else {
              if (event.rawCode == 403) {
                showToast("You need to verify your account".localize(context));
                Navigator.pushNamed(
                  context,
                  Routes.VERIFICATION,
                  arguments: {
                    "address": model.loginEdCon.text,
                    "wayVerification": model.loginEdCon.text.contains("@")
                        ? WayToVerification.email
                        : WayToVerification.phone,
                  },
                ).then((value) {
                  if (value != null) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, Routes.DRIVER_HOME, (route) => false);
                  }
                });
              } else {
                showToast(event.message!);
              }
            }
          }
        });
        return Directionality(
          textDirection: getTextDirection(context),
          child: Scaffold(
            appBar: AppBar(),
            body: LayoutBuilder(
              builder:
                  (BuildContext context, BoxConstraints viewportConstraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: viewportConstraints.maxHeight,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        screenTitle(
                          "Let’s Start with".localize(context),
                          "Login".localize(context),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 16, right: 16, top: 30),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                baseTextField(model.loginEdCon, 40, 0,
                                    "Email or Phone".localize(context)),
                                baseTextField(model.passEdCon, 24, 0,
                                    "Password".localize(context),
                                    isPass: true),
                                Padding(
                                  padding: EdgeInsets.only(top: 30),
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, Routes.FORGOT_PASS);
                                      },
                                      child: Text(
                                          "Forgot password?".localize(context)),
                                    ),
                                  ),
                                ),
                                StreamBuilder<bool>(
                                  stream: model.isProgressController.stream,
                                  builder: (ctx, data) {
                                    print(data.data);
                                    if (data.data != true) {
                                      return buttonSolid(context, 69, "Login",
                                          () {
                                        model.login();
                                      });
                                    } else {
                                      return Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 54, 0, 40),
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
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                          child: Container(
                            alignment: Alignment.bottomCenter,
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
                                  "Don’t have an account?",
                                  "Register",
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushNamed(
                                          context, Routes.REGISTRATION);
                                    },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
