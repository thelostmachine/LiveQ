import 'package:flutter/material.dart';

import 'package:liveq/widgets/next_button.dart';
import 'package:liveq/widgets/room_dialog.dart';

class Home extends StatelessWidget {
  final myController = TextEditingController();

  Home({Key key}) : super(key: key);

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
                  NextButton('CREATE NEW ROOM',
                      () => createRoomDialog(context, myController)),
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
