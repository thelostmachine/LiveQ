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
      alignment: Alignment.bottomCenter,
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      flex: 2,
                      child: GestureDetector(
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
                          width: double.infinity,
                          alignment: Alignment.centerLeft,
                          child: _state == PlayerState.playing
                              ? PauseIcon(
                                  color: Colors.white,
                                )
                              : PlayIcon(
                                  color: Colors.white,
                                ),
                        ),
                      ),
                    ),
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
                                _currentSong.trackName,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
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
                                _currentSong.artist,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
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
                      flex: 1,
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            if (_currentSong.uri == null) {
                              return;
                            }
                            // stream.skipMusic(_currentSong);
                          },
                          child: Container(
                              width: double.infinity,
                              alignment: Alignment.centerLeft,
                              child: SkipIcon(
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
