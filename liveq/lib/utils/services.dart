import 'package:flutter/material.dart' as material;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:spotify/spotify.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:spotify_sdk/models/connection_status.dart';

import 'package:url_audio_stream/url_audio_stream.dart';

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

  Future<bool> connect();
  // Future<bool> connect() async {
  //   connectedServices.add(this);
  //   await saveService();
  //   isConnected = true;
  //   return Future.value(true);
  // }

  Future<void> play(String uri);
  Future<void> resume();
  Future<void> pause();

  material.Widget getImageIcon() {
    if (iconImagePath != null) {
      return material.ImageIcon(material.AssetImage(iconImagePath));
    } else {
      return material.Icon(material.Icons.music_note);
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
  final String name = Service.SOUNDCLOUD;

  final String clientId = 'YaH7Grw1UnbXCTTm0qDAq5TZzzeGrjXM';
  final String playId = 'e38841b15b2059a39f261df195dfb430';
  final String userId = '857371-474509-874152-946359';
  final String iconImagePath = 'assets/images/soundcloud.png';

  static final Service _soundcloud = SoundCloud._internal();

  AudioStream stream;

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
    // return Future.value(false);
  }

  @override
  Future<void> pause() async {
    // TODO: implement pause
    stream.pause();
  }

  @override
  Future<void> play(String id) async {
    String uri =
        'https://api.soundcloud.com/tracks/$id/stream?client_id=$playId';
    print('wanting to play $uri');
    stream = AudioStream(uri);
    stream.start();
  }

  @override
  Future<void> resume() {
    // TODO: implement resume
    stream.resume();
  }

  @override
  Future<List<Song>> search(String query) async {
    print("START SEARCHING SOUNDCLOUD");
    List<Song> searchResults = List();
    String search = 'https://api-v2.soundcloud.com/search?q=';
    search += formatSearch(query);
    search += '&variant_ids=';
    search += '&facet=model';
    search += '&user_id=$userId';
    search += '&client_id=$clientId';
    search += '&limit=10';
    search += '&offset=0';
    search += '&linked_partitioning=1';
    search += '&app_version=1586177347';
    search += '&app_locale=en';
    search +=
        '&limit=10&offset=0&linked_partitioning=1&app_version=1586177347&app_locale=en';

    var response = await http.get(search);

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      for (var item in jsonResponse['collection']) {
        if (item['kind'] == 'track' && item['artwork_url'] != null) {
          var track = item;
          String id = track['id'].toString();
          String uri = track['uri'];
          String trackName = track['title'];
          String artist = track['user']['full_name'];
          String imageUri = track['artwork_url'];
          int duration = track['full_duration'];
          Service service = this;
          print("SOUNDCLOUD TRACKNAME: $trackName");

          // Check if track is streamable. If not, don't include it in search results
          var test = await http
              .get('https://api.soundcloud.com/tracks/$id?client_id=$playId');
          if (test.statusCode == 200) {
            searchResults.add(
                Song(id, uri, trackName, artist, imageUri, duration, service));
          }
        }
      }
    } else {
      print('ERROR');
      print(response.statusCode);
    }
    print("DONE SEARCHING SOUNDCLOUD");
    return searchResults;
  }

  String formatSearch(String query) {
    return query.replaceAll(' ', '%20');
  }
}

class Spotify extends Service {
  final String name = Service.SPOTIFY;
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
    if (!kIsWeb) {
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
  Future<void> play(String uri) async {
    await SpotifySdk.play(spotifyUri: uri);
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

    var search = await spotifyWebApi.search
        .get(query)
        .first()
        .catchError((err) => print((err as SpotifyException).message));

    if (search != null) {
      search.forEach((pages) {
        pages.items.forEach((track) async {
          if (track is Track) {
            String id = track.id;
            String uri = track.uri;
            String trackName = track.name;
            List<String> _artistNames =
                track.artists.map((val) => val.name).toList();
            String artists = _artistNames.join(", ");
            String imageUri = track.album.images[1].url;
            int duration = track.durationMs;
            Service service = this;

            searchResults.add(
                Song(id, uri, trackName, artists, imageUri, duration, service));
          }
        });
      });
    }

    return searchResults;
  }
}

class Apple extends Service {
  final String name = Service.APPLE;
  final String iconImagePath = 'assets/images/Apple_Music_Icon.psd';

  static final Service _apple = Apple._internal();

  Apple._internal();

  factory Apple() {
    return _apple;
  }

  @override
  Future<bool> connect() async {
    // super.connect();
    // TODO: implement connect
    throw UnimplementedError();
  }

  @override
  Future<void> pause() async {
    // TODO: implement pause
    throw UnimplementedError();
  }

  @override
  Future<void> play(String uri) async {
    // TODO: implement play
    throw UnimplementedError();
  }

  @override
  Future<void> resume() async {
    // TODO: implement resume
    throw UnimplementedError();
  }

  @override
  Future<List<Song>> search(String uri) async {
    // TODO: implement search
    throw UnimplementedError();
  }
}
