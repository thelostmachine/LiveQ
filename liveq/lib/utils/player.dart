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
}
