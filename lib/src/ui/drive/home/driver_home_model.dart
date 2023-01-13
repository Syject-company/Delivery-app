import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:twsl_flutter/src/app.dart';
import 'package:twsl_flutter/src/model/constants/order_filter.dart';
import 'package:twsl_flutter/src/model/models/orders.dart';
import 'package:twsl_flutter/src/model/repository/repository.dart';
import 'package:twsl_flutter/src/model/services/events.dart';
import 'package:twsl_flutter/src/model/web_apis/result.dart';

class DriverHomeModel extends ChangeNotifier {
  final Repository _repository;

  List<OrderItem>? orders = [];
  OrderFilter filter = OrderFilter.all;

  StreamController<ResultStatus> statusStream = BehaviorSubject();
  StreamController<bool> isShowProgressController = BehaviorSubject();

  DriverHomeModel(this._repository) {
    loadOrders("Init DriverHomeModel");
    subscribeOnStatusUpdate();
  }

  subscribeOnStatusUpdate() {
    eventBus.on<PushEvent>().listen((event) {
      loadOrders("EventBus");
    });
  }

  loadOrders(String method) async {
    isShowProgressController.sink.add(true);
    Position myPosition;
    try {
      myPosition = await Geolocator.getCurrentPosition();
    } catch (error) {
      myPosition = Position(
        longitude: 24.728049,
        latitude: 46.663879,
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        timestamp: null,
      );
    }
    _repository.loadOrders(myPosition.latitude, myPosition.longitude, filter,
        (result, status) {
      if (status.isSuccessful) {
        orders = result;
        notifyListeners();
      }
      if (!statusStream.isClosed) {
        statusStream.sink.add(status);
        isShowProgressController.sink.add(false);
      }
    });
  }

  @override
  void dispose() {
    statusStream.close();
    isShowProgressController.close();
    super.dispose();
  }
}
