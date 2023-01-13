import 'package:firebase_messaging/firebase_messaging.dart';

// firebaseMessagingInit(FirebaseMessaging messaging) {
//   messaging.configure(
//     onMessage: (Map<String, dynamic> message) async {
//       print("onMessage: $message");
//       if (message.containsKey('trackId')) {
//         PushSM ph = PushSM(message['trackId'], null);
//         print("Push before event second (ios) = $ph");
//         eventBus.fire(PushEvent(ph));
//       } else if (message['data'].containsKey('trackId')) {
//         PushSM ph = PushSM(
//             message['data']['trackId'],
//             // ignore: todo
// ignore: todo
//             null); // DeliveryStatusResources.converterStringToStatus(message['data']['orderStatus']),); //TODO it's unreal, it's not work how are want
//         print("Push before event second = $ph");
//         eventBus.fire(PushEvent(ph));
//       } else {
//         print("Message not is contains trackId");
//       }
//     },
//     onLaunch: (Map<String, dynamic> message) async {
//       print("onLaunch: $message");
//       // _navigateToItemDetail(message);
//     },
//     onResume: (Map<String, dynamic> message) async {
//       print("onResume: $message");
//       // _navigateToItemDetail(message);
//     },
//   );
// }
