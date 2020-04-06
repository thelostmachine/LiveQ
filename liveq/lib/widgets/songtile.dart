import 'package:flutter/material.dart';

import 'package:liveq/utils/song.dart';
import 'package:liveq/utils/utils.dart';

class SongTile extends StatelessWidget {
  final Song _song;
  String _artists;
  String _duration;
  SongTile({Key key, @required Song song})
      : _song = song,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    _artists = _song.artist;
    return Container(
      height: 110,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Divider(
              color: Colors.transparent,
              height: 5,
            ),
            Row(
              children: <Widget>[
                Flexible(
                  flex: 8,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _song.trackName,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Divider(
                            height: 10,
                            color: Colors.transparent,
                          ),
                          Text(
                            _artists.toUpperCase(),
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFFADB9CD),
                              letterSpacing: 1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.centerRight,
                    child: Text(
                      _duration,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF94A6C5),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
