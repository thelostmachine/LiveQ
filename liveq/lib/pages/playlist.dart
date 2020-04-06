import 'package:flutter/material.dart';

import 'package:liveq/utils/song.dart';
import 'package:liveq/widgets/songtile.dart';

class Playlist extends StatelessWidget {
  Playlist({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Song>>(
        // stream: , subscribe to stream of songs
        builder: (BuildContext context, AsyncSnapshot<List<Song>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final List<Song> _queue = snapshot.data;

          return ListView.builder(
            key: PageStorageKey<String>("Playlist"),
            padding: const EdgeInsets.only(bottom: 150.0),
            physics: BouncingScrollPhysics(),
            itemCount: _queue.length,
            itemExtent: 110,
            itemBuilder: (BuildContext context, int index) {
              return SongTile(
                song: _queue[index],
              );
            },
          );
        },
      ),
    );
  }
}
