import 'package:twsl_flutter/src/model/constants/delivery_status.dart';

class PushSM {
  String? track;
  DeliveryStatus status;
  String? body;

  PushSM(this.track, this.status);

  factory PushSM.fromMap(Map<String, dynamic> map) {
    return PushSM(
      map['trackId'],
      DeliveryStatusResources.converterStringToStatus(map['orderStatus']),
    );
  }
}
