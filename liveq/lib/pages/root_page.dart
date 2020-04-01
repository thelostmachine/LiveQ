import 'package:flutter/material.dart';
import 'package:liveq/widgets/lq_next_button.dart';

class RootPage extends StatelessWidget {
  RootPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.headline4.merge(
                    TextStyle(fontWeight: FontWeight.bold),
                  ),
            ),
            SizedBox(height: 150),
            NextButton('JOIN A ROOM'),
            NextButton('CREATE NEW ROOM'),
          ],
        ),
      ),
    );
  }
}
