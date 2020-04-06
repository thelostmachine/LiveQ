import 'package:flutter/material.dart';
import 'package:liveq/utils/player.dart';
import 'package:liveq/pages/search.dart';
import 'package:liveq/utils/song.dart';
import 'package:liveq/utils/utils.dart';
import 'package:liveq/utils/services.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Room Name'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.music_note),
            onPressed: () => Navigator.pushNamed(context, '/services').then((didConnect) {
              if (didConnect) {
                setState(() {
                  player.isConnected = true;
                });
              }
            }),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => _searchSong(context),
          )
        ],
      ),
      body: PropertyChangeProvider(
        value: player,
        child: Column(
          children: <Widget>[
            Expanded(
              child: _queueListView(context),
            ),
            (player.isConnected)
              ? _musicPlayer(context)
              : _connectionStatus(context),
          ],
        )
      )
    );
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
          itemCount: queue.length,
          itemBuilder: (context, index) {
            Song track = queue[index];
            
            return ListTile(
              title: Text(track.trackName),
              subtitle: Text(track.artist),
              leading: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 44,
                  minHeight: 44,
                  maxWidth: 64,
                  maxHeight: 64,
                ),
                child: track.cachedImage
              ),
              trailing: Text(Song.getDurationString(track)),
            );
          }
        );
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
      )
    );
  }

  Widget _connectionStatus(BuildContext context) {
    return Container(
      height: 50,
      child: Text(
        (_availableServices != null)
          ? 'Connecting to ${listServices()}'
          : 'Connect a Streaming Service to enable the Music Player')
    );
  }

  String listServices() {
    String services = '';
    for (int i = 0; i < _availableServices.length; i++) {
      services += _availableServices[i] + ((i < _availableServices.length - 1) ? ', ' : '');
    }
    return services;
  }
}
