import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';

import 'package:twsl_flutter/src/model/base_constants.dart';
import 'package:twsl_flutter/src/model/constants/order_filter.dart';
import 'package:twsl_flutter/src/model/models/auth.dart';
import 'package:twsl_flutter/src/model/models/chat.dart';
import 'package:twsl_flutter/src/model/models/orders.dart';
import 'package:twsl_flutter/src/model/models/report.dart';
import 'package:twsl_flutter/src/model/models/users.dart';
import 'package:twsl_flutter/src/model/preferences/preferences.dart';
import 'package:twsl_flutter/src/model/web_apis/result.dart';
import 'package:twsl_flutter/src/model/web_apis/web_api.dart';

class WebApiImpl implements WebApi {
  final Dio? _client;
  final Preferences? _prefs;

  WebApiImpl(this._client, this._prefs);

  @override
  getCities(Function(List<City>? result, ResultStatus status) fun) async {
    List<City>? result;
    ResultStatus? status;

    try {
      var res = await _client!.get("/api/Driver/Cities");
      result = [];
      res.data.forEach((item) {
        result!.add(City.fromJson(item));
      });
      status = ResultStatus.response(res);
    } on DioError catch (e) {
      status = ResultStatus.error(e);
    } finally {
      if (status == null) {
        status = ResultStatus(0, message: "Unknown error");
      }
      fun.call(result, status);
    }
  }

  @override
  registration(
      Register data, Function(Token? token, ResultStatus result) fun) async {
    Token? result;
    ResultStatus? status;
    try {
      FormData formData = FormData.fromMap(await data.toJson());
      var response = await _client!.post(
        "/api/Driver/register",
        data: formData,
      );
      result = Token.fromMap(response.data);
      status = ResultStatus.response(response);
    } on DioError catch (e) {
      status = ResultStatus.error(e);
    } finally {
      if (status == null) {
        status = ResultStatus(0, message: "Unknown error");
      }
      fun.call(result, status);
    }
  }

  @override
  confirmEmail(
      String userId, String code, Function(Result<void> result) fun) async {
    var args = {
      "userId": userId,
      "code": code,
    };
    var response =
        await _client!.get("/api/Driver/ConfirmEmail", queryParameters: args);
    // fun.call(
    // Result(
    //   null,
    //   ResultStatus(response.statusCode, message: response.statusMessage),
    // ),
    // );
  }

  login(
      Login data, Function(Token? result, ResultStatus status) callback) async {
    Token? result;
    ResultStatus? status;
    try {
      var res = await _client!.post(
        "/api/Driver/login",
        data: data.toJson(),
      );
      result = Token.fromMap(res.data);
      status = ResultStatus.response(res);
    } on DioError catch (e) {
      status = ResultStatus.error(e);
    } finally {
      if (status == null) status = ResultStatus.unknownError();
      callback.call(result, status);
    }
  }

  @override
  restorePassBySms(
      String? mobilePhone, Function(ResultStatus status) callback) async {
    ResultStatus? status;
    try {
      var res = await _client!.post("/api/Driver/InitResetingPassword",
          data: {"phoneNumber": mobilePhone});
      status = ResultStatus.response(res);
    } on DioError catch (e) {
      status = ResultStatus.error(e);
    } finally {
      if (status == null) status = ResultStatus.unknownError();
      callback.call(status);
    }
  }

  @override
  confirmSms(String? phone, String smsCode,
      Function(String? token, ResultStatus status) callback) async {
    String? result;
    ResultStatus? status;
    try {
      var res = await _client!.post("/api/Driver/ConfirmSMSCode",
          data: {"phoneNumber": phone, "smsCode": smsCode});
      result = Token.fromMap(res.data).token;
      status = ResultStatus.response(res);
    } on DioError catch (e) {
      status = ResultStatus.error(e);
    } finally {
      if (status == null) status = ResultStatus.unknownError();
      callback.call(result, status);
    }
  }

  @override
  resetPass(String? phone, String? resetToken, String pass,
      Function(ResultStatus status) callback) async {
    ResultStatus? status;
    try {
      var res = await _client!.post(
        "/api/Driver/ResetPassword",
        data: {
          "phoneNumber": phone,
          "resetToken": resetToken,
          "newPassword": pass
        },
      );

      status = ResultStatus.response(res);
    } on DioError catch (e) {
      status = ResultStatus.error(e);
    } finally {
      if (status == null) status = ResultStatus.unknownError();
      callback.call(status);
    }
  }

