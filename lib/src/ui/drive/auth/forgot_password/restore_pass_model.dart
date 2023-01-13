import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:twsl_flutter/src/model/repository/repository.dart';
import 'package:twsl_flutter/src/model/web_apis/result.dart';

class RestorePassModel extends ChangeNotifier {
  final Repository _repository;

  var mobilePhoneEdCon = TextEditingController();

  String? resetToken;

  var isProgress = false;

  StreamController<bool> isShowProgressController = BehaviorSubject();
  StreamController<ResultStatus> statusGetSmsController = BehaviorSubject();

  RestorePassModel(this._repository);

  getSms() {
    isShowProgressController.sink.add(true);
    isProgress = true;
    _repository.restorePassBySms(mobilePhoneEdCon.text, (status) {
      statusGetSmsController.sink.add(status);
      isShowProgressController.sink.add(false);
    });
  }

  @override
  void dispose() {
    mobilePhoneEdCon.dispose();

    statusGetSmsController.close();
    isShowProgressController.close();
    super.dispose();
  }
}
