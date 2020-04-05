import 'package:flutter/material.dart';

import 'pages/home.dart';
import 'pages/room.dart';
import 'pages/search.dart';
import 'pages/services.dart';

void main() =>
    runApp(MaterialApp(title: 'LiveQ', initialRoute: '/home', routes: {
      '/home': (context) => Home(),
      '/room': (context) => Room(),
      '/search': (context) => Search(),
      '/services': (context) => Services(),
    }));
