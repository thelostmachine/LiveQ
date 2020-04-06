import 'package:flutter/material.dart';

import 'package:liveq/pages/search.dart';
import 'package:liveq/utils/player.dart';
import 'package:liveq/utils/song.dart';
import 'package:liveq/utils/utils.dart';
import 'package:liveq/utils/services.dart';
import 'package:liveq/widgets/songtile.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class Room extends StatefulWidget {
  @override
  _RoomState createState() => _RoomState();
}

class _RoomState extends State<Room> {
  RoomArguments args;
  List<String> _availableServices;
  Player player = Player();

  @override
  void initState() {
    super.initState();
    // TODO: Change quick hack to set args - reference: https://stackoverflow.com/questions/56262655/flutter-get-passed-arguments-from-navigator-in-widgets-states-initstate
    Future.delayed(Duration.zero, () {
      setState(() {
        args = ModalRoute.of(context).settings.arguments;
      });
    });

    // if host send createRequest; else send joinRequest
    // initialize and subscribe to server stream of songs in queue

    Service.canConnectToPreviousService().then((availableServices) {
      if (availableServices != null) {
        setState(() {
          _availableServices = availableServices;
        });

        Service.loadServices().then((service) {
          player.setService(service);

          setState(() {
            player.isConnected = true;
          });
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final RoomArguments args = ModalRoute.of(context).settings.arguments;
    final double _radius = 25.0;
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: Scaffold(
        appBar: AppBar(
          // title: Text(args.roomName),
          title: Text('Room Name'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.music_note),
              onPressed: () => Navigator.pushNamed(context, '/connect_services')
                  .then((didConnect) {
                if (didConnect) {
                  setState(() {
                    player.isConnected = true;
                  });
                }
              }),
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
        body: PropertyChangeProvider(
          value: player,
          child: Column(
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
                  child: (player.isConnected)
                      ? _musicPlayer(context)
                      : _connectionStatus(context), //MusicPlayer(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure'),
            content: const Text('Do you want to exit?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('NO'),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('YES'),
              ),
            ],
          ),
        )) ??
        false;
  }

  void _searchSong(BuildContext context) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => Search()));

    if (result != null) {
      player.addSong(result);
    }
  }

  Widget _queueListView(BuildContext context) {
    return PropertyChangeConsumer<Player>(
      properties: [ModelProperties.queue],
      builder: (context, model, properties) {
        var queue = model.queue;
        return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: queue.length,
            itemBuilder: (context, index) {
              // Song track = queue[index];

              // return ListTile(
              //   title: Text(track.trackName),
              //   subtitle: Text(track.artists),
              //   leading: ConstrainedBox(
              //       constraints: BoxConstraints(
              //         minWidth: 44,
              //         minHeight: 44,
              //         maxWidth: 64,
              //         maxHeight: 64,
              //       ),
              //       child: track.cachedImage),
              //   trailing: Text(Song.parseDuration(track)),
              // );
              return SongTile(song: queue[index]);
            });
      },
    );
  }

  /// The Music Player
  Widget _musicPlayer(BuildContext context) {
    return Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(onPressed: () => player.resume(), child: Text('Play')),
            RaisedButton(onPressed: () => player.pause(), child: Text('Pause')),
            RaisedButton(onPressed: () => player.next(), child: Text('Next')),
          ],
        ));
  }

  Widget _connectionStatus(BuildContext context) {
    return Container(
      height: 50,
      child: Text((_availableServices != null)
          ? 'Connecting to ${listServices()}'
          : 'Connect a Streaming Service to enable the Music Player'),
    );
  }

  String listServices() {
    String services = '';
    for (int i = 0; i < _availableServices.length; i++) {
      services += _availableServices[i] +
          ((i < _availableServices.length - 1) ? ', ' : '');
    }
    //return _availableServices.join(", ");
    return services;
  }
}
