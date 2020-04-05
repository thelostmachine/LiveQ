import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:spotify/spotify.dart';

import 'song.dart';

abstract class Service {

  String name;

  Future<bool> connect();

  Future<void> playTrack(String uri);
  Future<void> resume();
  Future<void> pause();

  Future<List<Song>> search(String query);

}

class Spotify extends Service {

  final String name = "Spotify";

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
        clientId: this.clientId,
        redirectUrl: this.redirectUri);
    }

    return spotifyWebApi != null;
  }

  /// Pause a [Song]]
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
            String id = item.id;
            String uri = item.uri;
            String trackName = item.name;
            String artist = item.artists[0].name;
            Service service = this;

            searchResults.add(Song(id, uri, trackName, artist, service));
          }
         });
       });
    }

    return searchResults;
  }
}