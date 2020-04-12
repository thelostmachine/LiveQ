import 'package:flutter/material.dart';
import 'package:liveq/utils/services.dart';
import 'package:liveq/utils/utils.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

import 'song.dart';

enum ModelProperties {
  queue,
}

class Player extends PropertyChangeNotifier<ModelProperties> {
  Song _currentSong;
  Service _currentService;
  Service searchService;

  // Set of services allowed in the room
  // Set<Service> allowedServices; // passed in through server data for guest/host?

  /// List of services we can connect to
  get potentialServices {
    return Service.potentialServices;
  }

  /// Set of services we are connected to
  Set<Service> get connectedServices {
    return Service.connectedServices;
  }

  // Service get _currentService {
  //   __currentService.isConnected.then((connected) {
  //     if (!connected) {
  //       __currentService.connect();
  //     }

  //   });

  //   return __currentService;
  // }

  // set _currentService(Service service) {
  //   __currentService = service;
  // }

  List<Song> queue = List();

  PlayerState state = PlayerState.stopped;

  static final Player _player = Player._internal();

  Player._internal();

  factory Player() {
    return _player;
  }

  void addSong(Song song) {
    queue.add(song);
    notifyListeners(ModelProperties.queue);
  }

  Song getNextSong() {
    Song next = queue.removeAt(0);
    notifyListeners(ModelProperties.queue);
    return next;
  }

  void play(Song song) async {
    if (song != null) {
      _currentSong = song;
      _currentService = _currentSong.service;
      _currentService.play(_currentSong.uri);
      state = PlayerState.playing;
    }
    // else {
    //   resume();
    // }
  }

  void resume() {
    _currentService.resume();
    state = PlayerState.playing;
  }

  void pause() {
    _currentService.pause();
    state = PlayerState.paused;
  }

  PlayerState getPlayerState() {
    return state;
  }

  void setService(Service service) {
    _currentService = service;
  }

  bool isConnected() {
    return _currentService.isConnected;
  }

  void next() async {
    if (queue != null && queue.isNotEmpty) {
      Song nextSong = getNextSong();

      // Stop playing the current song on the current service if we're switching Services
      if (_currentService != nextSong.service) {
        _currentService.pause();
      }

      _currentSong = nextSong;
      _currentService = _currentSong.service;
      _currentService.play(_currentSong.uri);
      state = PlayerState.playing;
    }
    // else {
    //   resume();
    // }
  }

  // Calls when song is finished playing
  void onComplete() {
    _currentService.pause();
    state = PlayerState.stopped;
    next();
  }

  Future<List<Song>> search(String query) async {
    return searchService.search(query);
  }

  void connectToCachedServices(VoidCallback callback) async {
    Service.canConnectToPreviousService().then(
      (availableServices) async {
        if (availableServices != null) {
          Service firstServiceInList = await Service.loadServices();
          setService(firstServiceInList);

          callback();
        }
      },
    );
  }
}
