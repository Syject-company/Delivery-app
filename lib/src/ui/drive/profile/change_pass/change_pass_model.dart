import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:twsl_flutter/src/model/repository/repository.dart';
import 'package:twsl_flutter/src/model/web_apis/result.dart';

class ChangePassModel extends ChangeNotifier {
  final Repository _repository;

  var oldPass = TextEditingController();
  var newPass = TextEditingController();
  var confPass = TextEditingController();

  var isProgress = false;
  StreamController<bool> isShowProgressController = BehaviorSubject();
  StreamController<ResultStatus> resultStatusController = BehaviorSubject();

  ChangePassModel(this._repository);

  changePass() {
    isProgress = true;
    isShowProgressController.sink.add(true);
    _repository.changePassword(oldPass.text, newPass.text, (status) {
      resultStatusController.sink.add(status);
      isShowProgressController.sink.add(false);
    });
  }

  @override
  void dispose() {
    isShowProgressController.close();
    resultStatusController.close();
    oldPass.dispose();
    newPass.dispose();
    confPass.dispose();
    super.dispose();
  }
}
