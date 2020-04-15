import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter/material.dart' as material;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:spotify_sdk/models/connection_status.dart';

import 'package:liveq/utils/song.dart';

abstract class Service {
  static const String SOUNDCLOUD = 'SoundCloud';
  static const String SPOTIFY = 'Spotify';
  static const String APPLE = 'Apple Music';

  String name;
  // bool connected;
  bool isConnected = false;
  // Future<bool> get isConnected;

  static final List<Service> potentialServices = [Spotify(), SoundCloud()];
  static Set<Service> connectedServices = {};

  String iconImagePath;

  Future<bool> connect() {
    connectedServices.add(this);
    return Future.value(true);
  }

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

  static Future<void> saveServices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> serviceStrings = List();
    connectedServices.forEach((s) {
      serviceStrings.add(s.name);
    });

    prefs.setStringList('serviceList', serviceStrings);
  }

  // WIP
  static Future<void> loadServices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> serviceStrings = prefs.getStringList('serviceList') ?? null;

    if (serviceStrings != null && serviceStrings.isNotEmpty) {
      for (String s in serviceStrings) {
        Service service = fromString(s);
        connectedServices.add(service);
      }
    }
    // return (connectedServices.length > 0)
    //     ? connectedServices.toList()[0]
    //     : null;
  }

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

  static bool canCreateRoom() {
    return connectedServices.isNotEmpty ? true : false;
  }
}

class SoundCloud extends Service {
  final String name = Service.SOUNDCLOUD;

  final String clientId = 'YaH7Grw1UnbXCTTm0qDAq5TZzzeGrjXM';
  final String userId = '857371-474509-874152-946359';

  static final Service _soundcloud = SoundCloud._internal();

  SoundCloud._internal();

  factory SoundCloud() {
    return _soundcloud;
  }

  @override
  Future<bool> connect() {
    super.connect();
    // TODO: implement connect
    throw UnimplementedError();
  }

  @override
  Future<void> pause() {
    // TODO: implement pause
    throw UnimplementedError();
  }

  @override
  Future<void> play(String uri) {
    // TODO: implement play
    throw UnimplementedError();
  }

  @override
  Future<void> resume() {
    // TODO: implement resume
    throw UnimplementedError();
  }

  @override
  Future<List<Song>> search(String query) async {
    List<Song> searchResults = List();
    String search =
        'https://api-v2.soundcloud.com/search?q=porter%20robinson&variant_ids=&facet=model&user_id=857371-474509-874152-946359&client_id=YaH7Grw1UnbXCTTm0qDAq5TZzzeGrjXM&limit=20&offset=0&linked_partitioning=1&app_version=1586177347&app_locale=en';
    // String search = 'https://api-v2.soundcloud.com/search/queries?q=';
    // search += formatSearch(query);
    // search += '&client_id=$clientId';
    // search += '&limit=10&offset=0&linked_partitioning=1&app_version=1586177347&app_locale=en';
    // search += '&variant_ids=';
    // search += '&facet=model';
    // search += '&user_id=$userId';

    // search = 'https://api-v2.soundcloud.com/search?q=juice%20wrld&sc_a_id=8518dae7c71781e17004bb10b29a999e555ad4ce&variant_ids=&facet=model&user_id=857371-474509-874152-946359&client_id=YaH7Grw1UnbXCTTm0qDAq5TZzzeGrjXM&limit=20&offset=0&linked_partitioning=1&app_version=1586177347&app_locale=en';

    var response =
        await http.get(search, headers: {'Accept': 'application/json'});

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      for (var item in jsonResponse['collection']) {
        print(item.toString());
      }
    } else {
      print('ERROR');
      print(response.statusCode);
    }

    // var search = await spotifyWebApi.search
    //   .get(query)
    //   .first()
    //   .catchError((err) => print((err as SpotifyException).message));

    // if (search != null) {

    //   search.forEach((pages) {
    //     pages.items.forEach((track) async {
    //       if (track is Track) {
    //         String id = track.id;
    //         String uri = track.uri;
    //         String trackName = track.name;
    //         String artist = track.artists[0].name;
    //         String imageUri = track.album.images[1].url;
    //         Duration durationMilli = track.duration;
    //         Service service = this;

    //         searchResults.add(Song(id, uri, trackName, artist, imageUri, durationMilli, service));
    //       }
    //      });
    //    });
    // }

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

  // Future<bool> get isConnected async {
  //   var credentials = await spotifyWebApi.getCredentials();
  //   bool expired = credentials.isExpired;
  //   connected = !credentials.isExpired;
  //   print('EXPIRED? : $expired');
  //   print('CONNECTED? : $connected');
  //   // return credentials.isExpired;
  //   return connected;
  //   // _credentials.then((value) {
  //   //   print('EXPIRED? : ${value.isExpired}');
  //   //   return value.isExpired;
  //   // });
  // }

  static final Service _spotify = Spotify._internal();

  Spotify._internal();

  factory Spotify() {
    return _spotify;
  }

  /// Connect to the SpotifySDK and get an [authenticationToken]
  @override
  Future<bool> connect() async {
    super.connect();
    // Use the spotify package to create credentials. This is only needed for Search
    var credentials = SpotifyApiCredentials(clientId, clientSecret);
    spotifyWebApi = SpotifyApi(credentials);

    // Use the spotify_sdk package if on mobile to allow playing
    if (!kIsWeb) {
      await SpotifySdk.connectToSpotifyRemote(
          clientId: this.clientId, redirectUrl: this.redirectUri);
    }

    // await saveService();
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
      search.forEach(
        (pages) {
          pages.items.forEach(
            (track) async {
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

                searchResults.add(Song(
                    id, uri, trackName, artists, imageUri, duration, service));
              }
            },
          );
        },
      );
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
  Future<void> pause() {
    // TODO: implement pause
    throw UnimplementedError();
  }

  @override
  Future<void> play(String uri) {
    // TODO: implement play
    throw UnimplementedError();
  }

  @override
  Future<void> resume() {
    // TODO: implement resume
    throw UnimplementedError();
  }

  @override
  Future<List<Song>> search(String uri) {
    // TODO: implement search
    throw UnimplementedError();
  }
}
