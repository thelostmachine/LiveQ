import 'package:flutter/material.dart';

class Login extends StatelessWidget {

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LiveQ',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.

        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(title: 'LiveQ'),
    );
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen({this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
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
