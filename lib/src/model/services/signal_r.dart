import 'package:logging/logging.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:twsl_flutter/src/app.dart';
import 'package:twsl_flutter/src/model/models/chat.dart';
import 'package:twsl_flutter/src/model/services/events.dart';

class SignalRSetup {
  final serverUrl = "https://twslapi.azurewebsites.net/chathub";
  late HubConnection _hubConnection;

  initSignalR(String token) async {
    print("Start init signalR");
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) {
      print('${rec.level.name}: ${rec.time}: ${rec.message}');
    });

    final hubPortLogger = Logger("SignalR - hub");
    final transportPortLogger = Logger("SignalR - transport");
    final httpOptions = new HttpConnectionOptions(
      logger: transportPortLogger,
      accessTokenFactory: () async => token,
      logMessageContent: true,
    );

    _hubConnection = HubConnectionBuilder()
        .withUrl(serverUrl, options: httpOptions)
        .configureLogging(hubPortLogger)
        .build();
    // _hubConnection
    //     .onclose((error) => print("Connection Closed, with error = $error"));
  }

  connectTo(String chatRoomId) async {
    print("SignalR connect");
    await _hubConnection.start();
    print("SignalR connect. After start, state = ${_hubConnection.state}");
    await _hubConnection.invoke("ConnectToGroups", args: [chatRoomId]);
    print(
        "SignalR connect. After connectToGroup, state = ${_hubConnection.state}");
    _hubConnection.on("ReceiveMessage", receiveMessage);
  }

  sendMessage(String message, String chatId) async {
    final result =
        await _hubConnection.invoke("SendMessage", args: [message, chatId]);
    Logger.root.log(Level.ALL, "Result: $result");
  }

  void receiveMessage(List? parameters) {
    print("received message = $parameters");
    Logger.root.log(Level.ALL, "Server invoked the method $parameters");
    eventBus.fire(MessageEvent(ItemChat.fromMap(parameters!.first)));
  }

  stopConnection() {
    _hubConnection.stop();
  }
}
