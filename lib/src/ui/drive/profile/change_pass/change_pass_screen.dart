import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twsl_flutter/src/model/utils/extensions.dart';
import 'package:twsl_flutter/src/model/utils/validators.dart';
import 'package:twsl_flutter/src/ui/base_widgets.dart';
import 'package:twsl_flutter/src/ui/drive/profile/change_pass/change_pass_model.dart';
import 'package:twsl_flutter/src/ui/ui_utils.dart';

class ChangePassScreen extends StatelessWidget {
  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChangePassModel(Provider.of(context)),
      builder: (context, _) {
        var model = Provider.of<ChangePassModel>(context, listen: false);

        model.resultStatusController.stream.listen((event) {
          if (model.isProgress) {
            if (event.isSuccessful) {
              Navigator.pop(context);
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
                    "Change your".localize(context),
                    "password".localize(context),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                    child: simpleGreyText(
                      "For changing your password type your old password first"
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
                      child: Form(
                        key: _key,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            baseTextField(
                              model.oldPass,
                              40,
                              0,
                              "Old password".localize(context),
                              isPass: true,
                              validator: (value) {
                                Validator.pass(value);
                              },
                            ),
                            baseTextField(
                              model.newPass,
                              24,
                              0,
                              "New Password".localize(context),
                              isPass: true,
                              validator: (value) {
                                Validator.pass(value);
                              },
                            ),
                            baseTextField(
                              model.confPass,
                              24,
                              0,
                              "Confirm new Password".localize(context),
                              isPass: true,
                              validator: (value) {
                                Validator.pass(value);
                              },
                            ),
                            showProgressOrWidget(
                              buttonSolid(context, 68, "Update", () {
                                FormState state = _key.currentState as FormState;
                                if (state.validate()) {
                                  model.changePass();
                                }
                              }),
                              model.isShowProgressController.stream,
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
      },
    );
  }
}
