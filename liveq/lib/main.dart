import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'pages/home.dart';
import 'pages/room.dart';
import 'pages/search.dart';
import 'pages/connect_services.dart';

void main() =>
    runApp(MaterialApp(title: 'LiveQ', initialRoute: '/room', routes: {
      '/home': (context) => Home(),
      '/room': (context) => Room(),
      '/search': (context) => Search(),
      '/connect_services': (context) => ConnectServices(),
      '/sound': (context) => SoundCloud(),
    }));



class SoundCloud extends StatefulWidget {
  @override
  SoundCloudState createState() => SoundCloudState();
}

class SoundCloudState extends State<SoundCloud> {
  String _fileText;

  final flutterWebviewPlugin = FlutterWebviewPlugin();

  @override
  Widget build(BuildContext context) {
    rootBundle.loadString('assets/soundcloud.html').then((value) {
      setState(() {
        _fileText = value;
      });
    });

    return WebviewScaffold(
      appBar: AppBar(
        title: Text('SoundCloud'),
      ),
      // initialChild: SizedBox(height: 10),
      url: Uri.dataFromString(
        _fileText,
        mimeType: 'text/html',
      ).toString(),
      withJavascript: true,
      bottomNavigationBar: BottomAppBar(
        child: RaisedButton(
          child: Text('Hide'),
          onPressed: () => flutterWebviewPlugin.hide()
        )
      ),
    );
  }
}
