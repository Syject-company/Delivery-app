import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:rxdart/rxdart.dart';
import 'package:twsl_flutter/src/app.dart';
import 'package:twsl_flutter/src/model/services/events.dart';

class NavigateModel extends ChangeNotifier {
/*  GeoCoordinates? endPosition;

  StreamController<GeoCoordinates> driverPositionController = BehaviorSubject();*/

/*  subscribeOnStatusUpdate() {
    eventBus.on<DriverLocationPosition>().listen((event) {
      driverPositionController.sink
          .add(getGeoCoordinatesFromPosition(event.position));
    });
  }

  @override
  void dispose() {
    driverPositionController.close();
    super.dispose();
  }
}

GeoCoordinates getGeoCoordinatesFromPosition(Position position) {
  return GeoCoordinates(position.latitude, position.longitude);*/
}
