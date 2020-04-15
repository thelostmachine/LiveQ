import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:liveq/pages/search.dart';
import 'package:liveq/utils/player.dart';
import 'package:liveq/utils/services.dart';
import 'package:liveq/utils/utils.dart';
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
  // Flag that shows whether we are connected to the server and server's room
  bool _connectedToServer; // = false
  bool _connectedToServices = false;

  @override
  void initState() {
    super.initState();
    // TODO: Quick hack to set args - reference: https://stackoverflow.com/questions/56262655/flutter-get-passed-arguments-from-navigator-in-widgets-states-initstate
    Future.delayed(Duration.zero, () {
      setState(() {
        args = ModalRoute.of(context).settings.arguments;
      });

      print('INITSTATE');
      if (args != null) {
        // if host send createRoom; else send joinRoom
        // If received response from server, set connectedToServer=true - FutureBuilder success
        // On response failure, show 'failed to connect to server room' error message - FutureBuilder failure
        // Set args.roomName and args.roomID received from server

        // initialize and subscribe to server stream of songs in queue

        // if host then connect to services
        // set player.allowedServices.addAll(Service.connectedServices); // for guest, need to receive services from server
        player.allowedServices.addAll(Service.connectedServices);
        player.connectToServices(() {
          setState(() {
            _connectedToServices = true;
          });
        });
      }
    });
  }

  @override
  void dispose() {
    // Disconnect from services
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final RoomArguments args = ModalRoute.of(context).settings.arguments;
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: Scaffold(
        appBar: AppBar(
          // connectedToServer == true
          title: (args != null && args.roomName != null)
              ? Text(args.roomName)
              : const Text(''),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              // connectedToServer == true
              onPressed: () => _searchSong(context),
            ),
            // connectedToServer == true
            (player.searchService != null &&
                    player.searchService.isConnected ==
                        true) // player.allowedServices.contains(player.searchService)
                ? IconButton(
                    icon: player.searchService.getImageIcon(),
                    onPressed: player.allowedServices.length > 1
                        ? () => _selectSearchService()
                        : null,
                  )
                : IconButton(
                    icon: Icon(Icons.music_note),
                    onPressed: player.allowedServices
                            .isNotEmpty // && connectedToServices == true
                        ? () => _selectSearchService()
                        : null,
                  ),
            IconButton(
              icon: Icon(Icons.share),
              // connectedToServer == true
              onPressed: (args != null && args.roomID != null)
                  ? () => _roomCodeDialog()
                  : null,
            ),
          ],
        ),
        body: _roomBody(),
      ),
    );
  }

  Widget _roomBody() {
    final double _radius = 25.0;
    return args != null
        // TODO: Add FutureBuilder to display status of connecting to server
        ? PropertyChangeProvider(
            value: player,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: _queueListView(context),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 80,
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
                    child: (_connectedToServices)
                        ? _musicPlayer(context)
                        : _connectionStatus(context), // PlayerPanel(),
                  ),
                ),
              ],
            ),
          )
        : Container();
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

  // TODO: DIALOG NOT LOADING
  Future<void> _selectSearchService() async {
    switch (await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select Search Service'),
            children: <Widget>[
              (player.searchService != null &&
                      player.searchService
                          .isConnected) // player.allowedServices.contains(player.searchService)
                  ? ListTile(
                      leading: player.searchService.getImageIcon(),
                      title: Text(player.searchService.name),
                    )
                  : Container(),
              Divider(),
              ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: player.connectedServices
                    .length, // replace connectedServices with allowedServices
                itemBuilder: (BuildContext context, int index) {
                  return (player.connectedServices.toList()[index].name !=
                              player.searchService.name &&
                          player.connectedServices
                                  .toList()[index]
                                  .isConnected ==
                              true)
                      ? SimpleDialogOption(
                          onPressed: () {
                            setState(() {
                              player.searchService = player.connectedServices
                                      .toList()[
                                  index]; // replace connectedServices with allowedServices
                            });
                            Navigator.pop(context,
                                player.connectedServices.toList()[index].name);
                          }, // replace connectedServices with allowedServices
                          child: ListTile(
                            leading: player.connectedServices
                                .toList()[index]
                                .getImageIcon(), // replace connectedServices with allowedServices
                            title: Text(player.connectedServices
                                .toList()[index]
                                .name), // replace connectedServices with allowedServices
                          ),
                        )
                      : null;
                },
              ),
            ],
          );
        })) {
      case Service.SPOTIFY:
        // ...
        break;
      case Service.SOUNDCLOUD:
        // ...
        break;
    }
  }

  Future<void> _roomCodeDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Room Code'),
          content: SingleChildScrollView(
            child: GestureDetector(
              onTap: () {
                Clipboard.setData(
                    ClipboardData(text: 'testing')); // args.roomID
                Scaffold.of(context).showSnackBar(SnackBar(
                    content: const Text(
                        'Copied to Clipboard'))); // NOTE: snackbar not working on web
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'abcd1234', // args.roomID
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  SizedBox(width: 5),
                  Icon(Icons.content_copy),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
    // return Container(
    //   height: 80,
    //   child: Center(
    //     child: Text(
    //       (_availableServices != null)
    //           ? 'Connecting to ${listServices()}'
    //           : 'Connect a Streaming Service to enable the Music Player',
    //       style: TextStyle(
    //         color: Colors.white,
    //       ),
    //     ),
    //   ),
    // );

    return Container(
      height: 80,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            (player.allowedServices.isNotEmpty)
                ? 'Connecting to ${listServices()}' //TODO: Add circular progress indicator in connecting display
                : 'Connect a Streaming Service to Enable the Music Player', //Failed to Connect to Streaming Services
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  String listServices() {
    String services = '';
    // for (int i = 0; i < _availableServices.length; i++) {
    //   services += _availableServices[i] +
    //       ((i < _availableServices.length - 1) ? ', ' : '');
    // }

    for (var s in player.allowedServices.toList()) {
      if (!s.isConnected) {
        services += '${s.name}, ';
      }
    }
    if (services.isNotEmpty) {
      services =
          services.replaceRange(services.length - 2, services.length, '');
    }
    return services;
  }
}
