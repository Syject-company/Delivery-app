import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:twsl_flutter/src/app.dart';
import 'package:twsl_flutter/src/model/models/chat.dart';
import 'package:twsl_flutter/src/model/preferences/preferences.dart';
import 'package:twsl_flutter/src/model/repository/repository.dart';
import 'package:twsl_flutter/src/model/services/events.dart';
import 'package:twsl_flutter/src/model/services/signal_r.dart';

class ChatModel extends ChangeNotifier {
  final Repository _repository;
  final Preferences _prefs;
  late SignalRSetup _signalR;

  var scrollController = ScrollController();
  var editTextMessageEdCon = TextEditingController();

  StreamController resultMessageController = BehaviorSubject();

  String? orderId;
  ChatRoomInfo? chatRoomInfo;
  List<ItemChat>? messages = [];

  ChatModel(this._repository, this._prefs);

  getChatRoomInfo() async {
    _repository.getChatRoomInfo(orderId, (result, status) async {
      if (status.isSuccessful) {
        chatRoomInfo = result;
        await connectToSocket();
        getMessagesList();
        notifyListeners();
      }
      resultMessageController.sink.add(status);
    });
  }

  getMessagesList() {
    _repository.getChatMessages(chatRoomInfo!.chatRoomId, (result, status) {
      if (status.isSuccessful) {
        messages = result;
        notifyListeners();
      }
      resultMessageController.sink.add(status);
    });
  }

  connectToSocket() async {
    var token = await _prefs.getToken();
    if (token == null || token.isEmpty) {
      token = await _prefs.getCustomerToken();
    }

    _signalR = SignalRSetup();
    await _signalR.initSignalR(token);
    await _signalR.connectTo(chatRoomInfo!.chatRoomId!);
    subscribeOnReceiveMessages();
  }

  sendMessage() {
    _signalR.sendMessage(editTextMessageEdCon.text, chatRoomInfo!.chatRoomId!);
  }

  subscribeOnReceiveMessages() {
    eventBus.on<MessageEvent>().listen((event) {
      event.message.isMyMessage =
          event.message.applicationUserId != chatRoomInfo!.receiverId;
      messages!.add(event.message);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    editTextMessageEdCon.dispose();
    resultMessageController.close();
    _signalR.stopConnection();
    super.dispose();
  }
}
