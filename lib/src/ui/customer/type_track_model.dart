import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:twsl_flutter/src/model/preferences/preferences.dart';
import 'package:twsl_flutter/src/model/repository/repository.dart';
import 'package:twsl_flutter/src/model/web_apis/result.dart';

class TypeTrackModel extends ChangeNotifier {
  final Repository _repository;
  final Preferences _preferences;
  final FirebaseMessaging _messaging;
  var trackEdCon = TextEditingController();

  var isProgress = false;
  StreamController<bool> isShowProgressController = BehaviorSubject();
  StreamController<ResultStatus> resultStatusController = BehaviorSubject();

  TypeTrackModel(this._repository, this._preferences, this._messaging);

  login() async {
    isShowProgressController.sink.add(true);
    isProgress = true;
    var advertisingId = await _preferences.getAdvertisingId();
    if (advertisingId == null || advertisingId.isEmpty) {
      await _preferences.saveAdvertisingId(await getDeviceId());
    }
    _repository.customerLogin(trackEdCon.text, (result, status) async {
      if (status.isSuccessful) {
        await _preferences.saveCustomerToken(result);
        await _preferences.saveTrackId(trackEdCon.text);
        _repository.registerFirebaseTokenCustomer(await _messaging.getToken(),
            (status) {
          print("FCM token isSuccessfully = ${status.isSuccessful} added");
        });
      }
      resultStatusController.sink.add(status);
      isShowProgressController.sink.add(false);
    });
  }

  Future<String> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print('Running on ${iosInfo.utsname.machine}'); // e.g. "iPod7,1"
      return iosInfo.identifierForVendor;
    } else {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print('Running on ${androidInfo.model}'); // e.g. "Moto G (4)"
      return androidInfo.androidId;
    }
  }

  @override
  void dispose() {
    trackEdCon.dispose();
    isShowProgressController.close();
    resultStatusController.close();
    super.dispose();
  }
}
