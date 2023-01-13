// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:here_sdk/navigation.dart';
// import 'package:here_sdk/routing.dart';
// import 'package:twsl_flutter/src/model/utils/extensions.dart';

// class NavDirectionWidget extends StatelessWidget {
//   final NavDirectionModel navDirectionModel;

//   NavDirectionWidget(this.navDirectionModel);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 160,
//       margin: EdgeInsets.all(16),
//       padding: EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.black26, width: 1),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             "Next maneuver: ".localize(context),
//             textAlign: TextAlign.center,
//           ),
//           Text(
//             navDirectionModel?.nextManeuver?.nextRoadTexts?.names
//                     ?.getDefaultValue() ??
//                 "Waiting direction",
//             textAlign: TextAlign.center,
//             style: TextStyle(fontWeight: FontWeight.w700),
//           ),
//           const SizedBox(height: 8),
//           Container(
//             width: 140,
//             height: 80,
//             decoration: BoxDecoration(
//               color: "FDBE01".getColor(),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Center(
//               child: SvgPicture.asset(
//                   "assets/icons/navigation/${getDirectionIconName(navDirectionModel?.maneuver?.toString()?.split(".")?.last)}.svg"),
//             ),
//           ),
//           Text(
//             (navDirectionModel.nextManeuverProgress.remainingDistanceInMeters
//                         .toString() ??
//                     "0") +
//                 " meters".localize(context),
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 18),
//           ),
//         ],
//       ),
//     );
//   }

//   String getDirectionIconName(String raw) {
//     if (raw.contains("left")) {
//       return "leftTurn";
//     } else if (raw.contains("right")) {
//       return "rightTurn";
//     } else {
//       return "direct";
//     }
//   }
// }

// class NavDirectionModel {
//   final ManeuverAction maneuver;
//   final Maneuver nextManeuver;
//   final ManeuverProgress nextManeuverProgress;

//   NavDirectionModel(
//     this.maneuver,
//     this.nextManeuver,
//     this.nextManeuverProgress,
//   );
// }
