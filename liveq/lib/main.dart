import 'package:flutter/material.dart';

import 'pages/home.dart';
import 'pages/room.dart';
import 'pages/search.dart';
import 'pages/connect_services.dart';

void main() =>
    runApp(MaterialApp(title: 'LiveQ', initialRoute: '/room', routes: {
      '/home': (context) => Home(),
      '/room': (context) => Room(),
      '/search': (context) => Search(),
      '/services': (context) => ConnectServices(),
    }));
