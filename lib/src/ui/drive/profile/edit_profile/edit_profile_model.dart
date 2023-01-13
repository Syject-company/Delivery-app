import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:twsl_flutter/src/model/models/auth.dart';
import 'package:twsl_flutter/src/model/models/users.dart';
import 'package:twsl_flutter/src/model/repository/repository.dart';
import 'package:twsl_flutter/src/model/web_apis/result.dart';
import 'package:twsl_flutter/src/ui/ui_utils.dart';

class EditDriverProfileModel extends ChangeNotifier {
  final Repository _repository;

  var nameEdCon = TextEditingController();
  var emailEdCon = TextEditingController();
  File? photo;
  String? lastPhoto;
  City? city;
  var postalCodeEdCon = TextEditingController();
  var addressEdCon = TextEditingController();

  var iqmaEdCon = TextEditingController();
  var vehicalNumberEdCon = TextEditingController();
  var vehicalModelEdCon = TextEditingController();
  var ibanNumberEdCon = TextEditingController();

  var isProgress = false;
  StreamController<ResultStatus> statusController = BehaviorSubject();
  StreamController<bool> isShowProgress = BehaviorSubject();
  StreamController<ResultStatus> citiesStatusController = BehaviorSubject();
  List<City> cities = [];

  late Driver _driver;

  EditDriverProfileModel(this._repository) {
    getCities();
  }

  setProfile(Driver? driver) {
    if (driver == null) {
      showToast(
          "There are problems with the user info, please try again later.");
      return;
    }
    _driver = driver;
    nameEdCon.text = _driver.name!;
    emailEdCon.text = _driver.email!;
    lastPhoto = _driver.photoUri;
    city = _driver.city;
    postalCodeEdCon.text = _driver.postalCode!;
    addressEdCon.text = _driver.address!;
    iqmaEdCon.text = _driver.iqma!;
    vehicalNumberEdCon.text = _driver.vehicleNumber!;
    vehicalModelEdCon.text = _driver.vehicleModel!;
    ibanNumberEdCon.text = _driver.iban!;
  }

  upgradeProfile() {
    isShowProgress.add(true);
    isProgress = true;
    _driver.name = nameEdCon.text;
    _driver.email = emailEdCon.text;
    _driver.city = city;
    _driver.postalCode = postalCodeEdCon.text;
    _driver.address = addressEdCon.text;
    _driver.iqma = iqmaEdCon.text;
    _driver.vehicleNumber = vehicalNumberEdCon.text;
    _driver.vehicleModel = vehicalModelEdCon.text;
    _driver.iban = ibanNumberEdCon.text;

    var register = Register.all(
      name: nameEdCon.text,
      photo: photo,
      number: _driver.phoneNumber,
      email: emailEdCon.text,
      city: city!.id,
      postalCode: postalCodeEdCon.text,
      address: addressEdCon.text,
      password: null,
      confirmPassword: null,
      iqma: iqmaEdCon.text,
      vehicleNumber: vehicalNumberEdCon.text,
      vehicleModel: vehicalModelEdCon.text,
      iban: ibanNumberEdCon.text,
    );

    _repository.upgradeProfile(register, (status) {
      statusController.add(status);
      isShowProgress.add(false);
    });
  }

  getCities() async {
    _repository.getCities((result, status) {
      cities.clear();
      cities.addAll(result!);
      citiesStatusController.sink.add(status);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    nameEdCon.dispose();
    emailEdCon.dispose();
    postalCodeEdCon.dispose();
    addressEdCon.dispose();
    iqmaEdCon.dispose();
    vehicalModelEdCon.dispose();
    vehicalNumberEdCon.dispose();
    ibanNumberEdCon.dispose();

    statusController.close();
    isShowProgress.close();
    citiesStatusController.close();
    super.dispose();
  }
}
