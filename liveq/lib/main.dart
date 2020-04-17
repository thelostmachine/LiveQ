import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'package:liveq/pages/home.dart';
import 'package:liveq/pages/room.dart';
import 'package:liveq/pages/search.dart';
// import 'package:liveq/pages/connect_services.dart';
import 'package:liveq/pages/connect_services_new.dart';
import 'package:liveq/utils/services.dart';
import 'package:liveq/pages/soundcloud.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Service.loadServices();
  runApp(
    MaterialApp(
      title: 'LiveQ',
      theme: ThemeData(
        primarySwatch: MaterialColor(
          Colors.red[400].value,
          <int, Color>{
            50: Colors.red[50],
            100: Colors.red[50],
            200: Colors.red[100],
            300: Colors.red[200],
            400: Colors.red[300],
            500: Colors.red[400],
            600: Colors.red[500],
            700: Colors.red[600],
            800: Colors.red[700],
            900: Colors.red[800],
          },
        ),
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => Home(),
        '/room': (context) => Room(),
        '/search': (context) => Search(),
        '/connect_services': (context) => ConnectServices(),
        // '/sound': (context) => SoundCloud(),
      },
    ),
  );
}
