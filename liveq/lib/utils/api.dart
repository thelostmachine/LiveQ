import 'package:http/http.dart' as http;
import 'package:liveq/utils/services.dart';
import 'dart:convert' as convert;
import 'dart:io';

import 'package:liveq/utils/song.dart';

enum Endpoint {
  guests,
  rooms,
  songs,
  services,
}

extension EndpointsExtension on Endpoint {
  String get value {
    switch (this) {
      case Endpoint.guests:
        return 'guests/';
      case Endpoint.rooms:
        return 'rooms/';
      case Endpoint.songs:
        return 'songs/';
      case Endpoint.services:
        return 'services/';
      default:
        return null;
    }
  }
}

class Api {
  
  static final String baseUri = 'https://api.shaheermirza.dev/';
  
  static String roomKey;
  static String roomName;

  static Future<String> createRoom(String roomName) async {
    var response = await postRequest(
      Endpoint.rooms,
      convert.jsonEncode({
        'room_name' : roomName
      })
    );

    roomKey = response['room_key'] ?? null;
    return roomKey;

  }

  static Future<String> joinRoom(String roomKey) async {
    var response = await getRequest(
      Endpoint.rooms,
      roomKey
    );
    Api.roomKey = roomKey;
    return response[0]['room_name'] ?? null;
  }

  static void deleteRoom() {
    deleteRequest(Endpoint.rooms, Api.roomKey).then((deleted) {
      if (deleted) {
        Api.roomKey = '';
        Api.roomName = '';
      }
    });
  }

  static void leaveRoom() {
    
  }

  static void addSong(Song song) async {
    postRequest(
      Endpoint.songs,
      convert.jsonEncode({
        'room' : roomKey,
        'track_id' : song.trackId,
        'uri' : song.uri,
        'track_name' : song.trackName,
        'artists' : song.artists,
        'duration' : song.duration.toString(),
        'image_uri' : song.imageUri,
        'service' : song.service.name
      })
    );
  }

  static void deleteSong(Song song) async {
    deleteRequest(Endpoint.songs, song.pk.toString());
  }

  static Future<List<Song>> getQueue() async {
    var response = await getRequest(
      Endpoint.songs,
      roomKey
    );

    List<Song> songs = List();
    for (var item in response) {
      songs.add(Song(
        item['id'],
        item['track_id'],
        item['uri'],
        utf8convert(item['track_name'].toString()),
        utf8convert(item['artists'].toString()),
        item['image_uri'],
        item['duration'],
        Service.fromString(item['service'])
      ));
    }

    return songs;
  }

  static String utf8convert(String text) {
    List<int> bytes = text.toString().codeUnits;
    return convert.utf8.decode(bytes);
  }

  static void addService(String service) async {
    postRequest(
      Endpoint.services,
      convert.jsonEncode({
        'room' : roomKey,
        'service_type' : service
      })
    );
  }

  static Future<List<String>> getServices() async {
    var response = await getRequest(
      Endpoint.services,
      Api.roomKey
    );

    List<String> services = List();
    for (var item in response) {
      services.add(item['service_type']);
    }

    return services;
  }


  
  // TODO: FIX EMOJI ENCODING (JRAFFE)

  static Future<dynamic> getRequest(Endpoint endpoint, String query) async {
    String url = baseUri + endpoint.value + '?search=$query';
    final response = await http.get(url);
    return convert.jsonDecode(response.body);
  }

  static Future<dynamic> postRequest(Endpoint endpoint, String json) async {
    String url = baseUri + endpoint.value;
    print(url);
    print(json);
    final response = await http.post(url, body: json, headers: {
      'Content-Type': 'application/json'
    });
    return convert.jsonDecode(response.body);
  }

  static Future<bool> deleteRequest(Endpoint endpoint, String pk) async {
    String url = '$baseUri${endpoint.value}$pk/';
    final response = await http.delete(url);
    return response.statusCode == 204;
  }
}