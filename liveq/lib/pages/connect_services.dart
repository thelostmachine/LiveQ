import 'package:flutter/material.dart';
import 'package:liveq/utils/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/crossfade_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class ConnectServices extends StatefulWidget {

  @override
  _ConnectServicesState createState() => _ConnectServicesState();
}

class _ConnectServicesState extends State<ConnectServices> {

  bool _loading = false;

  CrossfadeState crossfadeState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connect ConnectServices'),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton.icon(
                  onPressed: () async {
                    setState(() {
                      _loading = true;
                    });

                    await Spotify().connect();

                    setState(() {
                      _loading = false;
                    });
                  },
                  icon: Icon(MdiIcons.spotify),
                  label: Text('Spotify')),
                RaisedButton.icon(
                  onPressed: () {},
                  icon: Icon(MdiIcons.music),
                  label: Text('Apple Music'),
                ),
              ],
            ),
            _loading
              ? Container(
                color: Colors.black12,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Connecting...'),
                      SizedBox(height: 10),
                      CircularProgressIndicator()
                    ],
                  )
                )
              )
              : SizedBox(),
          ],
        );
      }
    );
  }
}