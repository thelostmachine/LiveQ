import 'package:flutter/material.dart';

import 'package:liveq/widgets/next_button.dart';
import 'package:liveq/widgets/room_dialog.dart';
import 'package:liveq/utils/services.dart';

class Home extends StatelessWidget {
  final myController = TextEditingController();

  Home({Key key}) : super(key: key);

  //TODO: Add connect_service settings button
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 1.5,
              child: Center(
                child: Text(
                  'LiveQ',
                  style: Theme.of(context).textTheme.headline4.merge(
                        TextStyle(fontWeight: FontWeight.bold),
                      ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  NextButton(
                    'CREATE NEW ROOM',
                    Service.connectedServices.isNotEmpty ==
                            true // Add notify_listeners here
                        ? () => createRoomDialog(context, myController)
                        : () =>
                            Navigator.pushNamed(context, '/connect_services'),
                  ),
                  NextButton('JOIN A ROOM',
                      () => joinRoomDialog(context, myController)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
