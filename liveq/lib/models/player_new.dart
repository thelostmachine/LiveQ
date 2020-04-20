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
  Service searchService;

  // Set of services allowed in the room
  Set<Service> allowedServices =
      {}; // passed in through server data for guest/host?

  List<Song> queue = List();

  bool isConnected =
      false; // Set true when all services in allowedServices are connected
  PlayerState state = PlayerState.stopped;

  // static final Player _player = Player._internal();

  // Player._internal();

  // factory Player() {
  //   return _player;
  // }

  void addSong(Song song) {
    client.AddSong(song);
  }

  Song getNextSong() {
    Song next = queue[0];
    client.DeleteSong(next);

    return next;
  }

  loadQueue() async {
    client.GetQueue().then((q) {
      if (q != null) {
        queue = q;
        notifyListeners();
      }
    });
  }

  Future play(Song song) async {
    if (song != null) {
      _currentSong = song;
      _currentService = song.service;

      String uri = _currentSong.uri;
      if (_currentService is SoundCloud) {
        uri = song.id;
      }
      state = PlayerState.playing;

      return _currentSong.service.play(uri);
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

  void setService(Service service) {
    client.AddService(service.name);
    _currentService = service;
    // searchService = service;
    // isConnected = true;
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
      // play(_currentSong);
      state = PlayerState.playing;
      return play(_currentSong);
    }

    return null;
  }

  // Calls when song is finished playing
  void onComplete() {
    next();
  }

  void connect(Service service) async {
    service.connect();
    setService(service);
  }

  Future<List<Song>> search(String query) async {
    print('searching with ${searchService.name}');
    return searchService.search(query);
  }
}
