import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:twsl_flutter/src/model/base_constants.dart';
import 'package:twsl_flutter/src/model/repository/repository.dart';
import 'package:twsl_flutter/src/model/web_apis/result.dart';

class VerificationCodeModel extends ChangeNotifier {
  final Repository? _repository;

  bool isProgress = false;
  String? address;
  String? token;

  WayToVerification? wayToVerification;

  Timer? _timer;
  static const _START_TIMER_TIME = 60;
  var _tempTimer = 0;

  StreamController<bool> isShowProgress = BehaviorSubject();
  StreamController<ResultStatus> statusController = BehaviorSubject();
  StreamController<int> timerStream = BehaviorSubject();

  VerificationCodeModel(this._repository);

  verificationCode(String code) {
    isShowProgress.sink.add(true);
    isProgress = true;
    _repository!.confirmSms(address, code, (token, status) {
      statusController.sink.add(status);
      this.token = token;
      isShowProgress.sink.add(false);
    });
  }

  sendCode() {
    _repository!.restorePassBySms(address, (status) {});
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _tempTimer = _START_TIMER_TIME;
    _timer = new Timer.periodic(oneSec, (Timer timer) {
      if (_tempTimer < 1) {
        timer.cancel();
      } else {
        _tempTimer = _tempTimer - 1;
      }
      timerStream.sink.add(_tempTimer);
    });
  }

  sendCodeConfirmAccount() {
    _repository!.sendCodeConfirmAccount(address, wayToVerification, (status) {});
  }

  confirmAccount(String code) {
    isShowProgress.sink.add(true);
    isProgress = true;
    _repository!.confirmAccount(address, wayToVerification, code, (status) {
      this.token = "stub";
      statusController.sink.add(status);
      isShowProgress.sink.add(false);
    });
  }

  resetTimer() {
    _timer!.cancel();
    _tempTimer = 0;
  }

  closeTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  @override
  void dispose() {
    isShowProgress.close();
    statusController.close();

    timerStream.close();
    _timer!.cancel();
    super.dispose();
  }
}
