// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_i18n/flutter_i18n.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:here_sdk/core.dart';
// import 'package:here_sdk/mapview.dart';
// import 'package:provider/provider.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:twsl_flutter/src/model/utils/extensions.dart';
// import 'package:twsl_flutter/src/ui/drive/navigate/directions_widget.dart';
// import 'package:twsl_flutter/src/ui/drive/navigate/nav_speaker.dart';
// import 'package:twsl_flutter/src/ui/drive/navigate/navigate_model.dart';
// import 'package:twsl_flutter/src/ui/ui_utils.dart';

// import 'navigate_navigation_logic.dart';

// class NavigateScreen extends StatefulWidget {
//   @override
//   _NavigateScreen createState() => _NavigateScreen();
// }

// class _NavigateScreen extends State<NavigateScreen> {
//   NavigateNavigationLogic _navigationLogic;
//   NavigateModel model;
//   NavSpeaker _navSpeaker;
//   StreamController<NavDirectionModel> maneuverStream = BehaviorSubject();
//   StreamController<double> speedLimitStream = BehaviorSubject();
//   StreamController<NavStatus> statusNavigationCon = BehaviorSubject();

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => NavigateModel(),
//       builder: (context, _) {
//         model = Provider.of<NavigateModel>(context, listen: false);

//         final Map arguments = ModalRoute.of(context).settings.arguments as Map;
//         model.endPosition = GeoCoordinates(
//           arguments['end_position_lat'],
//           arguments['end_position_lon'],
//         );
//         print("Position = ${model.endPosition}");

//         _navSpeaker = NavSpeaker();
//         _navSpeaker.init(FlutterI18n.currentLocale(context).languageCode);
//         return Scaffold(
//           appBar: AppBar(
//               title: Text("Navigation",
//                   style: TextStyle(color: "454F63".getColor()))),
//           body: Stack(alignment: AlignmentDirectional.bottomCenter, children: [
//             HereMap(onMapCreated: _onMapCreated),
//             Align(
//               alignment: Alignment.topLeft,
//               child: Padding(
//                 padding: EdgeInsets.fromLTRB(16, 32, 16, 16),
//                 child: SizedBox(
//                   height: 80,
//                   width: 80,
//                   child: StreamBuilder(
//                       stream: speedLimitStream.stream,
//                       builder: (context, data) {
//                         if (data == null || data?.data == null)
//                           return const SizedBox();
//                         return Visibility(
//                           visible: data.data != null && data.data > 0,
//                           child: Stack(
//                             children: [
//                               SvgPicture.asset(
//                                 "assets/icons/navigation/speed_limit.svg",
//                                 height: 80,
//                                 width: 80,
//                               ),
//                               Center(
//                                 child: Text(
//                                   (data.data * 3.6).round().toString(),
//                                   style: TextStyle(fontSize: 28),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       }),
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.bottomLeft,
//               child: StreamBuilder(
//                   stream: maneuverStream.stream,
//                   builder: (context, data) {
//                     return Visibility(
//                       visible: data?.data != null,
//                       child: NavDirectionWidget(data.data),
//                     );
//                   }),
//             ),
//             Align(
//               alignment: Alignment.bottomRight,
//               child: Padding(
//                 padding: EdgeInsets.fromLTRB(0, 0, 60, 16),
//                 child: StreamBuilder(
//                   stream: statusNavigationCon.stream,
//                   builder: (context, data) {
//                     return TextButton(
//                       child: Text(
//                         getButtonText(context, data?.data),
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       style: TextButton.styleFrom(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           side: BorderSide(),
//                         ),
//                         backgroundColor: getColorButton(data?.data),
//                       ),
//                       onPressed: () {
//                         switch (data.data) {
//                           case NavStatus.waitingRoute:
//                             showToast("Wait please".localize(context));
//                             break;
//                           case NavStatus.readyForNavigation:
//                             _navigationLogic.startNavigation(false);
//                             statusNavigationCon.add(NavStatus.started);
//                             break;
//                           case NavStatus.started:
//                             _navigationLogic.stopNavigation();
//                             statusNavigationCon.sink
//                                 .add(NavStatus.readyForNavigation);
//                             maneuverStream.sink.add(null);
//                             speedLimitStream.sink.add(null);
//                             _navSpeaker.stop();
//                             break;
//                           case NavStatus.error:
//                             showToast("Route problems".localize(context));
//                             break;
//                           default:
//                             showToast("Please wait".localize(context));
//                         }
//                       },
//                       onLongPress: () {
//                         if (data.data == NavStatus.readyForNavigation) {
//                           _navigationLogic.startNavigation(true);
//                           statusNavigationCon.add(NavStatus.started);
//                         } else {
//                           showToast("Simulation not started, you need stop");
//                         }
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ]),
//         );
//       },
//     );
//   }

