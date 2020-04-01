import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/crossfade_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class Services extends StatefulWidget {

  final String clientId = '03237b2409b24752a3f0c33262ad2d02';
  final String clientSecret = '52560cee72394fc5a049731f2d8f001e';
  final String redirectUri = 'spotify-ios-quick-start://spotify-login-callback';

  @override
  _ServicesState createState() => _ServicesState();
}

class _ServicesState extends State<Services> {

  bool _loading = false;
  var authenticationToken = '';

  CrossfadeState crossfadeState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connect Services')
      ),
      body: _flowWidget(context),
    );
  }

  Widget _flowWidget(BuildContext context) {
    return StreamBuilder<ConnectionStatus>(
      stream: SpotifySdk.subscribeConnectionStatus(),
      builder: (context, snapshot) {
        bool _connected = false;
        if (snapshot.data != null) {
          _connected = snapshot.data.connected;
        }

        return Stack(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  child: Icon(Icons.settings_remote),
                  onPressed: () => connectToSpotifyRemote(),
                ),
                FlatButton(
                  child: Text('Apple'),
                  onPressed: () {},
                )
              ],
            )
          ],
        );
      }
    );
  }

  Future<void> connectToSpotifyRemote() async {
    try {
      setState(() {
        _loading = true;
      });

      var result = await SpotifySdk.connectToSpotifyRemote(
        clientId: widget.clientId,
        redirectUrl: widget.redirectUri
      );

      print(result ? 'connect successful' : 'connect failed');

      getAuthenticationToken();


      setState(() {
        _loading = false;
      });
    } on PlatformException catch (e) {
      setState(() {
        _loading = false;
      });
    } on MissingPluginException {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> getAuthenticationToken() async {
    try {
      var authenticationToken = await SpotifySdk.getAuthenticationToken(
        clientId: widget.clientId,
        redirectUrl: widget.redirectUri
      );

      print('token: $authenticationToken');

      var response = await http.get('https://api.spotify.com/v1/search/?q=paradise&type=track&market=US', headers: {
        'Authorization': 'Bearer $authenticationToken',
      });

      // if (response.statusCode == 200) {
      //   var jsonrespone = convert.jsonDecode(response.body);

      //   for (var item in jsonrespone['tracks']['items']) {
      //     for (var artist in word['album']['artists']) {
      //       print('${word['album']}');// artist['name']);
      //     }
      //     // print(word['album'])
      //   }
      //   // print(jsonrespone['tracks']['items']['artists']['name']);

      // } else {
      //   print('REQUEST FAILED');
      // }

      setState(() {
        this.authenticationToken = authenticationToken;
      });
    } on PlatformException catch (e) {
      
    } on MissingPluginException {

    }
  }
}