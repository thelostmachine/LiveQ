import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:spotify/spotify.dart';

import 'package:liveq/utils/song.dart';

abstract class Service {
  static const String SPOTIFY = 'Spotify';
  static const String APPLE = 'Apple';

  String name;

  static List<Service> services = List();

  Future<bool> connect();

  Future<void> playTrack(String uri);
  Future<void> resume();
  Future<void> pause();
  Future<void> stop();

  Future<List<Song>> search(String query);

  Future<void> saveService() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!services.contains(this)) {
      services.add(this);

      List<String> serviceStrings = List();
      services.forEach((s) {
        serviceStrings.add(s.name);
      });

      prefs.setStringList('serviceList', serviceStrings);
    }
  }

  static Future<List<String>> canConnectToPreviousService() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> serviceStrings = prefs.getStringList('serviceList') ?? null;
    return serviceStrings;
  }

  static Future<Service> loadServices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> serviceStrings = prefs.getStringList('serviceList') ?? null;

    if (serviceStrings != null) {
      for (String s in serviceStrings) {
        Service service = fromString(s);
        await service.connect();
      }
    }

    return (services.length > 0) ? services[0] : null;
  }

  static Service fromString(String service) {
    switch (service) {
      case SPOTIFY:
        return Spotify();
      case APPLE:
        return null;
    }
  }
}

class Spotify extends Service {
  final String name = Service.SPOTIFY;

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
    // Use the spotify package to create credentials. This is only needed for Search
    var credentials = SpotifyApiCredentials(clientId, clientSecret);
    spotifyWebApi = SpotifyApi(credentials);

    // Use the spotify_sdk package if on mobile to allow playing
    if (!kIsWeb) {
      await SpotifySdk.connectToSpotifyRemote(
          clientId: this.clientId, redirectUrl: this.redirectUri);
    }

    await saveService();
    return spotifyWebApi != null;
  }

  /// Pause a [Song]
  @override
  Future<void> pause() async {
    await SpotifySdk.pause();
  }

  /// Play a [Song] given a [uri]
  @override
  Future<void> playTrack(String uri) async {
    await SpotifySdk.play(spotifyUri: uri);
  }

  /// Resume the [Song] playing right now
  @override
  Future<void> resume() async {
    await SpotifySdk.resume();
  }

  /// Stop a [Song]
  @override
  Future<void> stop() async {
    // await SpotifySdk.stop();
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
        pages.items.forEach((item) {
          if (item is TrackSimple) {
            String _id = item.id;
            String _uri = item.uri;
            String _trackName = item.name;
            String _artist = item.artists[0].name;
            List<String> _artistNames =
                item.artists.map((val) => val.name).toList();
            String _artists = _artistNames.join(", ");
            int _duration = item.durationMs;
            Service service = this;

            searchResults
                .add(Song(_id, _uri, _trackName, _artists, _duration, service));
          }
        });
      });
    }

    return searchResults;
  }
}
