import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twsl_flutter/src/model/utils/extensions.dart';
import 'package:twsl_flutter/src/ui/base_widgets.dart';
import 'package:twsl_flutter/src/ui/custom/verification_code_widget.dart';
import 'package:twsl_flutter/src/ui/drive/profile/change_phone/change_phone_model.dart';
import 'package:twsl_flutter/src/ui/ui_utils.dart';

class ChangePhoneScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChangePhoneModel(Provider.of(context)),
      builder: (context, _) {
        var model = Provider.of<ChangePhoneModel>(context, listen: false);

        model.resultStatusController.stream.listen((event) {
          if (model.isProgress) {
            if (event.isSuccessful) {
              if (model.isConrmationProcess) {
                Navigator.pop(context);
                Navigator.pop(context);
              }
              showDialog(
                context: context,
                builder: (_) => BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: VerificationCodeWidget(
                      titleText:
                          "Please enter the code we sent to you at ${model.phoneEdCon.text}"
                              .localize(context),
                      buttonText: "Continue".localize(context),
                      isShowProgressStream:
                          model.isShowProgressController.stream,
                      submitCallback: (code) {
                        model.confirm(code);
                      },
                      resetCodeCallback: () {
                        model.changePhoneNumber();
                      },
                    ),
                  ),
                ),
              );
            } else {
              showToast(event.message!);
            }
            model.isProgress = false;
            model.isConrmationProcess = false;
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
                    "Change phone".localize(context),
                    "number".localize(context),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                    child: simpleGreyText(
                      "For changing your phone number type password & new phone number"
                          .localize(context),
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
                            model.passEdCon,
                            40,
                            0,
                            "Type password".localize(context),
                            isPass: true,
                          ),
                          baseTextField(
                            model.phoneEdCon,
                            24,
                            0,
                            "New Phone Number".localize(context),
                          ),
                          showProgressOrWidget(
                            buttonSolid(context, 68, "Next", () {
                              model.changePhoneNumber();
                            }),
                            model.isShowProgressController.stream,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
