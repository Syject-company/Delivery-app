import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:twsl_flutter/src/app.dart';
import 'package:twsl_flutter/src/model/constants/delivery_status.dart';
import 'package:twsl_flutter/src/model/models/orders.dart';
import 'package:twsl_flutter/src/model/repository/repository.dart';
import 'package:twsl_flutter/src/model/services/events.dart';
import 'package:twsl_flutter/src/model/web_apis/result.dart';

class DriverItemDetailsModel extends ChangeNotifier {
  final Repository _repository;

  OrderItem? deliveryItem;

  var isProgress = false;
  StreamController<bool> isShowProgress = BehaviorSubject();
  StreamController<ResultStatus> resultStatusController = BehaviorSubject();

  DriverItemDetailsModel(this._repository) {
    subscribeOnUpdate();
  }

  subscribeOnUpdate() {
    eventBus.on<PushEvent>().listen((event) {
      if (deliveryItem!.id!.toLowerCase() == event.pushSM.track!.toLowerCase()) {
        getOrderByTrackId(deliveryItem!.id);
      }
    });
  }

  takeOrder(String? orderId) {
    if (!isShowProgress.isClosed) {
      isShowProgress.sink.add(true);
    }
    isProgress = true;
    _repository.takeOrder(orderId, (result, status) {
      if (status.isSuccessful) {
        deliveryItem!.orderStatus = result!.orderStatus;
      }
      resultStatusController.sink.add(status);
      isShowProgress.sink.add(false);
    });
  }

  getOrderByTrackId(String? orderId) {
    if (!isShowProgress.isClosed) {
      isShowProgress.sink.add(true);
    }
    isProgress = true;
    _repository.getOrderByTrackId(orderId, (result, status) {
      if (status.isSuccessful) {
        deliveryItem!.orderStatus = result!.orderStatus;
      }
      resultStatusController.sink.add(status);
      isShowProgress.sink.add(false);
    });
  }

  startDelivering(String? orderId) {
    isShowProgress.sink.add(true);
    isProgress = true;
    _repository.startDelivering(orderId, (result, status) {
      if (status.isSuccessful) {
        deliveryItem!.orderStatus = result!.orderStatus;
      }
      resultStatusController.sink.add(status);
      isShowProgress.sink.add(false);
    });
  }

  deliveredOrder(String? orderId) {
    isShowProgress.sink.add(true);
    isProgress = true;
    _repository.deliveredOrder(orderId, (result, status) {
      if (status.isSuccessful) {
        deliveryItem!.orderStatus = result!.orderStatus;
      }
      resultStatusController.sink.add(status);
      isShowProgress.sink.add(false);
    });
  }

  confirmDeliveredOrder(String? orderId, String confirmationCode) {
    isShowProgress.sink.add(true);
    isProgress = true;
    _repository.confirmDeliveredOrder(orderId, confirmationCode,
        (result, status) {
      if (status.isSuccessful) {
        deliveryItem!.orderStatus = result!.orderStatus;
      }
      resultStatusController.sink.add(status);
      isShowProgress.sink.add(false);
    });
  }

  resendConfirmCode(String? orderId) {
    isProgress = true;
    _repository.resendConfirmCode(orderId, (status) {
      resultStatusController.sink.add(status);
    });
  }

  cancelDelivery() {
    if (!isShowProgress.isClosed) {
      isShowProgress.sink.add(true);
    }
    isProgress = true;
    _repository.cancelOrder(deliveryItem!.id, (status) {
      if (status.isSuccessful) {
        deliveryItem!.orderStatus = DeliveryStatus.created;
      }
      resultStatusController.sink.add(status);
      isShowProgress.sink.add(false);
    });
  }

  @override
  void dispose() {
    isShowProgress.close();
    resultStatusController.close();
    super.dispose();
  }
}
