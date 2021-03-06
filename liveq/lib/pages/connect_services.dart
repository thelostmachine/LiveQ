import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:liveq/widgets/link_text.dart';
import 'package:liveq/models/catalog.dart';

class ConnectServices extends StatefulWidget {
  @override
  _ConnectServicesState createState() => _ConnectServicesState();
}

class _ConnectServicesState extends State<ConnectServices> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        // save connected services to cache
        Provider.of<CatalogModel>(context, listen: false).saveServices();
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
            style: Theme.of(context).textTheme.headline6.merge(
                  TextStyle(fontWeight: FontWeight.w600),
                ),
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
          child: Consumer<CatalogModel>(
            builder: (context, catalog, child) {
              return ListView.separated(
                physics: BouncingScrollPhysics(),
                itemCount: catalog.potentialServices.length,
                // itemExtent: 110,
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(), // TODO: Figure out why dividers are not showing
                itemBuilder: (BuildContext context, int index) {
                  return CheckboxListTile(
                    title: Text(
                        Provider.of<CatalogModel>(context, listen: false)
                            .potentialServices[index]
                            .name),
                    value: catalog.connectedServices.contains(
                        Provider.of<CatalogModel>(context, listen: false)
                            .potentialServices[index]),
                    onChanged: (kIsWeb == true &&
                            Provider.of<CatalogModel>(context, listen: false)
                                    .potentialServices[index]
                                    .name ==
                                CatalogModel.SPOTIFY)
                        ? null
                        : (bool value) {
                            setState(() {
                              value
                                  ? catalog.addToConnectedServices(
                                      Provider.of<CatalogModel>(context,
                                              listen: false)
                                          .potentialServices[index])
                                  : catalog.removeFromConnectedServices(
                                      Provider.of<CatalogModel>(context,
                                              listen: false)
                                          .potentialServices[index]);
                            });
                          },
                    secondary: catalog.potentialServices[index].getImageIcon(),
                  );
                },
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Consumer<CatalogModel>(
                      builder: (context, catalog, child) {
                        return FlatButton(
                          onPressed: catalog.canCreateRoom()
                              ? () {
                                  // save connected services to cache
                                  catalog.saveServices();
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
                        );
                      },
                    ),
                  ),
                ],
              ),
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
