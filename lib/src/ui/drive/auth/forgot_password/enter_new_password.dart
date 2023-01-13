import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:twsl_flutter/src/model/base_constants.dart';
import 'package:twsl_flutter/src/model/utils/extensions.dart';
import 'package:twsl_flutter/src/model/utils/validators.dart';
import 'package:twsl_flutter/src/ui/base_widgets.dart';
import 'package:twsl_flutter/src/ui/drive/auth/forgot_password/enter_new_pass_model.dart';
import 'package:twsl_flutter/src/ui/ui_utils.dart';

class EnterNewPassword extends StatelessWidget {
  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>;
    var model = Provider.of<EnterNewPassModel>(context, listen: false);
    model.resetToken = args['resetToken'];
    model.phone = args['phone'];

    model.statusController.stream.listen((event) {
      if (model.isProgress) {
        if (event.isSuccessful) {
          Navigator.of(context, rootNavigator: true).popUntil(
            ModalRoute.withName(Routes.DRIVER_AUTH),
          );
        } else {
          showToast(event.message!);
        }
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
                FlutterI18n.translate(context, "Reset your"),
                FlutterI18n.translate(context, "Password"),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                child: simpleGreyText(
                  FlutterI18n.translate(context,
                      "Just type here your new password and good to go"),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 30),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Form(
                    key: _key,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        baseTextField(
                          model.newPassEdCon,
                          40,
                          0,
                          "New Password".localize(context),
                          isPass: true,
                          validator: (value) {
                            Validator.pass(value);
                          },
                        ),
                        baseTextField(
                          model.confirmPassEdCon,
                          24,
                          0,
                          "Confirm new Password".localize(context),
                          isPass: true,
                          validator: (value) {
                            Validator.pass(value);
                          },
                        ),
                        showProgressOrWidget(
                          buttonSolid(context, 68, "Reset", () {
                            FormState state = _key.currentState as FormState;
                            if (state.validate()) {
                              model.changePass();
                            }
                          }),
                          model.isShowProgress.stream,
                        )
                      ],
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
}
