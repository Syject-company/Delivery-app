import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'package:rxdart/rxdart.dart';
import 'package:twsl_flutter/src/app.dart';
import 'package:twsl_flutter/src/model/constants/order_time.dart';
import 'package:twsl_flutter/src/model/models/orders.dart';
import 'package:twsl_flutter/src/model/preferences/preferences.dart';
import 'package:twsl_flutter/src/model/repository/repository.dart';
import 'package:twsl_flutter/src/model/services/events.dart';
import 'package:twsl_flutter/src/model/web_apis/result.dart';

class DeliveryStatusModel extends ChangeNotifier {
  final Preferences _prefs;
  final Repository _repository;

  DateTime? rescheduleDate;
  OrderTime? rescheduleTime;

  OrderItem? deliveryItem;

  var isRescheduling = false;

  var isProgress = false;
  StreamController<bool> isShowProgressController = BehaviorSubject();
  StreamController<ResultStatus> resultStatusController = BehaviorSubject();
/*  StreamController<GeoCoordinates?> driverPosController = BehaviorSubject();*/

  DeliveryStatusModel(this._prefs, this._repository) {
    getOrder();
    subscribeOnStatusUpdate();
  }

  subscribeOnStatusUpdate() {
    eventBus.on<PushEvent>().listen((event) {
      if (deliveryItem!.id!.toLowerCase() == event.pushSM.track!.toLowerCase()) {
        getOrder();
      }
    });
  }

  startRescheduling() {
    isRescheduling = true;
    notifyListeners();
  }

  endRescheduling() {
    isRescheduling = false;
    rescheduleDate = null;
    rescheduleTime = null;
    notifyListeners();
  }

  reschedule() {
    deliveryItem!.orderDate = rescheduleDate;
    deliveryItem!.orderTime = rescheduleTime;
  }

  getOrder() async {
    isProgress = true;
    _repository.getOrderByTrackId(
      await _prefs.getTrackId(),
      (result, status) {
        if (status.isSuccessful) {
          deliveryItem = result;
        }
        resultStatusController.sink.add(status);
        notifyListeners();
      },
    );
  }

  confirmDateDelivery() async {
    isShowProgressController.sink.add(true);
    isProgress = true;
    _repository.confirmDelivery(
      await _prefs.getTrackId(),
      DeliveryMoment.all(
        deliveryItem!.orderTime == OrderTime.none
            ? OrderTime.morning
            : deliveryItem!.orderTime,
        deliveryItem!.orderDate,
      ),
      (status) {
        isShowProgressController.sink.add(false);
        resultStatusController.sink.add(status);
        getOrder();
      },
    );
  }

  getDriverPosition() async {
/*    _repository.getDriverPosition(await _prefs.getTrackId(), (result, status) {
      if (status.isSuccessful) {
        driverPosController.sink.add(result);
      }
    });*/
  }

  @override
  void dispose() {
    isShowProgressController.close();
    resultStatusController.close();

    super.dispose();
  }
}
