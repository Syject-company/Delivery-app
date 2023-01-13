import 'package:flutter/cupertino.dart';
import 'package:twsl_flutter/src/model/models/orders.dart';
import 'package:twsl_flutter/src/model/repository/repository.dart';
import 'package:twsl_flutter/src/ui/ui_utils.dart';

class PaymentHistoryModel extends ChangeNotifier {
  final Repository _repository;

  PaymentHistoryModel(this._repository) {
    loadOrders();
  }

  List<OrderItem> orders = [];

  loadOrders() async {
    _repository.getTrips((result, status) {
      if (status.isSuccessful) {
        orders.clear();
        orders.addAll(result!);
        notifyListeners();
      } else {
        showToast(status.message.toString());
      }
    });
  }
}
