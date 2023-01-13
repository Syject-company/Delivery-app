import 'package:geolocator/geolocator.dart';

import 'package:twsl_flutter/src/model/base_constants.dart';
import 'package:twsl_flutter/src/model/constants/order_filter.dart';
import 'package:twsl_flutter/src/model/models/auth.dart';
import 'package:twsl_flutter/src/model/models/chat.dart';
import 'package:twsl_flutter/src/model/models/orders.dart';
import 'package:twsl_flutter/src/model/models/report.dart';
import 'package:twsl_flutter/src/model/models/users.dart';
import 'package:twsl_flutter/src/model/repository/repository.dart';
import 'package:twsl_flutter/src/model/web_apis/result.dart';
import 'package:twsl_flutter/src/model/web_apis/web_api.dart';

class RepositoryImpl implements Repository {
  final WebApi? _webApi;

  RepositoryImpl(this._webApi);

  @override
  getCities(Function(List<City>? result, ResultStatus status) fun) {
    _webApi!.getCities(fun);
  }

  @override
  registration(Register data, Function(Token? result, ResultStatus status) fun) {
    _webApi!.registration(data, fun);
  }

  @override
  confirmEmail(String userId, String code, Function(Result<void> result) fun) {
    _webApi!.confirmEmail(userId, code, fun);
  }

  @override
  login(Login data, Function(Token? result, ResultStatus status) callback) {
    _webApi!.login(data, callback);
  }

  @override
  restorePassBySms(String? mobilePhone, Function(ResultStatus status) callback) {
    _webApi!.restorePassBySms(mobilePhone, callback);
  }

  @override
  confirmSms(String? phone, String smsCode,
      Function(String? token, ResultStatus status) callback) {
    _webApi!.confirmSms(phone, smsCode, callback);
  }

  @override
  resetPass(String? phone, String? resetToken, String pass,
      Function(ResultStatus status) callback) {
    _webApi!.resetPass(phone, resetToken, pass, callback);
  }

  sendCodeConfirmAccount(
    String? address,
    WayToVerification? way,
    Function(ResultStatus status) callback,
  ) {
    _webApi!.sendCodeConfirmAccount(address, way, callback);
  }

  confirmAccount(
    String? address,
    WayToVerification? way,
    String code,
    Function(ResultStatus status) callback,
  ) {
    _webApi!.confirmAccount(address, way, code, callback);
  }

  @override
  getProfile(Function(Driver? result, ResultStatus status) fun) {
    _webApi!.getProfile(fun);
  }

  @override
  upgradeProfile(Register data, Function(ResultStatus status) fun) {
    _webApi!.upgradeProfile(data, fun);
  }

  @override
  phoneNumber(
    String phone,
    String pass,
    Function(ResultStatus status) callback,
  ) {
    _webApi!.phoneNumber(phone, pass, callback);
  }

  @override
  confirmChangingPhoneNumber(
    String confirmationCode,
    Function(ResultStatus status) callback,
  ) {
    _webApi!.confirmChangingPhoneNumber(confirmationCode, callback);
  }

  @override
  changePassword(
    String oldPass,
    String newPass,
    Function(ResultStatus status) callback,
  ) {
    _webApi!.changePassword(oldPass, newPass, callback);
  }

  @override
  turnActiveOn(Function(ResultStatus status) callback) {
    _webApi!.turnActiveOn(callback);
  }

  @override
  turnActiveOff(Function(ResultStatus status) callback) {
    _webApi!.turnActiveOff(callback);
  }

  @override
  loadOrders(
    double lat,
    double lon,
    OrderFilter filter,
    Function(List<OrderItem>? result, ResultStatus status) callback,
  ) {
    _webApi!.loadOrders(lat, lon, filter, callback);
  }

  // manage delivery statuses
  takeOrder(String? orderId,
      Function(OrderItem? result, ResultStatus status) callback) {
    _webApi!.takeOrder(orderId, callback);
  }

  @override
  cancelOrder(String? orderId, Function(ResultStatus status) callback) {
    _webApi!.cancelOrder(orderId, callback);
  }

  startDelivering(String? orderId,
      Function(OrderItem? result, ResultStatus status) callback) {
    _webApi!.startDelivering(orderId, callback);
  }

  deliveredOrder(String? orderId,
      Function(OrderItem? result, ResultStatus status) callback) {
    _webApi!.deliveredOrder(orderId, callback);
  }

  confirmDeliveredOrder(
    String? orderId,
    String confirmationCode,
    Function(OrderItem? result, ResultStatus status) callback,
  ) {
    _webApi!.confirmDeliveredOrder(orderId, confirmationCode, callback);
  }

  resendConfirmCode(String? order, Function(ResultStatus status) callback) {
    _webApi!.resendConfirmCode(order, callback);
  }

  @override
  registerFirebaseTokenDriver(
      String? token, Function(ResultStatus status) callback) {
    _webApi!.registerFirebaseTokenDriver(token, callback);
  }

  @override
  sendDriverPosition(
    Position position,
    Function(ResultStatus status) callback,
  ) {
    _webApi!.sendDriverPosition(position, callback);
  }

  @override
  getTrips(Function(List<OrderItem>? result, ResultStatus status) fun) {
    _webApi!.getTrips(fun);
  }

  // customer
  @override
  confirmDelivery(
    String orderId,
    DeliveryMoment deliveryMoment,
    Function(ResultStatus status) callback,
  ) {
    _webApi!.confirmDelivery(orderId, deliveryMoment, callback);
  }

  @override
  customerLogin(
    String trackId,
    Function(String? token, ResultStatus status) callback,
  ) {
    _webApi!.customerLogin(trackId, callback);
  }

  @override
  getOrderByTrackId(
    String? trackId,
    Function(OrderItem? result, ResultStatus status) callback,
  ) async {
    _webApi!.getOrderByTrackId(trackId, callback);
  }

  orderReport(Report report, Function(ResultStatus status) callback) {
    _webApi!.orderReport(report, callback);
  }

  @override
  registerFirebaseTokenCustomer(
      String? token, Function(ResultStatus status) callback) {
    _webApi!.registerFirebaseTokenCustomer(token, callback);
  }

/*
  @override
  getDriverPosition(
    String orderId,
    Function(GeoCoordinates? result, ResultStatus status) callback,
  ) {
    _webApi!.getDriverPosition(orderId, callback);
  }
*/

  // chat
  @override
  getChatRoomInfo(
    String? orderId,
    Function(ChatRoomInfo? result, ResultStatus status) callback,
  ) {
    _webApi!.getChatRoomInfo(orderId, callback);
  }

  @override
  getChatMessages(
    String? chatRoomId,
    Function(List<ItemChat>? result, ResultStatus status) callback,
  ) {
    _webApi!.getChatMessages(chatRoomId, callback);
  }
}
