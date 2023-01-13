import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:twsl_flutter/src/model/repository/repository.dart';
import 'package:twsl_flutter/src/model/web_apis/result.dart';

class ChangePhoneModel extends ChangeNotifier {
  final Repository _repository;

  var passEdCon = TextEditingController();
  var phoneEdCon = TextEditingController();

  var isProgress = false;
  var isConrmationProcess = false;
  StreamController<bool> isShowProgressController = BehaviorSubject();
  StreamController<ResultStatus> resultStatusController = BehaviorSubject();

  ChangePhoneModel(this._repository);

  changePhoneNumber() {
    isShowProgressController.sink.add(true);
    isProgress = true;
    _repository.phoneNumber(phoneEdCon.text, passEdCon.text, (status) {
      resultStatusController.sink.add(status);
      isShowProgressController.sink.add(false);
    });
  }

  confirm(String code) {
    isShowProgressController.sink.add(true);
    isProgress = true;
    isConrmationProcess = true;
    _repository.confirmChangingPhoneNumber(code, (status) {
      resultStatusController.sink.add(status);
      isShowProgressController.sink.add(false);
    });
  }

  @override
  void dispose() {
    isShowProgressController.close();
    resultStatusController.close();
    passEdCon.dispose();
    phoneEdCon.dispose();
    super.dispose();
  }
}
