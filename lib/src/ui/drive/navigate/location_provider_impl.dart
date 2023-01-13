// import 'package:here_sdk/consent.dart';
// import 'package:here_sdk/core.dart';
// import 'package:here_sdk/core.errors.dart';
// import 'package:here_sdk/location.dart';
// import 'package:here_sdk/navigation.dart';
// import 'package:here_sdk/routing.dart';

// // This class provides simulated location events (requires a route).
// // Alternatively, check the positioning example code in the developer's guide
// // to see how to get real location events from a device.

// class PositioningExample implements LocationStatusListener {
//   LocationEngine _locationEngine = LocationEngine();
//   ConsentEngine _consentEngine = ConsentEngine();
//   LocationListener locationListener;

//   LocationSimulator _locationSimulator;

//   void startLocating() async {
//     if (_consentEngine.userConsentState == ConsentUserReply.notHandled) {
//       _consentEngine.requestUserConsent();
//     }
//     _locationEngine.addLocationListener(locationListener);
//     _locationEngine.addLocationStatusListener(this);
//     _locationEngine.startWithLocationAccuracy(LocationAccuracy.bestAvailable);
//     var loc = _locationEngine.lastKnownLocation;
//     print("Last location = ${loc.coordinates}");
//   }

//   void stopLocating() {
//     _locationEngine.removeLocationStatusListener(this);
//     _locationEngine.removeLocationStatusListener(this);
//     _locationEngine.removeLocationListener(locationListener);
//     _locationEngine.stop();
//     _locationSimulator?.stop();
//   }

//   void startLocationSimulator(Route route) {
//     _locationSimulator?.stop();
//     _locationSimulator = _createLocationSimulator(route);
//     _locationSimulator.start();
//   }

//   onFeaturesNotAvailable(List<LocationFeature> features) {
//     print("Test Position example, location feature = $features");
//   }

//   onStatusChanged(LocationEngineStatus locationEngineStatus) {
//     print(
//         "Test Position example, location engine status = $locationEngineStatus");
//   }

//   void release() {
//     print("Test Position example, location release method");
//   }

//   LocationSimulator _createLocationSimulator(Route route) {
//     final double speedFactor = 2;
//     final notificationIntervalInMilliseconds = 1000;
//     LocationSimulatorOptions locationSimulatorOptions =
//         LocationSimulatorOptions(
//       speedFactor,
//       notificationIntervalInMilliseconds,
//     );

//     LocationSimulator locationSimulator;

//     try {
//       locationSimulator =
//           LocationSimulator.withRoute(route, locationSimulatorOptions);
//     } on InstantiationException {
//       throw Exception("Initialization of LocationSimulator failed.");
//     }

//     locationSimulator.listener = LocationListener.fromLambdas(
//         lambda_onLocationUpdated: (Location location) {
//       locationListener?.onLocationUpdated(location);
//     }, lambda_onLocationTimeout: () {
//       // Note: This method is deprecated and will be removed
//       // from the LocationListener interface with release HERE SDK v4.7.0.
//     });

//     return locationSimulator;
//   }
// }
