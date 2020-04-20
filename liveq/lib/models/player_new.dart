import 'package:flutter/material.dart';
import 'package:liveq/utils/client_interface.dart';
import 'package:liveq/utils/services.dart';
import 'package:liveq/utils/utils.dart';
import 'package:liveq/utils/song.dart';

class PlayerModel with ChangeNotifier {
  Song currentSong;
  Service currentService;

  List<Song> queue = List();

  PlayerState state = PlayerState.stopped;

  Song getNextSong() {
    Song next = queue[0];
    client.DeleteSong(next);
    return next;
  }

  void play(Song song) async {
    if (song != null) {
      currentSong = song;
      currentService = song.service;

      String uri = currentSong.uri;
      if (currentService is SoundCloud) {
        uri = song.id;
      }
      currentSong.service.play(uri);
      state = PlayerState.playing;
    } else {
      resume();
    }
    notifyListeners();
  }

  void resume() {
    currentService.resume();
    state = PlayerState.playing;
    notifyListeners();
  }

  void pause() {
    currentService.pause();
    state = PlayerState.paused;
    notifyListeners();
  }

  void setCurrentService(Service service) {
    // client.AddService(service.name);
    currentService = service;
    // isConnected = true;
    notifyListeners();
  }

  void next() async {
    if (queue != null && queue.isNotEmpty) {
      Song nextSong = getNextSong();

      // Stop playing the current song on the current service if we're switching Services
      if (currentService != nextSong.service) {
        pause();
      }

      currentSong = nextSong;
      currentService = currentSong.service;
      play(currentSong);
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

  void loadQueue() async {
    client.GetQueue().then((q) {
      if (q != null) {
        queue = q;
      }
    });
    notifyListeners();
  }
}
