import 'package:liveq/utils/services.dart';

class Song {
  String id;
  String uri;
  String trackName;
  String artists;
  int duration;

  Service service;

  Song(this.id, this.uri, this.trackName, this.artists, this.duration,
      this.service);
}
