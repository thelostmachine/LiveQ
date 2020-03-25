import 'package:flutter/material.dart';
import 'package:liveq/utils/routing_constants.dart';
import 'package:liveq/utils/router.dart' as router;

class LiveQApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LiveQ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: router.generateRoute,
      initialRoute: RootPageRoute,
    );
  }
}
