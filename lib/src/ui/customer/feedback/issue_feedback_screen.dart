import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twsl_flutter/src/model/base_constants.dart';
import 'package:twsl_flutter/src/model/utils/extensions.dart';
import 'package:twsl_flutter/src/ui/customer/feedback/feedback_model.dart';
import 'package:twsl_flutter/src/ui/ui_utils.dart';

class IssueFeedbackScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: getTextDirection(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Report Issues?".localize(context),
            style: TextStyle(color: "454F63".getColor()),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                button(context, "My order was unprofessional"),
                Divider(height: 1),
                button(context, "It’s look too much time"),
                Divider(height: 1),
                button(context, "Issues unknown"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget button(BuildContext context, String text) {
    var model = Provider.of<FeedbackModel>(context, listen: false);
    return TextButton(
      onPressed: () {
        model.issue = text;
        Navigator.pushNamed(context, Routes.MESSAGE_FEEDBACK);
      },
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Align(
        alignment: isRtlLanguage(context)
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Text(
          text.localize(context),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
