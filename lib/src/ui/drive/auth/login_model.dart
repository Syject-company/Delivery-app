import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:twsl_flutter/src/model/models/auth.dart';
import 'package:twsl_flutter/src/model/preferences/preferences.dart';
import 'package:twsl_flutter/src/model/repository/repository.dart';
import 'package:twsl_flutter/src/model/web_apis/result.dart';

class LoginModel extends ChangeNotifier {
  final Repository _repository;
  final Preferences _prefs;
  final FirebaseMessaging _messaging;

  var loginEdCon = TextEditingController();
  var passEdCon = TextEditingController();

  var isProgress = false;

  StreamController<bool> isProgressController = BehaviorSubject();
  StreamController<ResultStatus> statusController = BehaviorSubject();

  LoginModel(this._repository, this._prefs, this._messaging);

  login() {
    isProgressController.add(true);
    isProgress = true;
    _repository.login(Login.all(loginEdCon.text, passEdCon.text),
        (result, status) async {
      if (status.isSuccessful) {
        await _prefs.saveToken(result!.token);
        _repository.registerFirebaseTokenDriver(await _messaging.getToken(),
            (status) {
          print("FCM token isSuccesfully = ${status.isSuccessful} added");
        });
      }
      statusController.add(status);
      isProgressController.add(false);
    });
  }

  @override
  void dispose() {
    isProgressController.close();
    statusController.close();

    loginEdCon.dispose();
    passEdCon.dispose();
    super.dispose();
  }
}
