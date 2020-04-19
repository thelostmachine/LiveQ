import 'package:flutter/material.dart';

import 'package:liveq/widgets/music_icons.dart';
import 'package:liveq/utils/song.dart';
import 'package:liveq/utils/utils.dart';

class PlayerPanel extends StatelessWidget {
  PlayerPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
      child: StreamBuilder<MapEntry<PlayerState, Song>>(
        // stream: , // suscribe to playerstate stream
        builder: (BuildContext context,
            AsyncSnapshot<MapEntry<PlayerState, Song>> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          final PlayerState _state = snapshot.data.key;
          final Song _currentSong = snapshot.data.value;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListTile(
              leading: GestureDetector(
                onTap: () {
                  if (_currentSong.uri == null) {
                    return;
                  }
                  if (PlayerState.paused == _state) {
                    // stream.playMusic(_currentSong);
                  } else {
                    // stream.pauseMusic(_currentSong);
                  }
                },
                child: Container(
                  child: _state == PlayerState.playing
                      ? PauseIcon(
                          color: Colors.white,
                        )
                      : PlayIcon(
                          color: Colors.white,
                        ),
                ),
              ),
              title: Text(
                _currentSong.trackName,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                _currentSong.artists,
                style: TextStyle(
                  color: Colors.white,
                  // letterSpacing: 1,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: GestureDetector(
                onTap: () {
                  if (_currentSong.uri == null) {
                    return;
                  }
                  // stream.skipMusic(_currentSong);
                },
                child: Container(
                  child: SkipIcon(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
