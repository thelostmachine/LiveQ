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
    'BQCyKV5f6gDZVWsemlB9clC7QQGG8DzLWVGn4L5QnK8mG8aXsFzZjdv5-IhDKgl1ShoXHPjdZDSiu7q7YSME6iXwnoiHGjT5hUsGjv7ZHdxLpchnDABK9ZS6JBovSnhECWKdgz09PrMtmPhrQ6dCrisssD3HGx5-icpQepiNYrWGVDR7mCj7M1JqQ77Hnh4vbgna6tM51doYfDqu4MSe66lgeY8uYA';
