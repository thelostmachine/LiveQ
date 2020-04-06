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

  static PlayerState getPlayerState() {
    return state;
  }

  static void setService(Service service) {
    currentService = service;
  }
}