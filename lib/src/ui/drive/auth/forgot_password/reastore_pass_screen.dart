import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:twsl_flutter/src/model/base_constants.dart';
import 'package:twsl_flutter/src/model/utils/extensions.dart';
import 'package:twsl_flutter/src/model/utils/validators.dart';
import 'package:twsl_flutter/src/ui/base_widgets.dart';
import 'package:twsl_flutter/src/ui/drive/auth/forgot_password/restore_pass_model.dart';
import 'package:twsl_flutter/src/ui/ui_utils.dart';

class RestorePassScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => RestorePassModel(Provider.of(context, listen: false)),
        builder: (context, data) {
          var model = Provider.of<RestorePassModel>(context, listen: false);
          model.statusGetSmsController.stream.listen((event) {
            if (model.isProgress) {
              if (event.isSuccessful) {
                Navigator.pushNamed(
                  context,
                  Routes.VERIFICATION,
                  arguments: {'address': model.mobilePhoneEdCon.text},
                ).then((value) {
                  if (value != null) {
                    Navigator.pushNamed(
                      context,
                      Routes.ENTER_NEW_PASS,
                      arguments: {
                        "resetToken": value,
                        "phone": model.mobilePhoneEdCon.text,
                      },
                    );
                  }
                });
              } else {
                showToast(event.message!);
              }
              model.isProgress = false;
            }
          });
          return Directionality(
            textDirection: getTextDirection(context),
            child: Scaffold(
              appBar: AppBar(),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    screenTitle(
                      FlutterI18n.translate(context, "Forgot"),
                      FlutterI18n.translate(context, "Password"),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                      child: simpleGreyText(
                        FlutterI18n.translate(context,
                            "Enter the phone number and we will send you a code to reset your password"),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 30),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            baseTextField(
                              model.mobilePhoneEdCon,
                              40,
                              0,
                              "Phone Number".localize(context),
                              inputType: TextInputType.phone,
                              // inputFormatter: [
                              //   FilteringTextInputFormatter.allow(
                              //     RegExp("^\\+\\d{0,15}\$"),
                              //   ),
                              // ],
                            ),
                            showProgressOrWidget(
                              buttonSolid(context, 68, "Send", () {
                                model.getSms();
                              }),
                              model.isShowProgressController.stream,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
