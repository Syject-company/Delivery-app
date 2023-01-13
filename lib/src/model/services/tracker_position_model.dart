import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:twsl_flutter/src/app.dart';
import 'package:twsl_flutter/src/model/preferences/preferences.dart';
import 'package:twsl_flutter/src/model/repository/repository.dart';
import 'package:twsl_flutter/src/model/services/events.dart';

class TrackerPositionModel extends ChangeNotifier {
  final Repository? _repository;
  final Preferences _prefs;
  StreamSubscription<Position>? positionStream;

  TrackerPositionModel(this._repository, this._prefs) {
    _prefs.isTrackingDriver().then((value) {
      if (value == true) {
        startTracking();
      }
    });
  }

  startTracking() {
    if (positionStream != null) return;
    positionStream = Geolocator.getPositionStream().listen(
      (Position position) {
        print(position == null
            ? 'Unknown'
            : position.latitude.toString() +
                ', ' +
                position.longitude.toString());
        _repository!.sendDriverPosition(position, (status) {
          print(
              "Position = ${position.latitude}, ${position.longitude}, added isSuccessfully = ${status.isSuccessful}");
        });
        eventBus.fire(DriverLocationPosition(position));
      },
    );
    _prefs.setIsTrackingDriver(true);
  }

  stopTracking() {
    if (positionStream != null) positionStream!.cancel();
    positionStream = null;
    _prefs.setIsTrackingDriver(false);
  }

  @override
  void dispose() {
    if (positionStream != null) positionStream!.cancel();
    positionStream = null;
    super.dispose();
  }
}
