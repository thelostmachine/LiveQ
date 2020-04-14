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
        body: _listPotentialServices(context),
      ),
    );
  }

  Widget _listPotentialServices(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          "Select your music services",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        Text(
          "You must select at least one service to create a room.",
          style: Theme.of(context).textTheme.bodyText2,
        ),
        Expanded(
          child: ListView.separated(
            physics: BouncingScrollPhysics(),
            itemCount: Service.potentialServices.length,
            // itemExtent: 110,
            separatorBuilder: (BuildContext context, int index) =>
                Divider(height: 1),
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
                secondary: Service.potentialServices[index].getImageIcon(),
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
                      ? () => Service
                          .saveServices() // save connected services to cache
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

  void linkService(Service _linkingService) async {
    setState(() {
      _loading = true;
    });

    await _linkingService.connect();
    //if error connecting return false, else return true

    setState(() {
      _loading = false;
    });
  }
}
