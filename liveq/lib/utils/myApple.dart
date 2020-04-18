import 'package:http/http.dart' as http;
import 'package:flutter_sound/flutter_sound.dart';
import 'song.dart';

class AppleSong{

  final String title;
  final String artist;
  final String id;
  final String href;
  final String albumImage;
  final int duration;

  AppleSong(
    {
      this.id,
      this.href,
      this.title,
      this.artist,
      this.albumImage,
      this.duration
    }
  );


  factory AppleSong.fromJson(Map<String, dynamic> json){
    return AppleSong(

      id: json['id'],
      href: json['href'],
      title: json['attributes']['name'],
      artist: json['attributes']['artistName'],
      albumImage: json['attributes']['artwork']['url'],
      duration: json['attributes']['durationInMillis"]']

    );

  }


  Song toSong(){

    Song temp;

    temp.id=this.id;
    temp.uri=this.href;
    temp.trackName=this.title;
    temp.artists=this.artist;
    temp.duration=this.duration;
    temp.imageUri=this.albumImage;

    return temp;

  }

}