  @override
  sendCodeConfirmAccount(
    String? address,
    WayToVerification? way,
    Function(ResultStatus status) callback,
  ) async {
    ResultStatus? status;
    try {
      var res = await _client!.post("/api/Driver/InitConfirmingAccount", data: {
        "phoneOrEmail": address,
        "confirmationType": WayVerifyResource.getName(way),
      });
      status = ResultStatus.response(res);
    } on DioError catch (e) {
      status = ResultStatus.error(e);
    } finally {
      if (status == null) status = ResultStatus.unknownError();
      callback.call(status);
    }
  }

  @override
  confirmAccount(
    String? address,
    WayToVerification? way,
    String code,
    Function(ResultStatus status) callback,
  ) async {
    ResultStatus? status;
    try {
      var res = await _client!.post("/api/Driver/ConfirmAccount", data: {
        "phoneOrEmail": address,
        "confirmationType": WayVerifyResource.getName(way),
      }, queryParameters: {
        "code": code
      });
      status = ResultStatus.response(res);
    } on DioError catch (error) {
      status = ResultStatus.error(error);
    } finally {
      if (status == null) status = ResultStatus.unknownError();
      callback.call(status);
    }
  }

  @override
  getProfile(Function(Driver? result, ResultStatus status) fun) async {
    Driver? result;
    ResultStatus? status;
    try {
      Response res = await _client!.get(
        "/api/Driver/getuserbytoken",
        options: Options(
          headers: {"Authorization": "Bearer ${await _prefs!.getToken()}"},
        ),
      );
      result = Driver.fromMap(res.data);
      status = ResultStatus(res.statusCode, message: res.statusMessage);
    } on DioError catch (e) {
      status = ResultStatus(e.response!.statusCode, message: e.message);
    } finally {
      if (status == null) status = ResultStatus.unknownError();
      fun.call(result, status);
    }
  }

  @override
  upgradeProfile(Register data, Function(ResultStatus status) callback) async {
    ResultStatus? status;
    try {
      FormData formData = FormData.fromMap(await data.toJson());
      print("Form data = ${formData.fields}");
      var response = await _client!.put(
        "/api/Driver/updateuser",
        data: formData,
        options: Options(
          headers: {"Authorization": "Bearer ${await _prefs!.getToken()}"},
        ),
      );
      status = ResultStatus.response(response);
    } on DioError catch (e) {
      status = ResultStatus.error(e);
    } finally {
      if (status == null) status = ResultStatus.unknownError();
      callback.call(status);
    }
  }

  @override
  phoneNumber(
    String phone,
    String pass,
    Function(ResultStatus status) callback,
  ) async {
    ResultStatus? status;
    try {
      var response = await _client!.put(
        "/api/Driver/PhoneNumber",
        data: {"phoneNumber": phone, "password": pass},
        options: Options(
          headers: {"Authorization": "Bearer ${await _prefs!.getToken()}"},
        ),
      );
      status = ResultStatus.response(response);
    } on DioError catch (e) {
      status = ResultStatus.error(e);
    } finally {
      if (status == null) status = ResultStatus.unknownError();
      callback.call(status);
    }
  }

  @override
  confirmChangingPhoneNumber(
    String confirmationCode,
    Function(ResultStatus status) callback,
  ) async {
    ResultStatus? status;
    try {
      var response = await _client!.put(
        "/api/Driver/ConfirmChangingPhoneNumber",
        queryParameters: {"confirmationCode": confirmationCode},
        options: Options(
          headers: {"Authorization": "Bearer ${await _prefs!.getToken()}"},
        ),
      );
      status = ResultStatus.response(response);
    } on DioError catch (e) {
      status = ResultStatus.error(e);
    } finally {
      if (status == null) status = ResultStatus.unknownError();
      callback.call(status);
    }
  }

  changePassword(
    String oldPass,
    String newPass,
    Function(ResultStatus status) callback,
  ) async {
    ResultStatus? status;
    try {
      var response = await _client!.post(
        "/api/Driver/changePassword",
        data: {"oldPassword": oldPass, "newPassword": newPass},
        options: Options(
          headers: {"Authorization": "Bearer ${await _prefs!.getToken()}"},
        ),
      );

      status = ResultStatus.response(response);
    } on DioError catch (e) {
      status = ResultStatus.error(e);
    } finally {
      if (status == null) status = ResultStatus.unknownError();
      callback.call(status);
    }
  }

