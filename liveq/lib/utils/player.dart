import 'package:liveq/utils/utils.dart';

import 'song.dart';

class Player {

  static Song currentlyPlaying;
  static PlayerState state = PlayerState.stopped;

  static void play(Song song) async {
    if (song != null) {
      currentlyPlaying = song;
      currentlyPlaying.service.playTrack(currentlyPlaying.uri);
      state = PlayerState.playing;
    }
  }
  
  // TODO: don't depend on currentlyPlaying to get the service
  static void resume() {
    currentlyPlaying.service.resume();
    state = PlayerState.playing;
  }

  static void pause() {
    currentlyPlaying.service.pause();
    state = PlayerState.paused;
  }

  static PlayerState getPlayerState() {
    return state;
  }
}