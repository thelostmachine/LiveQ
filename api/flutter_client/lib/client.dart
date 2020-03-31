import 'package:grpc/grpc.dart';
import 'interface.pb.dart';
import 'interface.pb.dart';
import 'interface.pbgrpc.dart';


class Client {
  ClientChannel channel;
  LiveQClient stub;

  Future<void> main(List<String> args) async {
    channel = ClientChannel('127.0.0.1', port: 8080, options: const ChannelOptions(credentials: ChannelCredentials.insecure()));  
    stub = LiveQClient(channel, options: CallOptions(timeout: Duration(seconds: 30)));
    String key = await testCreateRoom();
    await testJoinRoom(key);
    await testAddSong(key);
    //await testDeleteSong(key);
    //await testUpdateQueue(key);
    await channel.shutdown();
  }

  Future<String> testCreateRoom() async {
    final msg = CreateRequest()
      ..roomName = 'testroom';
    final createReply = await stub.createRoom(msg);

    return createReply.roomKey;
  }

  Future<void> testJoinRoom(String key) async{
    final msg = JoinRequest()
      ..roomKey = key;
    final joinReply = await stub.joinRoom(msg);
    print(joinReply.guestId);
  }

  Future<void> testAddSong(String key) async{
    final songObj = QueueReply()
      ..songId = '2'
      ..serviceId = '1';

    final msg = SongRequest()
      ..song = songObj
      ..roomKey = key;
    try {
      
      await for (var queueReply in stub.addSong(msg)) {
        print(queueReply.songId);
      }
    }
    catch (e) {
      print('Error: $e');
    }
    final songObj2 = QueueReply()
      ..songId = '123'
      ..serviceId = '5666';
    final msg2 = SongRequest()
      ..song = songObj2
      ..roomKey = key;

    await for (var song in stub.addSong(msg2)) {
      print(song.songId);
    }
    
  }

  Future<void> testDeleteSong(String key) async{

  }

  void testUpdateQueue(String key) async{ 

  }
}