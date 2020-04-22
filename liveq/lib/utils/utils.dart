import 'package:flutter/foundation.dart';

import 'package:liveq/utils/client_interface.dart';

enum PlayerState {
  playing,
  paused,
  stopped,
}

class RoomArguments {
  String roomID = '';
  String roomName = '';
  final bool host;

  RoomArguments({this.roomID, this.roomName, this.host});
}

class SearchArguments {
  String searchService = '';
  // Service searchService = '';
  List<String> allowedServices;

  SearchArguments({this.searchService, this.allowedServices});
}

Client client = Client();
