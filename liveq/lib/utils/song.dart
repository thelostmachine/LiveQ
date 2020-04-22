import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    String format = '';
    if (song.duration >= (3600000 * 10)) {
      format = 'HH:mm:ss';
    }
    else if (song.duration > 3600000) {
      format = 'H:mm:ss';
    }
    else if (song.duration >= 600000) {
      format = 'mm:ss';
    }
    else {
      format = 'm:ss';
    }

    final formatter = DateFormat(format);
    return formatter.format(DateTime.fromMillisecondsSinceEpoch(song.duration).toUtc());
  }

  @override
  String toString() {
    return '$trackName\n$id\n$uri\n$artists\n$duration\n$imageUri\n\n';
  }
}
