import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:twsl_flutter/src/model/models/orders.dart';
import 'package:twsl_flutter/src/model/repository/repository.dart';
import 'package:twsl_flutter/src/model/web_apis/result.dart';

class TripHistoryModel extends ChangeNotifier {
  final Repository? _repository;

  List<OrderItem> trips = [];

  StreamController<ResultStatus> resStatusStreamCom = BehaviorSubject();

  TripHistoryModel(this._repository) {
    getTrips();
  }

  getTrips() async {
    _repository!.getTrips((result, status) {
      trips.clear();
      trips.addAll(result!);
      resStatusStreamCom.sink.add(status);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    resStatusStreamCom.close();

    super.dispose();
  }
}
