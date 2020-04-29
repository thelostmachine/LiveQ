import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:liveq/models/player.dart';
import 'package:liveq/models/catalog.dart';
import 'dart:convert' as convert;
import 'package:liveq/utils/utils.dart';

import 'package:spotify/spotify.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

import 'package:liveq/utils/song.dart';

abstract class Service {
  static const String SOUNDCLOUD = 'SoundCloud';
  static const String SPOTIFY = 'Spotify';
  static const String APPLE = 'Apple Music';

  String name;
  bool isConnected = false;
  // Future<bool> get isConnected;

  static final List<Service> potentialServices = [Spotify(), SoundCloud()];

  String iconImagePath;

  // void Function(void) callback;

  Future<bool> connect();
  // Future<bool> connect() async {
  //   connectedServices.add(this);
  //   await saveService();
  //   isConnected = true;
  //   return Future.value(true);
  // }

  Future<void> play(String uri, PlayerModel player);
  Future<void> resume();
  Future<void> pause();

  Widget getImageIcon() {
    if (iconImagePath != null) {
      return ImageIcon(AssetImage(iconImagePath));
    } else {
      return Icon(Icons.music_note);
    }
  }

  Future<List<Song>> search(String query);

  static Service fromString(String s) {
    Service service;

    switch (s) {
      case SPOTIFY:
        service = Spotify();
        break;
      case SOUNDCLOUD:
        service = SoundCloud();
        break;
      case APPLE:
        break;
    }

    return service;
  }
}

class SoundCloud extends Service {
  final String name = CatalogModel.SOUNDCLOUD;

  // final String clientId = 'YaH7Grw1UnbXCTTm0qDAq5TZzzeGrjXM';
  final String clientId = 'e38841b15b2059a39f261df195dfb430';
  final String userId = '857371-474509-874152-946359';
  final String iconImagePath = 'assets/images/soundcloud.png';

  static final Service _soundcloud = SoundCloud._internal();

  // AudioStream stream;
  AudioPlayer player = AudioPlayer();

  SoundCloud._internal();

  factory SoundCloud() {
    return _soundcloud;
  }

  @override
  Future<bool> connect() async {
    // super.connect();
    // TODO: implement connect
    // throw UnimplementedError();
    return Future.value(true);
  }

  @override
  Future<void> pause() async {
    // TODO: implement pause
    // stream.pause();
    print("pausing");
    player.pause();
  }

  @override
  Future<void> play(String id, PlayerModel playerApi) async {
    String uri =
        'https://api.soundcloud.com/tracks/$id/stream?client_id=$clientId';
    print('playing $uri');
    AudioPlayer.logEnabled = true;
    int result = await player.play(uri);
    if (result == 1) {
      player.onPlayerCompletion.listen((event) {
        playerApi.next();
      });
    } else {
      print("FAIL");
    }
  }

  @override
  Future<void> resume() {
    // TODO: implement resume
    // stream.resume();
    player.resume();
  }

  @override
  Future<List<Song>> search(String query) async {
    
    List<Song> searchResults = List();
    String search =
        'https://api.soundcloud.com/tracks?q=${formatSearch(query)}&limit=100&format=json&client_id=$clientId';

    var response = await http.get(search);

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      for (var item in jsonResponse) {
        if (item['kind'] == 'track' && item['artwork_url'] != null) {
          var track = item;
          String trackId = track['id'].toString();
          String uri = track['uri'];
          String trackName = track['title'];
          String artist = track['user']['username'];
          String imageUri = track['artwork_url'];
          int duration = track['duration'];
          Service service = this;

          Song song = Song(0, trackId, uri, trackName, artist, imageUri, duration, service);
          searchResults.add(song);
        }
      }
    } else {
      print('ERROR');
      print(response.statusCode);
    }

    return searchResults;
  }

  String formatSearch(String query) {
    String s = query.replaceAll(' ', '%20');
    s = s.replaceAll('(', '%28');
    s = s.replaceAll(')', '%29');
    return s;
  }
}

class Spotify extends Service {
  final String name = CatalogModel.SPOTIFY;
  final String iconImagePath = 'assets/images/Spotify_Icon_RGB_Green.png';

  // Developer tokens. DO NOT CHANGE
  final String clientId = '03237b2409b24752a3f0c33262ad2d02';
  final String clientSecret = '52560cee72394fc5a049731f2d8f001e';
  final String redirectUri = 'spotify-ios-quick-start://spotify-login-callback';

  SpotifyApi spotifyWebApi;

  static final Service _spotify = Spotify._internal();

  Spotify._internal();

  factory Spotify() {
    return _spotify;
  }

  /// Connect to the SpotifySDK and get an [authenticationToken]
  @override
  Future<bool> connect() async {
    // super.connect();
    // Use the spotify package to create credentials. This is only needed for Search
    var credentials = SpotifyApiCredentials(clientId, clientSecret);
    spotifyWebApi = SpotifyApi(credentials);

    // Use the spotify_sdk package if on mobile to allow playing
    if (!kIsWeb && isHost) {
      await SpotifySdk.connectToSpotifyRemote(
          clientId: this.clientId, redirectUrl: this.redirectUri);
    }

    return spotifyWebApi != null;
  }

  /// Pause a [Song]
  @override
  Future<void> pause() async {
    await SpotifySdk.pause();
  }

  /// Play a [Song] given a [uri]
  @override
  Future<void> play(String uri, PlayerModel player) async {
    await SpotifySdk.play(spotifyUri: uri);
    SpotifySdk.subscribePlayerContext().listen((playerContext) {
      if (playerContext.uri.contains('station')) {
        player.next();
      }
    });
  }

  /// Resume the [Song] playing right now
  @override
  Future<void> resume() async {
    await SpotifySdk.resume();
  }

  /// Use the [authenticationToken] to search a query using the Spotify Web API
  @override
  Future<List<Song>> search(String query) async {
    List<Song> searchResults = List();

    var search =
        await spotifyWebApi.search.get(query).first().catchError((err) {
      print('SPOTIFY ERROR: ${(err as SpotifyException).message}');
    });

    if (search != null) {
      search.forEach((pages) {
        pages.items.forEach((track) async {
          if (track is Track) {
            String trackId = track.id;
            String uri = track.uri;
            String trackName = track.name;
            List<String> _artistNames =
                track.artists.map((val) => val.name).toList();
            String artists = _artistNames.join(", ");
            String imageUri = track.album.images[1].url;
            int duration = track.durationMs;
            Service service = this;

            searchResults.add(
                Song(0, trackId, uri, trackName, artists, imageUri, duration, service));
          }
        });
      });
    }

    return searchResults;
  }
}

// class Apple extends Service {
//   final String name = Service.APPLE;
//   final String iconImagePath = 'assets/images/Apple_Music_Icon.psd';

//   static final Service _apple = Apple._internal();

//   Apple._internal();

//   factory Apple() {
//     return _apple;
//   }

//   @override
//   Future<bool> connect() {
//     // super.connect();
//     // TODO: implement connect
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> pause() {
//     // TODO: implement pause
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> play(String uri) {
//     // TODO: implement play
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> resume() {
//     // TODO: implement resume
//     throw UnimplementedError();
//   }

//   @override
//   Future<List<Song>> search(String uri) {
//     // TODO: implement search
//     throw UnimplementedError();
//   }
// }
