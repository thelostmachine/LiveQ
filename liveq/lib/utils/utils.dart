enum Service {
  Spotify,
  Apple,
}

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

bool DEBUG = true;
String TOKEN =
    'BQCZniS3DpcULGc4N0JnNsuj7kcXqJBS4mVAxYVJOfyK0C8-Xa2DrDejUk2wcIGa3OQc-Ek4kbi3uP81yBQc9jPafrb7LoFzgbyxwcf7qWq_rZBNqRTa30kBtQJMjgCqobiBXeLjHBXhAlYXUd6HLpLS9stASdceHOLz-s5qE6KoiZ6_cA53KBd30YUZ3ZXKDt-bfWlZ2RFGNGJVQIrstVzJcYvS7w';
