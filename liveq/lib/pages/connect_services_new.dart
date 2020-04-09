import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/crossfade_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

import 'package:liveq/widgets/link_text.dart';
import 'package:liveq/utils/services.dart';

class ConnectServices extends StatefulWidget {
  @override
  _ConnectServicesState createState() => _ConnectServicesState();
}

class _ConnectServicesState extends State<ConnectServices> {
  bool _loading = false;
  bool _didConnect = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Services'),
      ),
      body: _flowWidget(context),
    );
  }

  Widget _listPotentialServices(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("Link and select your music services",
            style: Theme.of(context).textTheme.subtitle1),
        Text("You must select at least one service to create a room.",
            style: Theme.of(context).textTheme.bodyText2),
        Expanded(
          child: ListView.separated(
            physics: BouncingScrollPhysics(),
            itemCount: Service.potentialServices.length,
            // itemExtent: 110,
            separatorBuilder: (BuildContext context, int index) =>
                Divider(height: 1),
            itemBuilder: (BuildContext context, int index) {
              return Service.connectedServices
                          .contains(Service.potentialServices[index]) ==
                      true
                  ? CheckboxListTile(
                      title: Text(Service.potentialServices[index].name),
                      value: Service.connectedServices
                          .contains(Service.potentialServices[index]),
                      onChanged: (bool value) {
                        setState(() {
                          value
                              ? Service.connectedServices
                                  .add(Service.potentialServices[index])
                              : Service.connectedServices
                                  .remove(Service.potentialServices[index]);
                        });
                      },
                      secondary:
                          Service.potentialServices[index].getImageIcon(),
                    )
                  : Column(
                      children: <Widget>[
                        CheckboxListTile(
                          title: Text(Service.potentialServices[index].name),
                          value: Service.connectedServices
                              .contains(Service.potentialServices[index]),
                          onChanged: null,
                          secondary:
                              Service.potentialServices[index].getImageIcon(),
                        ),
                        Row(
                          children: <Widget>[
                            LinkText(() => {}),
                            // Launch circular progress indicator when link is clicked - error icon displayed if connecting failed
                          ],
                        )
                      ],
                    );
            },
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  onPressed: Service.canCreateRoom()
                      ? () => {
                            //Service.saveService(); // save connected services
                          }
                      : null,
                  child: Row(
                    children: <Widget>[
                      const Text('DONE'),
                      Icon(Icons.done),
                    ],
                  ),
                ),
              ],
            )
          ],
        )
      ],
    );
  }

  /// use a ListView.Builder using player.potentialServices
  /// use player.potentialServices[index].connect() to connect. It'll set the service
  /// automatically
  Widget _flowWidget(BuildContext context) {
    return StreamBuilder<ConnectionStatus>(
        stream: SpotifySdk.subscribeConnectionStatus(),
        builder: (context, snapshot) {
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

                        Service.potentialServices[0].connect();

                        setState(() {
                          _loading = false;
                        });
                      },
                      icon: Icon(MdiIcons.spotify),
                      label: Text('Spotify')),
                  RaisedButton.icon(
                    onPressed: () {},
                    icon: Icon(MdiIcons.music),
                    label: Text('SoundCloud'),
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
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          );
        });
  }
}
