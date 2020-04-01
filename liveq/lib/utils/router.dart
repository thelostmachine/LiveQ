import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:liveq/utils/routing_constants.dart';

import 'package:liveq/pages/root_page.dart';
import 'package:liveq/pages/join_room_page.dart';
import 'package:liveq/pages/undefined_page.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RootPageRoute:
      return MaterialPageRoute(builder: (context) => RootPage());
    case JoinRoomPageRoute:
      return MaterialPageRoute(builder: (context) => JoinRoomPage());
    // case ServicesPageRoute:
    //   return MaterialPageRoute(builder: (context) => ServicesPage());
    // case RoomPageRoute:
    // var argument = settings.arguments;
    //   return MaterialPageRoute(builder: (context) => RoomPage(argument: argument));
    default:
      return MaterialPageRoute(
          builder: (context) => UndefinedPage(name: settings.name));
  }
}
