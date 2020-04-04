import 'package:flutter/material.dart';
import 'package:liveq/utils/player.dart';
import 'package:liveq/utils/song.dart';
import 'package:liveq/pages/search.dart';

class Room extends StatefulWidget {

  @override
  _RoomState createState() => _RoomState();
}

class _RoomState extends State<Room> {

  Song currentlyPlaying;
  List<Song> queue = List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room Name'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.music_note),
            onPressed: () => Navigator.pushNamed(context, '/services'),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => _searchSong(context),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _queueListView(context),
          ),
          _musicPlayer(context),
        ],
      )
    );
  }

  void _searchSong(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Search()
      )
    );

    if (result != null) {
      setState(() {
        queue.add(result);
      });
    }
  }

  Widget _queueListView(BuildContext context) {
    return ListView.builder(
      itemCount: queue.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(queue[index].trackName),
          subtitle: Text(queue[index].artist),
          trailing: Text(queue[index].service.name),
        );
      }
    );
  }

  /// The Music Player
  Widget _musicPlayer(BuildContext context) {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            onPressed: () => Player.resume(),
            child: Text('Play')
          ),
          RaisedButton(
            onPressed: () => Player.pause(),
            child: Text('Pause')
          ),
          RaisedButton(
            onPressed: () {
              setState(() {
                if (queue.length > 0) {
                  Player.play(queue.removeAt(0));
                }
              });
            },
            child: Text('Next')
          ),
        ],
      )
    );
  }
}