import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// import 'package:liveq/utils/player.dart';
import 'package:liveq/utils/services.dart';
import 'package:liveq/utils/utils.dart';
import 'package:liveq/utils/song.dart';
import 'package:liveq/widgets/songtile.dart';
import 'package:liveq/widgets/music_icons.dart';
import 'package:liveq/models/catalog.dart';
import 'package:liveq/models/player_new.dart';

class RoomProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PlayerModel>(
      create: (context) => PlayerModel(),
      child: Room(),
    );
  }
}

class Room extends StatefulWidget {
  @override
  _RoomState createState() => _RoomState();
}

class _RoomState extends State<Room> {
  RoomArguments args;
  // Flag that shows whether we are connected to the server and server's room
  bool _connectedToServer; // = false
  bool _connectedToServices = false;
  Service _searchService;
  Set<Service> _allowedServices = {};
  List<Song> _queue = List();
  Timer timer;

  @override
  void initState() {
    super.initState();
    // TODO: Quick hack to set args - reference: https://stackoverflow.com/questions/56262655/flutter-get-passed-arguments-from-navigator-in-widgets-states-initstate
    Future.delayed(Duration.zero, () {
      setState(() {
        args = ModalRoute.of(context).settings.arguments;
      });

      if (args != null) {
        // Set args.roomName and args.roomID received from server - set in dialog
        // initialize and subscribe to server stream of songs in queue

        // if host then connect to services
        // set _player.allowedServices.addAll(Service.connectedServices); // for guest, need to receive services from server
        setState(() {
          _allowedServices.addAll(
              Provider.of<CatalogModel>(context, listen: false)
                  .connectedServices);
        });

        connectToServices();
        // send updateServices to server

        // else if guest, wait for services from server to set available services and to set search service
      }
    });

    // set soundcloud
    // player.connect(SoundCloud());

    timer = Timer.periodic(Duration(milliseconds: 100), (_) => loadQueue());
  }

  @override
  void dispose() {
    // Disconnect from services
    timer.cancel();
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
              onPressed: () => _searchSong(),
            ),
            // connectedToServer == true
            _searchService != null
                ? IconButton(
                    icon: _searchService.getImageIcon(),
                    onPressed: _allowedServices.length > 1
                        ? () => _selectSearchService()
                        : null,
                  )
                : IconButton(
                    icon: Icon(Icons.music_note),
                    onPressed: _allowedServices.isNotEmpty
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
        ? Column(
            children: <Widget>[
              Expanded(
                child: _queueListView(),
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
                    color: Theme.of(context).primaryColor,
                    // gradient: LinearGradient(
                    //   begin: Alignment.topLeft,
                    //   end: Alignment.bottomRight,
                    //   stops: [
                    //     0.0,
                    //     0.7,
                    //   ],
                    //   colors: [
                    //     Color(0xFF47ACE1),
                    //     Color(0xFFDF5F9D),
                    //   ],
                    // ),
                  ),
                  child: (_connectedToServices)
                      ? _musicPlayer()
                      : _connectionStatus(), // PlayerPanel(),
                ),
              ),
            ],
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

  void _searchSong() async {
    final result = await Navigator.pushNamed(context, '/search');

    if (result != null) {
      client.AddSong(result);
    }
  }

  // TODO: DIALOG NOT LOADING
  Future<void> _selectSearchService() async {
    // switch (
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select Search Service'),
          children: <Widget>[
            _searchService != null
                ? Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        _searchService.getImageIcon(),
                        SizedBox(width: 16.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(_searchService.name,
                                style: Theme.of(context).textTheme.subtitle1),
                            Text('Selected',
                                style: Theme.of(context).textTheme.caption),
                          ],
                        )
                      ],
                    ),
                  )
                : Container(),
            Divider(),

            // TODO: Temporary fix by manually setting width and setting shrinkWrap
            Container(
              width: 200,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: _allowedServices.length,
                itemBuilder: (context, index) {
                  return (_allowedServices.toList()[index].name !=
                              _searchService.name &&
                          _allowedServices.toList()[index].isConnected == true)
                      ? SimpleDialogOption(
                          onPressed: () {
                            setState(() {
                              _searchService = _allowedServices.toList()[index];
                            });
                            Navigator.pop(
                                context, _allowedServices.toList()[index].name);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 24.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                _allowedServices.toList()[index].getImageIcon(),
                                SizedBox(width: 16.0),
                                Text(_allowedServices.toList()[index].name,
                                    style:
                                        Theme.of(context).textTheme.subtitle1),
                              ],
                            ),
                          ),
                        )
                      : null;
                },
              ),
            ),
          ],
        );
      },
    );
    //     ) {
    //   case Service.SPOTIFY:
    //     // ...
    //     break;
    //   case Service.SOUNDCLOUD:
    //     // ...
    //     break;
    // }
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

  Widget _queueListView() {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: _queue.length,
      itemBuilder: (context, index) {
        return SongTile(song: _queue[index]);
      },
    );
  }

  Widget _musicPanel() {
    Consumer<PlayerModel>(
      builder: (context, player, child) {
        return Container(
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListTile(
              leading: GestureDetector(
                onTap: () {
                  if (player.currentSong == null ||
                      player.currentSong.uri == null) {
                    return;
                  }
                  if (PlayerState.paused == player.state) {
                    // stream.playMusic(_currentSong);
                  } else {
                    // stream.pauseMusic(_currentSong);
                  }
                },
                child: Container(
                  child: player.state == PlayerState.playing
                      ? PauseIcon(
                          color: Colors.white,
                        )
                      : PlayIcon(
                          color: Colors.white,
                        ),
                ),
              ),
              title: Text(
                player.currentSong.trackName,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                player.currentSong.artists,
                style: TextStyle(
                  color: Colors.white,
                  // letterSpacing: 1,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: GestureDetector(
                onTap: () {
                  if (player.currentSong == null ||
                      player.currentSong.uri == null) {
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
          ),
        );
      },
    );
  }

  /// The Music Player
  Widget _musicPlayer() {
    Consumer<PlayerModel>(
      builder: (context, player, child) {
        return Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                    onPressed: () => player.resume(), child: Text('Play')),
                RaisedButton(
                    onPressed: () => player.pause(), child: Text('Pause')),
                RaisedButton(
                    onPressed: () => player.next(), child: Text('Next')),
              ],
            ));
      },
    );
  }

  Widget _connectionStatus() {
    return Container(
      height: 80,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            (_allowedServices.isNotEmpty)
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

    for (var s in _allowedServices.toList()) {
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

  void connectToServices() async {
    for (Service s in _allowedServices) {
      bool serviceConnected = await s.connect();
      if (serviceConnected) {
        setState(() {
          s.isConnected = true;
          // client.AddService(s.name);
        });
      } else {
        // if service cannot connect - remove from allowedServices
        setState(() {
          _allowedServices.remove(s);
        });
      }
    }
    if (_allowedServices.isNotEmpty) {
      setState(() {
        Provider.of<PlayerModel>(context, listen: false)
            .setCurrentService(_allowedServices.toList()[0]);
        // may need to set searchService in room for host/guest
        _searchService = _allowedServices.toList()[0];
        _connectedToServices = true;
      });
    }
  }

  loadQueue() async {
    client.GetQueue().then((q) {
      if (q != null) {
        _queue = q;
      }
    });
  }
}
