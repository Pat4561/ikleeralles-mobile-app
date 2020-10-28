import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:ikleeralles/network/api/url.dart';


class SpeechException implements Exception {

  final String reason;

  SpeechException (this.reason);

}

class SpeechPlayer {

  final AudioPlayer audioPlayer = AudioPlayer();

  final String language;

  SpeechPlayer ({ @required this.language });

  Future play(String word) async {
    String url = "${ApiUrl.host}/speech/$language/$word";
    url = Uri.encodeFull(url);
    var result = await audioPlayer.play(url);
    if (result != 1) {
      throw SpeechException("Could not be played, not correct result returned");
    }
  }

}
