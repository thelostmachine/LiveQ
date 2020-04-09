import 'package:flutter/material.dart';
import 'package:liveq/utils/client.dart';
import 'package:liveq/utils/services.dart';
import 'package:liveq/utils/utils.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

import 'song.dart';

enum ModelProperties {
  queue,
  soundcloudTrack,
}

class Player extends PropertyChangeNotifier<ModelProperties> {
  Song _currentSong;
  Service _currentService;
  Service searchService;
  // List<Service> allowedServices; // passed in through server data for guest/host?

  /// List of services we can connect to
  get potentialServices {
    return Service.potentialServices;
  }

  /// List of services we are connected to
  List<Service> get connectedServices {
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

  bool isConnected = false;
  PlayerState state = PlayerState.stopped;

  static final Player _player = Player._internal();

  Player._internal();

  factory Player() {
    return _player;
  }

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
        notifyListeners(ModelProperties.queue);
      }
    });
  }

  Future play(Song song) async {
    if (song != null) {
      _currentSong = song;
      _currentService = song.service;
      state = PlayerState.playing;

      return _currentSong.service.play(_currentSong.uri);
    } else {
      resume();
    }
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
    client.AddService(service.name);
    _currentService = service;
    searchService = service;
    isConnected = true;
  }

  Future next() async {
    if (queue != null && queue.length > 0) {
      Song nextSong = getNextSong();

      // Stop playing the current song on the current service if we're switching Services
      if (_currentService != nextSong.service) {
        _currentService.pause();
      }

      return play(nextSong);
    }

    return null;
  }

  void connect(Service service) async {
    service.connect();
    setService(service);
  }

  Future<List<Song>> search(String query) async {
    print('searching with ${searchService.name}');
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
