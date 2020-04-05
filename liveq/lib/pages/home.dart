import 'package:flutter/material.dart';

import 'package:liveq/widgets/next_button.dart';
import 'package:liveq/widgets/room_dialog.dart';
import 'package:liveq/utils/utils.dart';

class Home extends StatelessWidget {
  final myController = TextEditingController();

  Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'LiveQ',
              style: Theme.of(context).textTheme.headline4.merge(
                    TextStyle(fontWeight: FontWeight.bold),
                  ),
            ),
            SizedBox(height: 150),
            NextButton(
                'JOIN A ROOM', () => joinRoomDialog(context, myController)),
            NextButton('CREATE NEW ROOM', () => {}),
          ],
        ),
      ),
    );
  }
}
