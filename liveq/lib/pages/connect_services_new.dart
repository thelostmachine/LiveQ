import 'package:flutter/material.dart';
import 'package:spotify_sdk/models/connection_status.dart';
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
    return WillPopScope(
      onWillPop: () {
        Service.saveServices(); // save connected services to cache
        Navigator.pop(context, true);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Music Services'),
        ),
        body: _listPotentialServices(),
      ),
    );
  }

  Widget _listPotentialServices() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 16.0, top: 24.0, right: 16.0),
          child: Text(
            "Select your music services",
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            "You must select at least one service to create a room.",
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
        Divider(),
        Expanded(
          child: ListView.separated(
            physics: BouncingScrollPhysics(),
            itemCount: Service.potentialServices.length,
            // itemExtent: 110,
            separatorBuilder: (BuildContext context, int index) =>
                Divider(), //TODO: Figure out why dividers are not showing
            itemBuilder: (BuildContext context, int index) {
              return CheckboxListTile(
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
                    Service.potentialServices[index].iconImagePath != null
                        ? Service.potentialServices[index].getImageIcon()
                        : Icon(Icons.library_music),
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    onPressed: Service.canCreateRoom()
                        ? () {
                            Service
                                .saveServices(); // save connected services to cache
                            Navigator.pop(context);
                          }
                        : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Text('DONE'),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  // void linkService(Service _linkingService) async {
  //   setState(() {
  //     _loading = true;
  //   });

  //   await _linkingService.connect();
  //   //if error connecting return false, else return true

  //   setState(() {
  //     _loading = false;
  //   });
  // }
}
