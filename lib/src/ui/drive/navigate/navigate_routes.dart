// import 'dart:ui';

// import 'package:here_sdk/core.dart';
// import 'package:here_sdk/mapview.dart';
// import 'package:here_sdk/routing.dart';
// import 'package:here_sdk/routing.dart' as here;
// import 'package:twsl_flutter/src/ui/ui_utils.dart';

// class NavigateRoutes {
//   HereMapController _mapController;
//   RoutingEngine _routingEngine;
//   List<MapPolyline> mapPolylines = [];

//   NavigateRoutes(this._mapController) {
//     _routingEngine = new RoutingEngine();
//   }

//   Future<void> addRoute(GeoCoordinates start, GeoCoordinates end) async {
//     var startWaypoint = Waypoint.withDefaults(start);
//     var destinationWaypoint = Waypoint.withDefaults(end);

//     List<Waypoint> waypoints = [startWaypoint, destinationWaypoint];

//     await _routingEngine.calculateCarRoute(waypoints, CarOptions.withDefaults(),
//         (RoutingError routingError, List<here.Route> routeList) async {
//       if (routingError == null) {
//         here.Route route = routeList.first;
//         // _showRouteDetails(route);
//         _showRouteOnMap(route);
//         // _logRouteViolations(route);
//       } else {
//         var error = routingError.toString();
//         showToast('Error while calculating a route: $error');
//       }
//     });
//   }

//   _showRouteOnMap(here.Route route) {
//     // Show route as polyline.
//     GeoPolyline routeGeoPolyline = GeoPolyline(route.polyline);

//     double widthInPixels = 20;
//     MapPolyline routeMapPolyline = MapPolyline(
//         routeGeoPolyline, widthInPixels, Color.fromARGB(160, 0, 144, 138));

//     _mapController.mapScene.addMapPolyline(routeMapPolyline);
//     mapPolylines.add(routeMapPolyline);
//   }

//   void logRouteViolations(here.Route route) {
//     for (var section in route.sections) {
//       for (var notice in section.notices) {
//         print("This route contains the following warning: " +
//             notice.code.toString());
//       }
//     }
//   }

//   void clearMap() {
//     for (var mapPolyline in mapPolylines) {
//       _mapController.mapScene.removeMapPolyline(mapPolyline);
//     }
//     mapPolylines.clear();
//   }
// }
