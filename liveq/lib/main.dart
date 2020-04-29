import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:liveq/pages/home.dart';
import 'package:liveq/pages/room.dart';
import 'package:liveq/pages/search.dart';
import 'package:liveq/pages/connect_services.dart';
import 'package:liveq/models/catalog.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => CatalogModel(),
      child: MaterialApp(
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
          '/room': (context) => RoomProvider(),
          '/search': (context) => Search(),
          '/connect_services': (context) => ConnectServices(),
        },
      ),
    ),
  );
}
