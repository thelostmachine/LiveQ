import 'package:flutter/material.dart';
import 'package:liveq/utils/client.dart';
import 'package:liveq/utils/services.dart';
import 'package:liveq/utils/utils.dart';
import 'package:liveq/utils/song.dart';

import 'package:property_change_notifier/property_change_notifier.dart';

enum ModelProperties {
  queue,
  soundcloudTrack,
}

class PlayerModel with ChangeNotifier {
  Song _currentSong;
  Service _currentService;

  List<Song> queue = List();

  bool isConnected =
      false; // Set true when all services in allowedServices are connected
  PlayerState state = PlayerState.stopped;

  void addSong(Song song) {
    client.AddSong(song);
  }

  Song getNextSong() {
    Song next = queue[0];
    client.DeleteSong(next);

    return next;
  }

  void play(Song song) async {
    if (song != null) {
      _currentSong = song;
      _currentService = song.service;

      String uri = _currentSong.uri;
      if (_currentService is SoundCloud) {
        uri = song.id;
      }
      _currentSong.service.play(uri);
      state = PlayerState.playing;
    } else {
      resume();
    }
    notifyListeners();
  }

  void resume() {
    _currentService.resume();
    state = PlayerState.playing;
    notifyListeners();
  }

  void pause() {
    _currentService.pause();
    state = PlayerState.paused;
    notifyListeners();
  }

  PlayerState getPlayerState() {
    return state;
  }

  void setCurrentService(Service service) {
    // client.AddService(service.name);
    _currentService = service;
    // isConnected = true;
    notifyListeners();
  }

  void next() async {
    if (queue != null && queue.isNotEmpty) {
      Song nextSong = getNextSong();

      // Stop playing the current song on the current service if we're switching Services
      if (_currentService != nextSong.service) {
        pause();
      }

      _currentSong = nextSong;
      _currentService = _currentSong.service;
      play(_currentSong);
      state = PlayerState.playing;
      // return play(_currentSong);
    }
    notifyListeners();
    // return null;
  }

  // Calls when song is finished playing
  void onComplete() {
    next();
    notifyListeners();
  }
}
