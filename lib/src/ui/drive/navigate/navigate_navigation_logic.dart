// import 'dart:async';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:here_sdk/core.dart';
// import 'package:here_sdk/core.errors.dart';
// import 'package:here_sdk/mapview.dart';
// import 'package:here_sdk/routing.dart' as HERE;
// import 'package:twsl_flutter/src/ui/drive/navigate/directions_widget.dart';
// import 'package:twsl_flutter/src/ui/drive/navigate/nav_speaker.dart';

// import 'navigate_navigation.dart';

// // An app that allows to calculate a car route in Berlin and start navigation using simulated locations.
// class NavigateNavigationLogic {
//   HERE.Route _route;
//   HereMapController _hereMapController;
//   NavigateNavigation _navigationExample;
//   MapImage _customerMarker;

//   NavigateNavigationLogic(
//     HereMapController hereMapController,
//     StreamController<NavDirectionModel> maneuver,
//     StreamController<double> speedLimitStream,
//     NavSpeaker navSpeaker,
//   ) {
//     _hereMapController = hereMapController;

//     _navigationExample = NavigateNavigation(
//       _hereMapController,
//       maneuver,
//       speedLimitStream,
//       navSpeaker,
//     );
//   }

//   HereMapController get hereMapController => _hereMapController;

//   void startNavigation(bool isSimulator) {
//     if (_route == null) {
//       print('Error: No route to navigate on.');
//       return;
//     }

//     _navigationExample.startNavigation(_route, isSimulator);
//   }

//   void stopNavigation() {
//     _navigationExample.stopNavigation();
//   }

//   Future<String> calculateRoute(
//       GeoCoordinates start, GeoCoordinates end) async {
//     var startWaypoint = HERE.Waypoint.withDefaults(start);
//     var destinationWaypoint = HERE.Waypoint.withDefaults(end);

//     List<HERE.Waypoint> waypoints = [startWaypoint, destinationWaypoint];

//     HERE.RoutingEngine routingEngine;

//     try {
//       routingEngine = HERE.RoutingEngine();
//     } on InstantiationException {
//       return "Initialization of RoutingEngine failed.";
//     }

//     await routingEngine
//         .calculateCarRoute(waypoints, HERE.CarOptions.withDefaults(),
//             (HERE.RoutingError routingError, List<HERE.Route> routeList) async {
//       if (routingError == null) {
//         _route = routeList.first;
//         _showRouteOnMap(_route);
//       } else {
//         final error = routingError.toString();
//         print('Error while calculating a route: $error');
//       }
//     });
//     return null;
//   }

//   _showRouteOnMap(HERE.Route route) {
//     // Show route as polyline.
//     GeoPolyline routeGeoPolyline = GeoPolyline(route.polyline);

//     double widthInPixels = 20;
//     MapPolyline routeMapPolyline = MapPolyline(
//       routeGeoPolyline,
//       widthInPixels,
//       Color.fromARGB(160, 0, 144, 138),
//     );

//     _hereMapController.mapScene.addMapPolyline(routeMapPolyline);
//   }

//   Future<void> addCustomerMarker(
//       GeoCoordinates geoCoordinates, int drawOrder) async {
//     // Reuse existing MapImage for new map markers.
//     if (_customerMarker == null) {
//       Uint8List imagePixelData =
//           await _loadFileAsUint8List('customer_icon_map.png');
//       _customerMarker =
//           MapImage.withPixelDataAndImageFormat(imagePixelData, ImageFormat.png);
//     }

//     MapMarker mapMarker = MapMarker(geoCoordinates, _customerMarker);
//     mapMarker.drawOrder = drawOrder;

//     _hereMapController.mapScene.addMapMarker(mapMarker);
//   }

//   Future<Uint8List> _loadFileAsUint8List(String fileName) async {
//     // The path refers to the assets directory as specified in pubspec.yaml.
//     ByteData fileData = await rootBundle.load('assets/images/' + fileName);
//     return Uint8List.view(fileData.buffer);
//   }
// }
