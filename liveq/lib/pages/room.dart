import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// import 'package:liveq/utils/player.dart';
import 'package:liveq/utils/services.dart';
import 'package:liveq/utils/utils.dart';
import 'package:liveq/widgets/songtile.dart';
import 'package:liveq/widgets/music_icons.dart';
import 'package:liveq/models/catalog.dart';
import 'package:liveq/models/player.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

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
  Future<bool> _connectedToAllServices;
  Service _searchService;
  Set<Service> _allowedServices = {};
  // List<Song> _queue = List();
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
        isHost = true;
        // Set args.roomName and args.roomID received from server - set in dialog

        // if host then connect to services
        if (args.host) {
          setState(() {
            _allowedServices.addAll(
                Provider.of<CatalogModel>(context, listen: false)
                    .connectedServices);
          });
          _connectedToAllServices = connectToServices();
          // send updateServices to server with allowedServices as param
        } else {
          isHost = false;
          // else if guest, wait for services from server to set available services and to set search service
          client.GetServices().then((_guestServices) {
            setState(() {
              for (String s in _guestServices) {
                _allowedServices.add(
                    Provider.of<CatalogModel>(context, listen: false)
                        .fromString(s));
                print('found $s');
              }
              if (_guestServices.isNotEmpty) {
                _searchService =
                    Provider.of<CatalogModel>(context, listen: false)
                        .fromString(_guestServices[0]);
              }
              for (Service s in _allowedServices) {
                s.connect();
              }
              _connectedToServices = true;
            });
          });
        }
      }
    });

    // set soundcloud
    // player.connect(SoundCloud());

    // initialize and subscribe to server stream of songs in queue
    // timer = Timer.periodic(Duration(milliseconds: 100), (_) => loadQueue());
    timer = Timer.periodic(Duration(milliseconds: 100),
        (_) => Provider.of<PlayerModel>(context, listen: false).loadQueue());
  }

  @override
  void dispose() {
    // Disconnect from services

    timer.cancel();
    if (args != null) {
      if (args.host) {
        client.DeleteRoom();
      } else {
        client.LeaveRoom();
      }
    }
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
                    onPressed: (_allowedServices.isNotEmpty &&
                            _connectedToServices == true)
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
        ? Column(
            children: <Widget>[
              Expanded(
                child: _queueListView(),
              ),
              args.host == true
                  ? Align(
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
                        child: FutureBuilder<bool>(
                          future: _connectedToAllServices,
                          builder: (BuildContext context,
                              AsyncSnapshot<bool> snapshot) {
                            if (snapshot.hasData) {
                              return (_connectedToServices)
                                  ? _musicPanel() // PlayerPanel()
                                  : _errorMessages(true);
                            } else if (snapshot.hasError) {
                              return _errorMessages(false);
                            } else {
                              return _connectionStatus();
                            }
                          },
                        ),
                      ),
                    )
                  : Container(),
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

  Future<void> _selectSearchService() async {
    print('searching');
    for (Service s in _allowedServices) {
      print(s.name);
      print(s.isConnected);
    }
    // switch (
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select Search Service'),
          children: <Widget>[
            _searchService != null
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
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
                // physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: _allowedServices.length,
                itemBuilder: (BuildContext context, int index) {
                  return (_allowedServices.toList()[index].name !=
                          _searchService.name) // &&
                      // _allowedServices.toList()[index].isConnected == true)
                      ? SimpleDialogOption(
                          onPressed: () {
                            setState(() {
                              _searchService = _allowedServices.toList()[index];
                            });
                            Navigator.pop(
                                context, _allowedServices.toList()[index].name);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 4.0),
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
                      : Container();
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
                    ClipboardData(text: args.roomID)); // args.roomID
                Scaffold.of(context).showSnackBar(SnackBar(
                    content: const Text(
                        'Copied to Clipboard'))); // NOTE: snackbar not working on web
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    args.roomID, // args.roomID
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.content_copy,
                    // size: 24.0,
                  ),
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
    return Consumer<PlayerModel>(builder: (context, player, child) {
      return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: player.queue.length,
        itemBuilder: (context, index) {
          return args.host == true
              ? Dismissible(
                  key: ObjectKey(player.queue[index]),
                  onDismissed: (direction) {
                    setState(() {
                      client.DeleteSong(player.queue[index]);
                      // player.queue.removeAt(index);
                    });
                    Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text("Song removed")));
                  },
                  background: Container(color: Theme.of(context).primaryColor),
                  child: SongTile(song: player.queue[index]),
                )
              : SongTile(song: player.queue[index]);
        },
      );
    });
  }

  // Widget _queueListView() {
  //   return ListView.builder(
  //       physics: BouncingScrollPhysics(),
  //       itemCount: _queue.length,
  //       itemBuilder: (context, index) {
  //         return args.host == true
  //             ? Dismissible(
  //                 key: ObjectKey(_queue[index]),
  //                 onDismissed: (direction) {
  //                   setState(() {
  //                     client.DeleteSong(_queue[index]);
  //                     // _queue.removeAt(index);
  //                   });
  //                   Scaffold.of(context)
  //                       .showSnackBar(SnackBar(content: Text("Song removed")));
  //                 },
  //                 background: Container(color: Theme.of(context).primaryColor),
  //                 child: SongTile(song: _queue[index]),
  //               )
  //             : SongTile(song: _queue[index]);
  //       },
  //     );
  // }

  Widget _musicPanel() {
    return Consumer<PlayerModel>(
      builder: (context, player, child) {
        if (player.songComplete == true) {
          setState(() {
            player.songComplete = false;
            player.next();
          });
        }
        return Container(
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListTile(
              leading: GestureDetector(
                onTap: () {
                  // if (player.currentSong == null ||
                  //     player.currentSong.uri == null) {
                  //   return;
                  // }
                  if (RoomPlayerState.paused == player.state ||
                      RoomPlayerState.stopped == player.state) {
                    if (player.currentSong != null) {
                      player.play(player.currentSong);
                    } else {
                      player.next();
                    }
                  } else {
                    player.pause();
                  }
                },
                child: Container(
                  child: (player.state == RoomPlayerState.playing)
                      ? PauseIcon(
                          color: Colors.white,
                        )
                      : PlayIcon(
                          color: Colors.white,
                        ),
                ),
              ),
              title: Text(
                player.currentSong != null ? player.currentSong.trackName : '',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                player.currentSong != null ? player.currentSong.artists : '',
                style: TextStyle(
                  color: Colors.white,
                  // letterSpacing: 1,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: GestureDetector(
                onTap: () {
                  // if (player.currentSong == null ||
                  //     player.currentSong.uri == null) {
                  //   return;
                  // }
                  player.next();
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

  void _searchSong() async {
    List<String> _availableServices = List();
    if (_connectedToServices) {
      _availableServices.addAll(_allowedServices.map((s) => s.name).toList());
    }
    final result = await Navigator.pushNamed(context, '/search',
        arguments: SearchArguments(
            searchService: _searchService != null ? _searchService.name : null,
            allowedServices: _availableServices));

    if (result != null) {
      client.AddSong(result);
    }
  }

  Widget _connectionStatus() {
    return Container(
      height: 80,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: (_allowedServices.isNotEmpty)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 16.0,
                      width: 16.0,
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2.5,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.0),
                    Text(
                      'Connecting to ${listServices()}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              : const Text(
                  'Connect to a streaming service to enable the music player',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _errorMessages(bool _connected) {
    return Container(
      height: 80,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.error_outline,
                color: Colors.white,
                size: 20.0,
              ),
              SizedBox(width: 8.0),
              _connected == true
                  ? const Text(
                      'Failed to connect to any streaming service',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Failed with unknown error',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
            ],
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

  Future<bool> connectToServices() async {
    bool connectedtoAll = true;
    List<Service> _connectingServices = List();
    _connectingServices.addAll(_allowedServices);
    for (Service s in _connectingServices) {
      bool serviceConnected = await s.connect();
      if (serviceConnected) {
        setState(() {
          s.isConnected = true;
          client.AddService(s.name);
        });
      } else {
        // if service cannot connect - remove from allowedServices
        setState(() {
          _allowedServices.remove(s);
        });
        connectedtoAll = false;
      }
    }

    // setState(() {
    //   _allowedServices.removeAll(_removeableServices);
    // });

    if (_allowedServices.isNotEmpty) {
      setState(() {
        Provider.of<PlayerModel>(context, listen: false)
            .setCurrentService(_allowedServices.toList()[0]);
        // may need to set searchService in room for host/guest
        _searchService = _allowedServices.toList()[0];
        _connectedToServices = true;
      });
    }
    return connectedtoAll;
  }

  // loadQueue() async {
  //   client.GetQueue().then((q) {
  //     if (q != null) {
  //       setState(() {
  //         _queue = q;
  //       });
  //     }
  //   });
  // }
}
