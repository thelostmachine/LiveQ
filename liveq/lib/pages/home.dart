import 'package:flutter/material.dart';
import 'package:liveq/utils/player.dart';
import 'package:provider/provider.dart';

import 'package:liveq/widgets/next_button.dart';
import 'package:liveq/widgets/room_dialog.dart';
import 'package:liveq/models/catalog.dart';

class Home extends StatelessWidget {
  final myController = TextEditingController();

  final Player player = Player();

  Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 1.5,
                child: Center(
                  child: Text(
                    'LiveQ',
                    style: Theme.of(context).textTheme.headline3.merge(
                          TextStyle(fontWeight: FontWeight.bold),
                        ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Consumer<CatalogModel>(builder: (context, catalog, child) {
                      return NextButton(
                        'CREATE NEW ROOM',
                        catalog.connectedServices.isNotEmpty == true
                            ? () => createRoomDialog(context, myController)
                            : () => Navigator.pushNamed(
                                context, '/connect_services'),
                      );
                    }),
                    NextButton('JOIN A ROOM',
                        () => joinRoomDialog(context, myController)),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.settings),
              tooltip: 'Service Connection Settings',
              onPressed: () {
                Navigator.pushNamed(context, '/connect_services');
              },
            ),
          )
        ],
      ),
    );
  }
}
