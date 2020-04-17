import 'package:liveq/utils/client.dart';

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
