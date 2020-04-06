import 'package:flutter/material.dart';

import 'package:liveq/utils/song.dart';
import 'package:liveq/utils/utils.dart';

class SongTile extends StatelessWidget {
  final Song _song;
  String _duration;

  SongTile({Key key, @required Song song})
      : _song = song,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    parseDuration();
    return ListTile(
      title: Text(
        _song.trackName,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        _song.artists,
        style: TextStyle(
          fontSize: 16,
          color: Color(0xFFADB9CD),
          letterSpacing: 1,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        _duration,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF94A6C5),
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  void parseDuration() {
    // final double _temp = _song.duration / 1000;
    // final int _minutes = (_temp / 60).floor();
    // final int _seconds = (((_temp / 60) - _minutes) * 60).round();
    // if (_seconds.toString().length > 1) {
    //   _duration = _minutes.toString() + ":" + _seconds.toString();
    // } else {
    //   _duration = _minutes.toString() + ":0" + _seconds.toString();
    // }
  }
}
