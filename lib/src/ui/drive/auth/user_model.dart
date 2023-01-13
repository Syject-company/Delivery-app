import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:twsl_flutter/src/model/base_constants.dart';
import 'package:twsl_flutter/src/model/models/users.dart';
import 'package:twsl_flutter/src/model/preferences/preferences.dart';
import 'package:twsl_flutter/src/model/repository/repository.dart';

class UserModel extends ChangeNotifier {
  final Preferences? _prefs;
  final Repository? _repository;

  ValueNotifier<Driver?> driver = ValueNotifier(null);
  StreamController<String> showMessage = BehaviorSubject();

  UserModel(this._prefs, this._repository);

  getUser() async {
    var token = await _prefs!.getToken();
    if (token != null && token.isNotEmpty) {
      _repository!.getProfile((result, status) {
        if (status.isSuccessful) {
          driver.value = result;
          notifyListeners();
        }
      });
    }
  }

  logout(BuildContext context) {
    driver.value = null;
    _prefs!.saveToken("");
    _prefs!.setIsTrackingDriver(false);

    Navigator.pushNamedAndRemoveUntil(context, Routes.SPLASH, (route) => false);
  }

  turnActiveUser(bool isActive) {
    driver.value?.isActive =
        // ignore: todo
        isActive; //TODO need add mechanism for not On/Off if have problems
    if (isActive) {
      _repository!.turnActiveOn((status) {
        print("Turning On user status isSuccessful = ${status.isSuccessful}");
      });
    } else {
      _repository!.turnActiveOff((status) {
        print("Turning Off user status isSuccessful = ${status.isSuccessful}");
      });
    }
    notifyListeners();
  }

  @override
  void dispose() {
    showMessage.close();
    driver.dispose();
    super.dispose();
  }
}
