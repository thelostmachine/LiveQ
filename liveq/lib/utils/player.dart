// import 'package:flutter/material.dart';

// import 'package:liveq/utils/client_interface.dart';
// import 'package:liveq/utils/services.dart';
// import 'package:liveq/utils/utils.dart';
// import 'package:property_change_notifier/property_change_notifier.dart';

// import 'song.dart';

// enum ModelProperties {
//   queue,
//   soundcloudTrack,
// }

// class Player extends PropertyChangeNotifier<ModelProperties> {
//   Song _currentSong;
//   Service _currentService;
//   Service searchService;

//   // Set of services allowed in the room
//   Set<Service> allowedServices =
//       {}; // passed in through server data for guest/host?

//   List<Song> queue = List();

//   bool isConnected =
//       false; // Set true when all services in allowedServices are connected
//   ThisPlayerState state = ThisPlayerState.stopped;

//   static final Player _player = Player._internal();

//   Player._internal();

//   factory Player() {
//     return _player;
//   }

//   void addSong(Song song) {
//     client.AddSong(song);
//   }

//   Song getNextSong() {
//     Song next = queue[0];
//     client.DeleteSong(next);

//     return next;
//   }

//   loadQueue() async {
//     client.GetQueue().then((q) {
//       if (q != null) {
//         queue = q;
//         notifyListeners(ModelProperties.queue);
//       }
//     });
//   }

//   Future play(Song song) async {
//     print(song == null);
//     if (song != null) {
//       _currentSong = song;
//       _currentService = song.service;

//       String uri = _currentSong.uri;
//       if (_currentService is SoundCloud) {
//         uri = song.trackId;
//       }
//       state = ThisPlayerState.playing;
//       print('hello1');

//       // _currentSong.service.play(uri, this);
//     } else {
//       resume();
//     }
//   }

//   void resume() {
//     _currentService.resume();
//     state = ThisPlayerState.playing;
//   }

//   void pause() {
//     _currentService.pause();
//     state = ThisPlayerState.paused;
//   }

//   ThisPlayerState getPlayerState() {
//     return state;
//   }

//   void setService(Service service) {
//     print('adding');
//     client.AddService(service.name);
//     _currentService = service;
//     // searchService = service;
//     // isConnected = true;
//   }

//   void next() async {
//     print("hello");
//     print(queue.length);
//     if (queue != null && queue.isNotEmpty) {
//       Song nextSong = getNextSong();
//       print(nextSong.trackName);

//       // Stop playing the current song on the current service if we're switching Services
//       if (_currentService != nextSong.service || _currentService is SoundCloud) {
//         pause();
//       }

//       _currentSong = nextSong;
//       _currentService = _currentSong.service;
//       // play(_currentSong);
//       state = ThisPlayerState.playing;
//       return play(_currentSong);
//     }

//     return null;
//   }

//   // Calls when song is finished playing
//   void onComplete() {
//     next();
//   }

//   void connect(Service service) async {
//     service.connect();
//     setService(service);
//   }

//   Future<List<Song>> search(String query) async {
//     print('searching with ${searchService.name}');
//     return searchService.search(query);
//   }

//   void connectToServices(VoidCallback callback) async {
//     for (Service s in allowedServices) {
//       bool serviceConnected = await s.connect();
//       if (serviceConnected) {
//         s.isConnected = true;
//       } else {
//         // if service cannot connect - remove from allowedServices
//         allowedServices.remove(s); // need setState?
//       }
//     }

//     if (allowedServices.isNotEmpty) {
//       setService(allowedServices.toList()[0]);
//       searchService = allowedServices
//           .toList()[0]; // may need to set searchService in room for host/guest
//       callback();
//     }
//   }

//   void checkState() async {

//   }
// }
