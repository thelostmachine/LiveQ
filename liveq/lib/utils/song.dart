import 'package:flutter/material.dart';
import 'package:liveq/utils/services.dart';

class Song {
  
  String id;
  String uri;
  String trackName;
  String artist;
  String imageUri;

  Duration duration;
  Service service;
  Image cachedImage;

  Song(this.id, this.uri, this.trackName, this.artist, this.imageUri, this.duration, this.service);

  void cacheImage(Image image) {
    cachedImage = image;
  }

  static String getDurationString(Song song) {
    return '${song.duration.inMinutes.remainder(60)}:${song.duration.inSeconds.remainder(60)}';
  }

  @override
  String toString() {
    return '$trackName - $artist';
  }
}