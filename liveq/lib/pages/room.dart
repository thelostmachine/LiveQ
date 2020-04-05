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

  Widget _queueListView(BuildContext context) {
    return ListView.builder(
        itemCount: queue.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(queue[index].trackName),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // final RoomArguments args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(args.roomID),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.music_note),
            onPressed: () => Navigator.pushNamed(context, '/services'),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => Navigator.pushNamed(context, '/search'),
          )
        ],
      ),
      body: Container(
        child: _queueListView(context),
      ),
    );
  }
}
