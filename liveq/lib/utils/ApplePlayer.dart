import 'package:flutter_sound/flutter_sound.dart';
import 'dart:async';
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

  void startSong(String uri) async {
    String path = await flutterSound.startPlayer(uri);
    await flutterSound.setVolume(1.0);


    try {
      _playerSubscription = flutterSound.onPlayerStateChanged.listen((e) async {
        if (e != null) {
          slider_current_position = e.currentPosition;
          max_duration = e.duration;

          final remaining = e.duration - e.currentPosition;

          DateTime date = DateTime.fromMillisecondsSinceEpoch(
              e.currentPosition.toInt(),
              isUtc: true);

          DateTime endDate = DateTime.fromMillisecondsSinceEpoch(
              remaining.toInt(),
              isUtc: true);

          String startText = DateFormat('mm:ss', 'en_GB').format(date);
          String endText = DateFormat('mm:ss', 'en_GB').format(endDate);

         
            
              this._startText = startText;
              this._endText = endText;
              this.slider_current_position = slider_current_position;
              this.max_duration = max_duration;
            
          
        } else {
          slider_current_position = 0;

          if (_playerSubscription != null) {
            _playerSubscription.cancel();
            _playerSubscription = null;
          }
          
            this._isPlaying = false;
            this._startText = '00:00';
            this._endText = '00:00';
          
        }
      });
    } catch (err) {
      print('error: $err');
      
        this._isPlaying = false;
      
    


  }
  }

  applePausePlayer() async {
    String result = await flutterSound.pausePlayer();
    this._isPlaying = false;
  }

  appleResumePlayer() async {
    String result = await flutterSound.resumePlayer();
    this._isPlaying = true;
  }



}