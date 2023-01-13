class Driver {
  String? id;
  String? email;
  String? phoneNumber;
  String? name;
  String? photoUri;
  String? postalCode;
  City? city;
  String? address;
  String? iqma;
  String? vehicleNumber;
  String? vehicleModel;
  String? iban;
  bool? isActive;

  Driver.all(
    this.id,
    this.email,
    this.phoneNumber,
    this.name,
    this.photoUri,
    this.postalCode,
    this.city,
    this.address,
    this.iqma,
    this.vehicleNumber,
    this.vehicleModel,
    this.iban,
    this.isActive,
  );

  factory Driver.fromMap(Map<String, dynamic> map) {
    City? city;
    var cityRaw = map['city'];

    if (cityRaw != null) {
      city = City.fromJson(cityRaw);
    }

    return Driver.all(
      map['id'],
      map['email'],
      map['phoneNumber'],
      map["name"],
      map['photoUri'],
      map['postalCode'],
      city,
      map['address'],
      map['iqma'],
      map['vehicleNumber'],
      map['vehicleModel'],
      map['iban'],
      map['isActive'],
    );
  }
}

class City {
  String? id;
  String? cityName;
  String? cityCode;
  String? cityEng;
  String? cityAr;

  City(this.id, this.cityName, this.cityCode, this.cityEng, this.cityAr);

  factory City.fromJson(Map<String, dynamic> map) {
    return City(
      map['id'],
      map['cityName'],
      map['cityCode'],
      map['cityEng'],
      map['cityAr'],
    );
  }
}
