import 'package:flutter_sound/flutter_sound.dart';
import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart' show DateFormat;
import 'package:intl/date_symbol_data_local.dart';


class ApplePlayer {

  bool _isPlaying = false;
  StreamSubscription _playerSubscription;
  FlutterSound flutterSound;

  String _startText = '00:00';
  String _endText = '00:00';
  double slider_current_position = 0.0;
  double max_duration = 1.0;

  void initState() {
    

    flutterSound = FlutterSound();
    flutterSound.setSubscriptionDuration(0.01);
    flutterSound.setDbPeakLevelUpdate(0.8);
    flutterSound.setDbLevelEnabled(true);

    initializeDateFormatting();
  }



  _pausePlayer() async {
    String result = await flutterSound.pausePlayer();
    this._isPlaying = false;
  }

  _resumePlayer() async {
    String result = await flutterSound.resumePlayer();
    this._isPlaying = true;
  }



}