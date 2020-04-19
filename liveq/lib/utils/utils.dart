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

Client client = Client();
