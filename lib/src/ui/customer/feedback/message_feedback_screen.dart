import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twsl_flutter/src/model/base_constants.dart';
import 'package:twsl_flutter/src/model/utils/extensions.dart';
import 'package:twsl_flutter/src/ui/base_widgets.dart';
import 'package:twsl_flutter/src/ui/customer/feedback/feedback_model.dart';
import 'package:twsl_flutter/src/ui/ui_utils.dart';

class MessageFeedbackScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var model = Provider.of<FeedbackModel>(context, listen: false);
    model.statusResultController.stream.listen((event) {
      if (event.isSuccessful) {
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.TYPE_TRACK, (route) => false);
      } else {
        showToast(event.message!);
      }
    });
    return Directionality(
      textDirection: getTextDirection(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            model.issue!.localize(context),
            style: TextStyle(color: "454F63".getColor()),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              padding: EdgeInsets.fromLTRB(16, 30, 16, 40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  text14And500("Trip id #1Q2W3E"),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: model.feedbackEdCon,
                    minLines: 7,
                    maxLines: 10,
                    maxLength: 500,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      hintText: "Type here your issues".localize(context),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      errorMaxLines: 3,
                    ),
                  ),
                  const SizedBox(height: 30),
                  StreamBuilder(
                    stream: model.isShowProgressController.stream,
                    initialData: true,
                    builder: (context, data) {
                      return buttonSolid(
                        context,
                        68,
                        "Submit",
                        () {
                          if (model.feedbackEdCon.text.length > 20) {
                            model.report();
                          } else {
                            showToast("Minimal message is 20 letters.");
                          }
                        },
                        paddingBottom: 0,
                        isProgress: data.data as bool,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