//   Color getColorButton(NavStatus status) {
//     var color;
//     switch (status) {
//       case NavStatus.waitingRoute:
//         color = "F4F4F4".getColor();
//         break;
//       case NavStatus.readyForNavigation:
//         color = "FFEFDD".getColor();
//         break;
//       case NavStatus.started:
//         color = "E4F8FD".getColor();
//         break;
//       case NavStatus.error:
//         color = "F9E4EB".getColor();
//         break;
//       default:
//         color = "F4F4F4".getColor();
//     }
//     return color;
//   }

//   String getButtonText(BuildContext context, NavStatus status) {
//     String textButton;
//     switch (status) {
//       case NavStatus.waitingRoute:
//         textButton = "Please wait";
//         break;
//       case NavStatus.readyForNavigation:
//         textButton = "Go";
//         break;
//       case NavStatus.started:
//         textButton = "Stop";
//         break;
//       case NavStatus.error:
//         textButton = "Route problems";
//         break;
//       default:
//         textButton = "Please wait";
//     }
//     return textButton.localize(context);
//   }

//   Align button(String buttonLabel, Function callbackFunction) {
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.lightBlueAccent,
//         ),
//         onPressed: callbackFunction,
//         child: Text(buttonLabel,
//             style: TextStyle(fontSize: 20, color: Colors.white)),
//       ),
//     );
//   }

//   void _onMapCreated(HereMapController hereMapController) {
//     hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay,
//         (MapError error) {
//       if (error != null) {
//         print('Map scene not loaded. MapError: ${error.toString()}');
//         return;
//       } else {
//         _navigationLogic = NavigateNavigationLogic(
//           hereMapController,
//           maneuverStream,
//           speedLimitStream,
//           _navSpeaker,
//         );
//       }

//       initPositionMarkers();
//     });
//   }

//   initPositionMarkers() async {
//     var myPosition = await Geolocator.getCurrentPosition();
//     const double distanceToEarthInMeters = 8000;

//     _navigationLogic.hereMapController.camera.lookAtPointWithDistance(
//       model.endPosition,
//       distanceToEarthInMeters,
//     );

//     _navigationLogic.addCustomerMarker(model.endPosition, 0);
//     var calcRes = await _navigationLogic.calculateRoute(
//         GeoCoordinates(myPosition.latitude, myPosition.longitude),
//         model.endPosition);

//     print("Calculating route = $calcRes");
//     if (calcRes == null) {
//       statusNavigationCon.sink.add(NavStatus.readyForNavigation);
//     } else {
//       showToast(calcRes);
//     }
//   }

//   @override
//   void dispose() {
//     model = null;
//     _navigationLogic.stopNavigation();
//     statusNavigationCon.close();
//     maneuverStream.close();
//     speedLimitStream.close();
//     _navSpeaker.stop();
//     super.dispose();
//   }
// }

// enum NavStatus { waitingRoute, readyForNavigation, started, error }
