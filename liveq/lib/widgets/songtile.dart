import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:liveq/utils/song.dart';

class SongTile extends StatelessWidget {
  final Song _song;
  final VoidCallback _onTap;

  SongTile({Key key, @required Song song, onTap})
      : _song = song,
        _onTap = onTap,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    String _duration = Song.parseDuration(_song);
    if (_song.imageUri == null) {
      print(_song.trackName);
    }
    return ListTile(
      leading: FadeInImage.memoryNetwork(
        placeholder: kTransparentImage,
        image: _song.imageUri,
        fit: BoxFit.contain,
      ),
      title: Text(
        _song.trackName,
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        _song.artists,
        style: TextStyle(
          color: Color(0xFFADB9CD),
          // letterSpacing: 1,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        _duration,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF94A6C5),
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: _onTap,
    );
  }
}
