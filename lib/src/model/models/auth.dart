import 'dart:io';

import 'package:dio/dio.dart';

class Register {
  String name;
  File? photo;
  String? number;
  String email;
  String? city;
  String postalCode;
  String address;
  String? password;
  String? confirmPassword;
  String iqma;
  String vehicleNumber;
  String vehicleModel;
  String iban;

  Register.all({
    required this.name,
    required this.photo,
    required this.number,
    required this.email,
    required this.city,
    required this.postalCode,
    required this.address,
    required this.password,
    required this.confirmPassword,
    required this.iqma,
    required this.vehicleNumber,
    required this.vehicleModel,
    required this.iban,
  });

  Future<Map<String, dynamic>> toJson() async {
    MultipartFile? file;
    if (photo != null) {
      file = await MultipartFile.fromFile(photo!.path,
          filename: "user_photo_${DateTime.now().microsecondsSinceEpoch}");
    }
    return {
      "file": file,
      "name": name,
      "phoneNumber": number,
      "email": email,
      "cityId": city,
      "postalCode": postalCode,
      "address": address,
      "password": password,
      "confirmPassword": confirmPassword,
      "iqma": iqma,
      "vehicleNumber": vehicleNumber,
      "vehicleModel": vehicleModel,
      "iban": iban,
    };
  }
}

class Token {
  String? token;

  Token(this.token);

  factory Token.fromMap(Map<String, dynamic> map) => Token(map["token"]);
}

class Login {
  String email;
  String password;

  Login.all(this.email, this.password);

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}
