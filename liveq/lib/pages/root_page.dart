import 'package:flutter/material.dart';

class RootPage extends StatelessWidget {
  RootPage({this.title});

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
            buttonNext(context, 'join a room'),
            buttonNext(context, 'create new room'),
          ],
        ),
      ),
    );
  }
}

RaisedButton buttonNext(BuildContext context, String content) {
  content = content.toUpperCase();
  return RaisedButton(
    onPressed: () {},
    textColor: Colors.white,
    color: Color(0xffed6c6c),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6),
    ),
    child: Container(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        '$content',
        style: Theme.of(context).textTheme.button.merge(
              TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
      ),
    ),
  );
}
