import 'package:flutter/material.dart';
import 'package:liveq/utils/song.dart';

import 'package:flutter/services.dart';
import 'package:spotify_sdk/models/crossfade_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/models/player_context.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/image_uri.dart';

class Search extends StatefulWidget {

  @override
  _SearchState createState() => new _SearchState();
}

class _SearchState extends State<Search> {

  List<Song> items = List();
  TextEditingController editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {

  }

  void filterSearchResults(String query) {
    
    // if (query.isNotEmpty) {
    //   List<Song>
    // }

  }
}