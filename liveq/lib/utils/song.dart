import 'package:flutter/material.dart';
import 'package:liveq/utils/services.dart';

class Song {
  String id;
  String uri;
  String trackName;
  String artists;
  int duration;
  String imageUri;

  Service service;
  Image cachedImage;

  Song(this.id, this.uri, this.trackName, this.artists, this.imageUri,
      this.duration, this.service);

  void cacheImage(Image image) {
    cachedImage = image;
  }

  static String parseDuration(Song song) {
    final double _temp = song.duration / 1000;
    final int _minutes = (_temp / 60).floor();
    final int _seconds = (((_temp / 60) - _minutes) * 60).round();
    String _duration;
    if (_seconds.toString().length > 1) {
      _duration = _minutes.toString() + ":" + _seconds.toString();
    } else {
      _duration = _minutes.toString() + ":0" + _seconds.toString();
    }
    return _duration;
  }

  // static String getDurationString(Song song) {
  //   return '${song.duration.inMinutes.remainder(60)}:${song.duration.inSeconds.remainder(60)}';
  // }

  @override
  String toString() {
    return '$trackName - $artists';
  }
}
