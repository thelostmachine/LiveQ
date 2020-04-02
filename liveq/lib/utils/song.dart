

import 'package:liveq/utils/utils.dart';

class Song {
  
  String id;
  String uri;
  String trackName;
  String artist;

  Service service;

  Song(this.id, this.uri, this.trackName, this.artist, this.service);
}