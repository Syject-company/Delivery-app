import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:twsl_flutter/src/model/repository/repository.dart';
import 'package:twsl_flutter/src/model/web_apis/result.dart';

class EnterNewPassModel extends ChangeNotifier {
  final Repository? _repository;

  var isProgress = false;

  var newPassEdCon = TextEditingController();
  var confirmPassEdCon = TextEditingController();

  String? phone;
  String? resetToken;

  EnterNewPassModel(this._repository);

  StreamController<bool> isShowProgress = BehaviorSubject();
  StreamController<ResultStatus> statusController = BehaviorSubject();

  changePass() {
    isShowProgress.sink.add(true);
    isProgress = true;
    _repository!.resetPass(phone, resetToken, newPassEdCon.text, (status) {
      statusController.sink.add(status);
      isShowProgress.sink.add(false);
    });
  }

  @override
  void dispose() {
    isShowProgress.close();
    statusController.close();

    newPassEdCon.dispose();
    confirmPassEdCon.dispose();
    super.dispose();
  }
}
