enum PlayerState {
  playing,
  paused,
  stopped,
}

class RoomArguments {
  final String roomID;
  final String roomName;
  final bool host;

  RoomArguments(this.roomID, this.roomName, this.host);
}
