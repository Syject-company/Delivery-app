import 'package:geolocator/geolocator.dart';

import 'package:twsl_flutter/src/model/base_constants.dart';
import 'package:twsl_flutter/src/model/constants/order_filter.dart';
import 'package:twsl_flutter/src/model/models/auth.dart';
import 'package:twsl_flutter/src/model/models/chat.dart';
import 'package:twsl_flutter/src/model/models/orders.dart';
import 'package:twsl_flutter/src/model/models/report.dart';
import 'package:twsl_flutter/src/model/models/users.dart';
import 'package:twsl_flutter/src/model/web_apis/result.dart';

abstract class WebApi {
  getCities(Function(List<City>? result, ResultStatus status) fun);

  registration(Register data, Function(Token? result, ResultStatus) fun);

  confirmEmail(String userId, String code, Function(Result<void> result) fun);

  login(Login data, Function(Token? result, ResultStatus status) fun);

  restorePassBySms(String? mobilePhone, Function(ResultStatus status) callback);

  confirmSms(
    String? phone,
    String smsCode,
    Function(String? token, ResultStatus status) callback,
  );

  resetPass(
    String? phone,
    String? resetToken,
    String pass,
    Function(ResultStatus status) callback,
  );

  sendCodeConfirmAccount(
    String? address,
    WayToVerification? way,
    Function(ResultStatus status) callback,
  );

  confirmAccount(
    String? address,
    WayToVerification? way,
    String code,
    Function(ResultStatus status) callback,
  );

  getProfile(Function(Driver? result, ResultStatus status) fun);

  upgradeProfile(Register data, Function(ResultStatus status) fun);

  phoneNumber(
    String phone,
    String pass,
    Function(ResultStatus status) callback,
  );

  confirmChangingPhoneNumber(
    String confirmationCode,
    Function(ResultStatus status) callback,
  );

  changePassword(
    String oldPass,
    String newPass,
    Function(ResultStatus status) callback,
  );

  turnActiveOn(Function(ResultStatus status) callback);

  turnActiveOff(Function(ResultStatus status) callback);

  loadOrders(
    double lat,
    double lon,
    OrderFilter filter,
    Function(List<OrderItem>? result, ResultStatus status) callback,
  );

  // manage delivery statuses
  takeOrder(
      String? orderId, Function(OrderItem? result, ResultStatus status) callback);

  cancelOrder(String? orderId, Function(ResultStatus status) callback);

  startDelivering(
      String? orderId, Function(OrderItem? result, ResultStatus status) callback);

  deliveredOrder(
      String? orderId, Function(OrderItem? result, ResultStatus status) callback);

  confirmDeliveredOrder(
    String? orderId,
    String confirmationCode,
    Function(OrderItem? result, ResultStatus status) callback,
  );

  confirmDelivery(
    String orderId,
    DeliveryMoment deliveryMoment,
    Function(ResultStatus status) callback,
  );

  resendConfirmCode(String? order, Function(ResultStatus status) callback);

  registerFirebaseTokenDriver(
    String? token,
    Function(ResultStatus status) callback,
  );

  sendDriverPosition(
    Position position,
    Function(ResultStatus status) callback,
  );

  getTrips(Function(List<OrderItem>? result, ResultStatus status) fun);

  //customer
  customerLogin(
    String trackId,
    Function(String? token, ResultStatus status) callback,
  );

  getOrderByTrackId(
    String? trackId,
    Function(OrderItem? result, ResultStatus status) callback,
  );

  orderReport(Report report, Function(ResultStatus status) callback);

  registerFirebaseTokenCustomer(
    String? token,
    Function(ResultStatus status) callback,
  );

/*  getDriverPosition(
    String orderId,
    Function(GeoCoordinates? result, ResultStatus status) callback,
  );*/

  // chat
  getChatRoomInfo(
    String? orderId,
    Function(ChatRoomInfo? result, ResultStatus status) callback,
  );

  getChatMessages(
    String? chatRoomId,
    Function(List<ItemChat>? result, ResultStatus status) callback,
  );
}
