import 'dart:io';

// import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:spotify_sdk/spotify_sdk.dart';

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
  String authenticationToken;

  // SpotifyApi spotifyWebApi;

  static final Service _spotify = Spotify._internal();

  Spotify._internal();

  factory Spotify() {
    return _spotify;
  }

  /// Connect to the SpotifySDK and get an [authenticationToken]
  @override
  Future<bool> connect() async {

    // Connect to Spotify only if on mobile
    if (kIsWeb) {
      // print(dart)
      // var credentials = SpotifyApiCredentials(clientId, clientSecret);
      // spotifyWebApi = SpotifyApi(credentials);
      return true;
      // return spotifyWebApi != null;
    } else {
      
      var result = await SpotifySdk.connectToSpotifyRemote(
        clientId: this.clientId,
        redirectUrl: this.redirectUri);

      // Get Authentication Token for Search
      authenticationToken = await SpotifySdk.getAuthenticationToken(
        clientId: this.clientId,
        redirectUrl: this.redirectUri);

      return result != null && authenticationToken != null;
    }
  }

  /// Pause a [Song]]
  @override
  Future<void> pause() async {
    await SpotifySdk.pause();
    // try {
    //   await SpotifySdk.pause();
    // } on PlatformException catch (e) {

    // } on MissingPluginException {

    // }
  }

  /// Play a [Song] given a [uri]
  @override
  Future<void> playTrack(String uri) async {
    await SpotifySdk.play(spotifyUri: uri);
    // try {
    //   await SpotifySdk.play(spotifyUri: uri);
    // } on PlatformException catch (e) {

    // } on MissingPluginException {

    // }
  }

  /// Resume the [Song] playing right now
  @override
  Future<void> resume() async {
    await SpotifySdk.resume();
    // try {
    //   await SpotifySdk.resume();
    // } on PlatformException catch (e) {

    // } on MissingPluginException {

    // }
  }

  /// Use the [authenticationToken] to search a query using the Spotify Web API
  @override
  Future<List<Song>> search(String query) async {
    if (kIsWeb) {
      return searchWeb(query);
    } else {
      return searchSDK(query);
    }
    // List<Song> searchResults = List();

    // String search = 'https://api.spotify.com/v1/search/?type=track&market=US&q=';
    // search += formatQuery(query);

    // var response = await http.get(search, headers: {
    //   'Authorization': 'Bearer ${this.authenticationToken}'
    // });

    // if (response.statusCode == 200) {
    //   var jsonResponse = convert.jsonDecode(response.body);

    //   searchResults = getSongs(jsonResponse);
    // }

    // return searchResults;
  }

  Future<List<Song>> searchSDK(String query) async {
    List<Song> searchResults = List();

    String search = 'https://api.spotify.com/v1/search/?type=track&market=US&q=';
    search += formatQuery(query);

    var response = await http.get(search, headers: {
      'Authorization': 'Bearer ${this.authenticationToken}'
    });

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      searchResults = getSongs(jsonResponse);
    }

    return searchResults;
  }

  Future<List<Song>> searchWeb(String query) async {
    List<Song> searchResults = List();

    // var search = await spotifyWebApi.search
    //   .get(query)
    //   .first(2)
    //   .catchError((err) => print((err as SpotifyException).message));

    // if (search != null) {

    //   search.forEach((pages) {
    //     pages.items.forEach((item) {
    //       if (item is TrackSimple) {
    //         String id = item.id;
    //         String uri = item.uri;
    //         String trackName = item.name;
    //         String artist = item.artists[0].name;
    //         Service service = this;

    //         searchResults.add(Song(id, uri, trackName, artist, service));
    //       }
    //      });
    //    });
    // }

    return searchResults;
  }

  /// Formats a query by converting spaces to `%20` for [http] requests
  String formatQuery(String query) {
    return query.replaceAll(' ', '%20');
  }

  /// Parses the [jsonResponse] from an [http] request to produce a List of [Song] objects
  List<Song> getSongs(var jsonRespone) {
    List<Song> songs = List();

    for (var item in jsonRespone['tracks']['items']) {
      String id = item['id'];
      String uri = item['uri'];
      String trackName = item['name'];
      String artist = item['artists'][0]['name'];
      Service service = this;

      songs.add(Song(id, uri, trackName, artist, service));
    }

    return songs;
  } 
}