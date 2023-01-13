import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twsl_flutter/src/model/utils/extensions.dart';
import 'package:twsl_flutter/src/ui/base_widgets.dart';
import 'package:twsl_flutter/src/ui/custom/input_validator_code.dart';
import 'package:twsl_flutter/src/ui/drive/auth/verification_code_model.dart';
import 'package:twsl_flutter/src/ui/ui_utils.dart';

class VerificationCodeScreen extends StatefulWidget {
  @override
  _VerificationCodeScreen createState() => _VerificationCodeScreen();
}

class _VerificationCodeScreen extends State<VerificationCodeScreen> {
  @override
  Widget build(BuildContext context) {
    Map args =
        ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>;
    var model = Provider.of<VerificationCodeModel>(context, listen: false);
    model.address = args['address'];
    if (args.containsKey("wayVerification")) {
      model.wayToVerification = args["wayVerification"];
      model.sendCodeConfirmAccount();
    }

    InputValidatorCode inputValidatorCode = InputValidatorCode();

    model.statusController.stream.listen((event) {
      if (model.isProgress) {
        if (event.isSuccessful) {
          Navigator.pop(context, model.token);
        } else {
          showToast(event.message!);
        }
        model.isProgress = false;
      }
    });

    model.closeTimer();
    model.startTimer();
    return Directionality(
      textDirection: getTextDirection(context),
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              screenTitle(
                "Enter Your".localize(context),
                "Code".localize(context),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                child: simpleGreyText(
                  "Please enter the code we sent to you at ".localize(context) +
                      model.address!,
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
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: inputValidatorCode,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 30, 16, 0),
                        child: Center(
                          child: StreamBuilder(
                              stream: model.timerStream.stream,
                              builder: (ctx, data) {
                                return _textWithTimerOnNot(
                                  context,
                                  data.data as int,
                                  model,
                                );
                              }),
                        ),
                      ),
                      showProgressOrWidget(
                        buttonSolid(context, 30, "Continue", () {
                          if (inputValidatorCode.getCode().length == 4) {
                            if (model.wayToVerification == null) {
                              model.verificationCode(
                                inputValidatorCode.getCode(),
                              );
                            } else {
                              model.confirmAccount(
                                inputValidatorCode.getCode(),
                              );
                            }
                          } else {
                            showToast("Code is not valid".localize(context));
                          }
                        }),
                        model.isShowProgress.stream,
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
  }

  Widget _textWithTimerOnNot(
      BuildContext context, int? time, VerificationCodeModel model) {
    print("Time = $time");
    if (time != 0) {
      return textWithClickableTextAndMutable(
        context,
        "Resend code in",
        (time ?? 60).toString(),
        "Seconds",
        TapGestureRecognizer()
          ..onTap = () {
            showToast("We need to wait a little longer".localize(context));
          },
      );
    } else {
      return textWithClickableText(
        context,
        "Didn’t receive yet?",
        "Send again",
        TapGestureRecognizer()
          ..onTap = () {
            showToast("Reset code".localize(context));
            if (model.wayToVerification == null) {
              model.sendCode();
            } else {
              model.sendCodeConfirmAccount();
            }
            // ignore: todo
            model.resetTimer(); //TODO reset timer after successful request
          },
      );
    }
  }
}
