import 'song.dart';

class Player {

  static Song currentlyPlaying;

  static void play(Song song) async {
    if (song != null) {
      currentlyPlaying = song;
      currentlyPlaying.service.playTrack(currentlyPlaying.uri);
    }
  }
  
  // TODO: don't depend on currentlyPlaying to get the service
  static void resume() {
    currentlyPlaying.service.resume();
  }

  static void pause() {
    currentlyPlaying.service.pause();
  }
}