  @override
  turnActiveOn(Function(ResultStatus status) callback) async {
    ResultStatus? status;
    try {
      var response = await _client!.get(
        "/api/Driver/TurnActiveOn",
        options: Options(
          headers: {"Authorization": "Bearer ${await _prefs!.getToken()}"},
        ),
      );

      status = ResultStatus.response(response);
    } on DioError catch (e) {
      status = ResultStatus.error(e);
    } finally {
      if (status == null) status = ResultStatus.unknownError();
      callback.call(status);
    }
  }

  @override
  turnActiveOff(Function(ResultStatus status) callback) async {
    ResultStatus? status;
    try {
      var response = await _client!.get(
        "/api/Driver/TurnActiveOff",
        options: Options(
          headers: {"Authorization": "Bearer ${await _prefs!.getToken()}"},
        ),
      );

      status = ResultStatus.response(response);
    } on DioError catch (e) {
      status = ResultStatus.error(e);
    } finally {
      if (status == null) status = ResultStatus.unknownError();
      callback.call(status);
    }
  }

  @override
  loadOrders(
    double lat,
    double lon,
    OrderFilter filter,
    Function(List<OrderItem>? result, ResultStatus status) callback,
  ) async {
    List<OrderItem>? result;
    ResultStatus? status;
    try {
      var res = await _client!.get(
        "/api/SetOfOrders/ByLocation",
        queryParameters: {
          "currentPointLongitude": lat,
          "currentPointLatitude": lon,
          "filter": OrderFilterResources.orderFilterToString(filter),
        },
        options: Options(
          headers: {"Authorization": "Bearer ${await _prefs!.getToken()}"},
        ),
      );

      result = [];
      res.data.forEach((item) {
        result!.add(OrderItem.fromMap(item));
      });
      status = ResultStatus.response(res);
    } on DioError catch (e) {
      status = ResultStatus.error(e);
    } finally {
      if (status == null) status = ResultStatus.unknownError();
      callback.call(result, status);
    }
  }

  // manage delivery statuses
  takeOrder(String? orderId,
      Function(OrderItem? result, ResultStatus status) callback) async {
    OrderItem? result;
    ResultStatus? status;
    try {
      var response = await _client!.get(
        "/api/ManageDeliveryStatus/Driver/TakeOrder/$orderId",
        options: Options(
          headers: {"Authorization": "Bearer ${await _prefs!.getToken()}"},
        ),
      );
      result = OrderItem.fromMap(response.data);
      status = ResultStatus.response(response);
    } on DioError catch (e) {
      status = ResultStatus.error(e);
    } finally {
      if (status == null) status = ResultStatus.unknownError();
      callback.call(result, status);
    }
  }

  @override
  cancelOrder(String? orderId, Function(ResultStatus status) callback) async {
    ResultStatus? status;
    try {
      var response = await _client!.get(
        "/api/ManageDeliveryStatus/Driver/RefuseDelivering/$orderId",
        options: Options(
          headers: {"Authorization": "Bearer ${await _prefs!.getToken()}"},
        ),
      );
      status = ResultStatus.response(response);
    } on DioError catch (e) {
      status = ResultStatus.error(e);
    } finally {
      if (status == null) status = ResultStatus.unknownError();
      callback.call(status);
    }
  }

  startDelivering(String? orderId,
      Function(OrderItem? result, ResultStatus status) callback) async {
    OrderItem? result;
    ResultStatus? status;
    try {
      var response = await _client!.get(
        "/api/ManageDeliveryStatus/Driver/StartDelivering/$orderId",
        options: Options(
          headers: {"Authorization": "Bearer ${await _prefs!.getToken()}"},
        ),
      );

      result = OrderItem.fromMap(response.data);
      status = ResultStatus.response(response);
    } on DioError catch (e) {
      status = ResultStatus.error(e);
    } finally {
      if (status == null) status = ResultStatus.unknownError();
      callback.call(result, status);
    }
  }

  deliveredOrder(String? orderId,
      Function(OrderItem? result, ResultStatus status) callback) async {
    OrderItem? result;
    ResultStatus? status;
    try {
      var response = await _client!.get(
        "/api/ManageDeliveryStatus/Driver/DeliveredOrder/$orderId",
        options: Options(
          headers: {"Authorization": "Bearer ${await _prefs!.getToken()}"},
        ),
      );

      result = OrderItem.fromMap(response.data);
      status = ResultStatus.response(response);
    } on DioError catch (e) {
      status = ResultStatus.error(e);
    } finally {
      if (status == null) status = ResultStatus.unknownError();
      callback.call(result, status);
    }
  }

