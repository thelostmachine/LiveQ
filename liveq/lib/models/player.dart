import 'package:flutter/material.dart';
import 'package:liveq/utils/api.dart';

// import 'package:liveq/utils/client_interface.dart';
import 'package:liveq/utils/services.dart';
import 'package:liveq/utils/utils.dart';
import 'package:liveq/utils/song.dart';

class PlayerModel with ChangeNotifier {
  Song currentSong;
  Service currentService;
  bool songComplete = false;

  List<Song> queue = List();

  RoomPlayerState state = RoomPlayerState.stopped;

  void dispose() {
    if (currentService != null) {
      pause();
    }
    super.dispose();
  }

  Song getNextSong() {
    Song next = queue[0];
    Api.deleteSong(next);
    return next;
  }

  void play(Song song) async {
    if (song != null) {
      if (song != currentSong) {
        currentSong = song;
        currentService = song.service;

        String uri = currentSong.uri;
        if (currentService is SoundCloud) {
          uri = song.trackId;
        }
        currentService.play(uri, this);
        print('playing');
        state = RoomPlayerState.playing;
      } else {
        resume();
      }
    }
    notifyListeners();
  }

  void resume() {
    currentService.resume();
    state = RoomPlayerState.playing;
    notifyListeners();
  }

  void pause() {
    currentService.pause();
    state = RoomPlayerState.paused;
    notifyListeners();
  }

  void setCurrentService(Service service) {
    // client.AddService(service.name);
    currentService = service;
    // isConnected = true;
    notifyListeners();
  }

  void next() async {
    if (currentService != null) {
      pause();
    }
    if (queue.isNotEmpty) {
      Song nextSong = getNextSong();

      // // Stop playing the current song on the current service if we're switching Services
      // if (currentService != nextSong.service) {
      // pause();
      // }

      // currentSong = nextSong;
      // currentService = currentSong.service;
      play(nextSong);
      state = RoomPlayerState.playing;
      // return play(_currentSong);
    } else {
      // if (currentService != null) {
      //   pause();
      // }
      currentSong = null;
      state = RoomPlayerState.stopped;
    }
    notifyListeners();
    // return null;
  }

  // Calls when song is finished playing
  void onComplete() {
    // songComplete = true;
    if (queue.isNotEmpty) {
      next();
    } else {
      currentSong = null;
      state = RoomPlayerState.stopped;
    }
    notifyListeners();
  }

  void loadQueue() async {
    Api.getQueue().then((q) {
      if (q != null) {
        queue = q;
      }
    });
    notifyListeners();
  }
}
