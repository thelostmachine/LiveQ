import 'package:liveq/utils/services.dart';
import 'package:liveq/utils/utils.dart';

import 'song.dart';

class Player {
  static Song currentlyPlaying;
  static Service currentService;
  static bool isConnected = false;
  static PlayerState state = PlayerState.stopped;

  static void play(Song song) async {
    if (song != null) {
      currentlyPlaying = song;
      currentlyPlaying.service.playTrack(currentlyPlaying.uri);
      state = PlayerState.playing;
    } else {
      resume();
    }
  }

  static void resume() {
    currentService.resume();
    state = PlayerState.playing;
  }

  static void pause() {
    currentService.pause();
    state = PlayerState.paused;
  }

  static void stop() {
    // currentlyPlaying.service.stop();
    state = PlayerState.stopped;
  }

  static void skip() {
    // currentlyPlaying.service.stop();
    state = PlayerState.stopped;

    // delete first song in playlist list
    // if playlist is empty return
    // else get song at first index

    // currentlyPlaying.service.playTrack();
    // state = PlayerState.playing;
  }

  static PlayerState getPlayerState() {
    return state;
  }

  static void setService(Service service) {
    currentService = service;
  }
}