  confirmDeliveredOrder(
    String? orderId,
    String confirmationCode,
    Function(OrderItem? result, ResultStatus status) callback,
  ) async {
    OrderItem? result;
    ResultStatus? status;
    try {
      var response = await _client!.get(
        "/api/ManageDeliveryStatus/Driver/ConfirmDeliveredOrder/$orderId",
        queryParameters: {"confirmationCode": confirmationCode},
        options: Options(
          headers: {"Authorization": "Bearer ${await _prefs!.getToken()}"},
        ),
      );

      result = OrderItem.fromMap(response.data);
      status = ResultStatus.response(response);
    } on DioError catch (e) {
      status = ResultStatus.error(e);
    } finally {
      if (status == null) status = ResultStatus.unknownError();
      callback.call(result, status);
    }
  }

  resendConfirmCode(
      String? order, Function(ResultStatus status) callback) async {
    ResultStatus? status;
    try {
      var response = await _client!.get(
        "/api/ManageDeliveryStatus/Driver/ResendConfirmCode/$order",
        options: Options(
          headers: {"Authorization": "Bearer ${await _prefs!.getToken()}"},
        ),
      );

      status = ResultStatus.response(response);
    } on DioError catch (e) {
      status = ResultStatus.error(e);
    } finally {
      if (status == null) status = ResultStatus.unknownError();
      callback.call(status);
    }
  }

  @override
  registerFirebaseTokenDriver(
    String? token,
    Function(ResultStatus status) callback,
  ) async {
    ResultStatus? status;
    try {
      var response = await _client!.put(
        "/api/Driver/RegisterFirebaseToken",
        data: {"token": token},
        options: Options(
          headers: {"Authorization": "Bearer ${await _prefs!.getToken()}"},
        ),
      );
      status = ResultStatus.response(response);
    } on DioError catch (e) {
      status = ResultStatus.error(e);
    } finally {
      if (status == null) status = ResultStatus.unknownError();
      callback.call(status);
    }
  }

  @override
  sendDriverPosition(
    Position position,
    Function(ResultStatus status) callback,
  ) async {
    ResultStatus? status;
    try {
      var response = await _client!.put(
        "/api/DriverLocation",
        data: {
          "currentLatitude": position.latitude,
          "currentLongitude": position.longitude,
        },
        options: Options(
          headers: {"Authorization": "Bearer ${await _prefs!.getToken()}"},
        ),
      );
      status = ResultStatus.response(response);
    } on DioError catch (e) {
      status = ResultStatus.error(e);
    } finally {
      if (status == null) status = ResultStatus.unknownError();
      callback.call(status);
    }
  }

  @override
  getTrips(Function(List<OrderItem>? result, ResultStatus status) fun) async {
    List<OrderItem>? result;
    ResultStatus? status;
    try {
      var res = await _client!.get(
        "/api/admins/paymenthistory",
        options: Options(
          headers: {"Authorization": "Bearer ${await _prefs!.getToken()}"},
        ),
      );

      result = [];
      res.data.forEach((item) {
        result!.add(OrderItem.fromMap(item));
      });
      status = ResultStatus.response(res);
    } on DioError catch (e) {
      status = ResultStatus.error(e);
    } finally {
      if (status == null) status = ResultStatus.unknownError();
      fun.call(result, status);
    }
  }

  // customer
  @override
  confirmDelivery(
    String orderId,
    DeliveryMoment deliveryMoment,
    Function(ResultStatus status) callback,
  ) async {
    ResultStatus? status;
    try {
      var response = await _client!.post(
        "/api/ManageDeliveryStatus/Customer/ConfirmDelivery/$orderId",
        data: deliveryMoment.toMap(),
        options: Options(
          headers: {
            "Authorization": "Bearer ${await _prefs!.getCustomerToken()}"
          },
        ),
      );

      status = ResultStatus.response(response);
    } on DioError catch (e) {
      status = ResultStatus.error(e);
    } finally {
      if (status == null) status = ResultStatus.unknownError();
      callback.call(status);
    }
  }

  @override
  customerLogin(
    String trackId,
    Function(String? token, ResultStatus status) callback,
  ) async {
    String? token;
    ResultStatus? status;
    try {
      var response = await _client!.post("/api/Customer/login", data: {
        "advertiseId": await _prefs!.getAdvertisingId(),
        "trackId": trackId,
      });

      token = Token.fromMap(response.data).token;
      status = ResultStatus.response(response);
    } on DioError catch (e) {
      status = ResultStatus.error(e);
    } finally {
      if (status == null) status = ResultStatus.unknownError();
      callback.call(token, status);
    }
  }

