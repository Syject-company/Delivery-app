import 'package:geolocator/geolocator.dart';
import 'package:twsl_flutter/src/model/models/chat.dart';
import 'package:twsl_flutter/src/model/models/services_models.dart';

class PushEvent {
  PushSM pushSM;

  PushEvent(this.pushSM);
}

class MessageEvent {
  ItemChat message;

  MessageEvent(this.message);
}

class DriverLocationPosition {
  Position position;

  DriverLocationPosition(this.position);
}
