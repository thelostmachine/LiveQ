import 'package:flutter/material.dart';

import 'pages/login.dart';
import 'pages/room.dart';
import 'pages/search.dart';
import 'pages/services.dart';

void main() => runApp(
  MaterialApp(
    initialRoute: '/login',
    routes: {
      '/login': (context) => Login(),
      '/room': (context) => Room(),
      '/search': (context) => Search(),
      '/services': (context) => Services(),
    }
  )
);
