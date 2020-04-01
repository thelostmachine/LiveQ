import 'package:flutter/material.dart';
import 'package:liveq/utils/song.dart';
import 'package:liveq/utils/utils.dart';

class Room extends StatefulWidget {

  @override
  _RoomState createState() => _RoomState();
}

class _RoomState extends State<Room> {

  List<Song> queue = [
    Song('1', 'hello', 'divinity', 'porter', Service.Spotify),
    Song('2', 'howdy', 'sound of walking away', 'illenium', Service.Spotify),
  ];

  Widget _queueListView(BuildContext context) {
    return ListView.builder(
      itemCount: queue.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(queue[index].trackName),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.music_note),
            onPressed: () => Navigator.pushNamed(context, "/services"),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => Navigator.pushNamed(context, "/search"),
          )
        ],
      ),
      body: Container(
        child: _queueListView(context),
      ),
    );
  }
}