  @override
  getOrderByTrackId(
    String? trackId,
    Function(OrderItem? result, ResultStatus status) callback,
  ) async {
    OrderItem? result;
    ResultStatus? status;

    var token = await _prefs!.getToken();
    if (token == null || token.isEmpty) {
      token = await _prefs!.getCustomerToken();
    }

    try {
      var response = await _client!.get(
        "/api/Order/$trackId",
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      result = OrderItem.fromMap(response.data);
      status = ResultStatus.response(response);
    } on DioError catch (e) {
      status = ResultStatus.error(e);
    } finally {
      if (status == null) status = ResultStatus.unknownError();
      callback.call(result, status);
    }
  }

  orderReport(Report report, Function(ResultStatus status) callback) async {
    ResultStatus? status;
    try {
      var response = await _client!.post(
        "/api/Customer/OrderReport",
        data: report.toMap(),
        options: Options(
          headers: {
            "Authorization": "Bearer ${await _prefs!.getCustomerToken()}"
          },
        ),
      );

      status = ResultStatus.response(response);
    } on DioError catch (e) {
      status = ResultStatus.error(e);
    } finally {
      if (status == null) status = ResultStatus.unknownError();
      callback.call(status);
    }
  }

  @override
  registerFirebaseTokenCustomer(
    String? token,
    Function(ResultStatus status) callback,
  ) async {
    ResultStatus? status;
    try {
      var response = await _client!.put(
        "/api/Customer/RegisterFirebaseToken",
        data: {"token": token},
        options: Options(
          headers: {
            "Authorization": "Bearer ${await _prefs!.getCustomerToken()}"
          },
        ),
      );
      status = ResultStatus.response(response);
    } on DioError catch (e) {
      status = ResultStatus.error(e);
    } finally {
      if (status == null) status = ResultStatus.unknownError();
      callback.call(status);
    }
  }

  @override
  getDriverPosition(
    String orderId,
    Function( ResultStatus status) callback,
  ) async {
   /* GeoCoordinates? result;*/
    ResultStatus? status;
    try {
      var response = await _client!.get(
        "/api/DriverLocation/$orderId",
        options: Options(
          headers: {
            "Authorization": "Bearer ${await _prefs!.getCustomerToken()}"
          },
        ),
      );

/*      result = GeoCoordinates(
        response.data['currentLatitude'],
        response.data['currentLongitude'],
      );*/
      status = ResultStatus.response(response);
    } on DioError catch (e) {
      status = ResultStatus.error(e);
    } finally {
      if (status == null) status = ResultStatus.unknownError();
     // callback.call(result, status);
    }
  }

  // chat
  @override
  getChatRoomInfo(
    String? orderId,
    Function(ChatRoomInfo? result, ResultStatus status) callback,
  ) async {
    ChatRoomInfo? result;
    ResultStatus? status;

    String token;
    var driverToken = await _prefs!.getToken();
    if (driverToken != null && driverToken.isNotEmpty) {
      token = driverToken;
    } else {
      token = await _prefs!.getCustomerToken();
    }

    try {
      var response = await _client!.get(
        "/api/Messages/ChatRoom/$orderId",
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      result = ChatRoomInfo.fromMap(response.data);
      status = ResultStatus.response(response);
    } on DioError catch (e) {
      status = ResultStatus.error(e);
    } finally {
      if (status == null) status = ResultStatus.unknownError();
      callback.call(result, status);
    }
  }

  @override
  getChatMessages(
    String? chatRoomId,
    Function(List<ItemChat>? result, ResultStatus status) callback,
  ) async {
    List<ItemChat>? result;
    ResultStatus? status;

    String token;
    var driverToken = await _prefs!.getToken();
    if (driverToken != null && driverToken.isNotEmpty) {
      token = driverToken;
    } else {
      token = await _prefs!.getCustomerToken();
    }

    try {
      var response = await _client!.get(
        "/api/Messages/$chatRoomId",
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      result = <ItemChat>[];
      response.data.forEach((item) {
        result!.add(ItemChat.fromMap(item));
      });
      status = ResultStatus.response(response);
    } on DioError catch (e) {
      status = ResultStatus.error(e);
    } finally {
      if (status == null) status = ResultStatus.unknownError();
      callback.call(result, status);
    }
  }
}
