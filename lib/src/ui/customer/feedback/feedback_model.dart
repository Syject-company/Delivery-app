import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:twsl_flutter/src/model/models/report.dart';
import 'package:twsl_flutter/src/model/preferences/preferences.dart';
import 'package:twsl_flutter/src/model/repository/repository.dart';
import 'package:twsl_flutter/src/model/web_apis/result.dart';

class FeedbackModel extends ChangeNotifier {
  final Repository? _repository;
  final Preferences? _prefs;

  var feedbackEdCon = TextEditingController();
  String? issue;

  var isProgress = false;
  StreamController<bool> isShowProgressController = BehaviorSubject();
  StreamController<ResultStatus> statusResultController = BehaviorSubject();

  FeedbackModel(this._repository, this._prefs);

  report() async {
    isProgress = true;
    isShowProgressController.sink.add(true);
    _repository!.orderReport(
        Report.all(issue, feedbackEdCon.text, await _prefs!.getTrackId()),
        (status) {
      statusResultController.sink.add(status);
      isShowProgressController.sink.add(false);
    });
  }

  @override
  void dispose() {
    feedbackEdCon.dispose();
    isShowProgressController.close();
    statusResultController.close();
    super.dispose();
  }
}
