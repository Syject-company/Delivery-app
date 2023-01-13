import 'package:flutter/material.dart';
import 'package:twsl_flutter/src/model/preferences/preferences.dart';

class SplashModel extends ChangeNotifier {
  final Preferences? _prefs;
  bool? isAuth;
  String? appLanguage;

  SplashModel(this._prefs) {
    init();
  }

  init() async {
    var token = await _prefs!.getToken();
    isAuth = token != "" && token.isNotEmpty;
    appLanguage = await _prefs!.getAppLanguage();
    notifyListeners();
  }

  saveAppLanguage(String value) {
    _prefs!.saveAppLanguage(value);
  }

  cleanAll() {
    //TODO fast fix.
    isAuth = null;
    init();
  }
}
