import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped, paused, continued }

class NavSpeaker {
  FlutterTts flutterTts = FlutterTts();

  dynamic languages;
  String? language;
  double volume = 1;
  double pitch = 0.7;
  double rate = 0.6;
  bool isCurrentLanguageInstalled = false;

  TtsState ttsState = TtsState.stopped;

  Future<void> init(String lang) async {
    await flutterTts.setSharedInstance(true);
    await flutterTts
        .setIosAudioCategory(IosTextToSpeechAudioCategory.playAndRecord, [
      IosTextToSpeechAudioCategoryOptions.allowBluetooth,
      IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
      IosTextToSpeechAudioCategoryOptions.mixWithOthers
    ]);

    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);
    await flutterTts.setLanguage(lang);
  }

  Future speak(String text) async {
    var result = await flutterTts.speak(text);
    if (result == 1)
      ttsState =
          TtsState.playing; //setState(() => ttsState = TtsState.playing);
  }

  Future stop() async {
    var result = await flutterTts.stop();
    if (result == 1) ttsState = TtsState.stopped;
  }
}
