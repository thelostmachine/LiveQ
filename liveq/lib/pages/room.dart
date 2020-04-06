import 'package:flutter/material.dart';

import 'package:liveq/utils/player.dart';
import 'package:liveq/utils/song.dart';
import 'package:liveq/pages/search.dart';
import 'package:liveq/utils/utils.dart';

class Room extends StatefulWidget {
  @override
  _RoomState createState() => _RoomState();
}

class _RoomState extends State<Room> {
  RoomArguments args;

  @override
  void initState() {
    super.initState();
    // TODO: Change quick hack to set args - reference: https://stackoverflow.com/questions/56262655/flutter-get-passed-arguments-from-navigator-in-widgets-states-initstate
    Future.delayed(Duration.zero, () {
      setState(() {
        args = ModalRoute.of(context).settings.arguments;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Song currentlyPlaying;
  List<Song> queue = List();

  @override
  Widget build(BuildContext context) {
    final double _radius = 25.0;
    // final RoomArguments args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          // title: Text(args.roomName),
          title: Text('Room Name'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.music_note),
              onPressed: () =>
                  Navigator.pushNamed(context, '/connect_services'),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: Icon(Icons.search),
                onPressed: () => _searchSong(context),
              ),
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: _queueListView(context),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(_radius),
                    topRight: Radius.circular(_radius),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [
                      0.0,
                      0.7,
                    ],
                    colors: [
                      Color(0xFF47ACE1),
                      Color(0xFFDF5F9D),
                    ],
                  ),
                ),
                child: _musicPlayer(context), //MusicPlayer(),
              ),
            ),
          ],
        ));
  }

  void _searchSong(BuildContext context) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => Search()));

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
        });
  }

  /// The Music Player
  Widget _musicPlayer(BuildContext context) {
    return Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(onPressed: () => Player.resume(), child: Text('Play')),
            RaisedButton(onPressed: () => Player.pause(), child: Text('Pause')),
            RaisedButton(
                onPressed: () {
                  setState(() {
                    if (queue.length > 0) {
                      Player.play(queue.removeAt(0));
                    }
                  });
                },
                child: Text('Next')),
          ],
        ));
  }
}
