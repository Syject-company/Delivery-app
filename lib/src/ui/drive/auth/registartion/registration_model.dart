import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:twsl_flutter/src/model/base_constants.dart';
import 'package:twsl_flutter/src/model/models/auth.dart';
import 'package:twsl_flutter/src/model/models/users.dart';
import 'package:twsl_flutter/src/model/preferences/preferences.dart';
import 'package:twsl_flutter/src/model/repository/repository.dart';
import 'package:twsl_flutter/src/model/web_apis/result.dart';

class RegistrationModel extends ChangeNotifier {
  final Repository _repository;
  final Preferences _prefs;

  // ignore: todo
  // first registrations screen  //TODO redesign with map or different list
  var nameEdCon = TextEditingController();
  var contactNumberEdCon = TextEditingController();
  var emailEdCon = TextEditingController();
  var postalCodeEdCon = TextEditingController();
  var addressEdCon = TextEditingController();
  File? photo;
  City? city;
  var passEdCon = TextEditingController();
  var confPassEdCon = TextEditingController();

  // second registrations screen
  var nationalIdEdCon = TextEditingController();
  var vehicalPlataNumberedCon = TextEditingController();
  var vehicalModelEdCon = TextEditingController();
  var ibanNumberEdCon = TextEditingController();
  bool? isConfirmTerms = false;
  WayToVerification? wayToVerification = WayToVerification.email;

  var screenNumber = 0;
  var isProgress = false;
  StreamController<bool> isProgressController = BehaviorSubject();
  StreamController<ResultStatus> statusController = BehaviorSubject();
  StreamController<ResultStatus> citiesStatusController = BehaviorSubject();
  List<City> cities = [];

  RegistrationModel(this._repository, this._prefs) {
    getCities();
  }

  registration() {
    isProgressController.add(true);
    isProgress = true;
    var register = Register.all(
      name: nameEdCon.text,
      number: contactNumberEdCon.text,
      email: emailEdCon.text,
      photo: photo,
      city: city!.id,
      postalCode: postalCodeEdCon.text,
      address: addressEdCon.text,
      password: passEdCon.text,
      confirmPassword: confPassEdCon.text,
      iqma: nationalIdEdCon.text,
      vehicleNumber: vehicalPlataNumberedCon.text,
      vehicleModel: vehicalModelEdCon.text,
      iban: ibanNumberEdCon.text,
    );

    _repository.registration(register, (result, status) {
      if (status.isSuccessful) {
        _prefs.saveToken(result!.token);
      }
      statusController.add(status);
      isProgressController.add(false);
    });
  }

  getCities() async {
    _repository.getCities((result, status) {
      cities.clear();
      cities.addAll(result!);
      citiesStatusController.sink.add(status);
    });
  }

  @override
  void dispose() {
    nameEdCon.dispose();
    contactNumberEdCon.dispose();
    emailEdCon.dispose();
    postalCodeEdCon.dispose();
    addressEdCon.dispose();
    passEdCon.dispose();
    confPassEdCon.dispose();
    nationalIdEdCon.dispose();
    vehicalPlataNumberedCon.dispose();
    vehicalModelEdCon.dispose();
    ibanNumberEdCon.dispose();

    isProgressController.close();
    statusController.close();
    citiesStatusController.close();
    super.dispose();
  }
}
