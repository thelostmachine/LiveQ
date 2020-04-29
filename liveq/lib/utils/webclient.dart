// import 'interface.pb.dart';
// import 'interface.pbgrpc.dart';
// import 'song.dart';
// import 'package:liveq/utils/services.dart' as services;
// import 'package:grpc/grpc_web.dart';
// import 'package:liveq/utils/client_interface.dart' as grpcClient;

// class WebClient implements grpcClient.Client {
//   LiveQClient stub;
//   String key;
//   String id;
//   GrpcWebClientChannel channel;
  
//   WebClient() {
//     // channel = GrpcWebClientChannel.xhr(Uri.parse('http://34.71.85.54:8080'));
//     channel = GrpcWebClientChannel.xhr(Uri.parse('https://api.shaheermirza.dev/'));
//     // channel = GrpcWebClientChannel.xhr(Uri.parse('localhost:8080'));
//     stub = LiveQClient(channel, options: CallOptions(timeout: Duration(seconds: 30)));
//   }

//   Future<String> CreateRoom(String room_name) async {
//     final msg = CreateRequest()
//       ..roomName = room_name;
//     print('calling stub');
//     final createReply = await stub.createRoom(msg);
//     print('done');
//     if(createReply.status.status == 0){
//       key = createReply.roomKey;
//       id = createReply.hostId;
//       return createReply.roomKey;
//     }
//     else {
//       return 'Error: CreateRoom Failed.';
//     }
//   }

//   Future<String> JoinRoom(String room_key) async{
    
//     final msg = KeyRequest()
//       ..roomKey = room_key;
//     final joinReply = await stub.joinRoom(msg);
//     if(joinReply.status.status == 0) {
//       key = room_key;
//       id = joinReply.guestId;
//       return joinReply.roomName;
//     }
//     else {
//       return 'Error: JoinRoom Failed.';
//     }
//   }

//   void DeleteRoom() async{
//     final msg = KeyRequest()
//       ..roomKey = key;
//     final status = await stub.deleteRoom(msg);
//     if(status.status != 0) {
//       print('Error: DeleteRoom failed.');
//     }
//   }

//   void LeaveRoom() async {
//     final msg = LeaveRequest()
//       ..roomKey = key
//       ..id = id;
//     final status = await stub.leaveRoom(msg);
//     if(status.status != 0){
//       print('Error: LeaveRoom failed.');
//     }
//   }

//   void AddService(String service_name) async{
//     final service = ServiceMsg()
//       ..name = service_name;
//     final msg = ServiceRequest()
//       ..service = service
//       ..roomKey = key;
//     final reply = await stub.addService(msg);
//     if(reply.status != 0) {
//       print('Error: AddService Failed.');
//     }
//   }
  
//   Future<List<String>> GetServices() async{
//     final request = KeyRequest()
//       ..roomKey = key;
//     List<String> services;
//     try {
//       await for (var service in stub.getServices(request)) {
//         services.add(service.name);
//       }
//     }
//     catch (e) {
//       print('Error: $e');
//     }
//     return services;
//   }

//   Future<List<Song>> GetQueue() async {
//     final request = KeyRequest()
//       ..roomKey = key;
//     List<Song> queue;
//     try {
//       await for (var song in stub.getQueue(request)) {
//         services.Service serviceObj = services.Service.fromString(song.service);
//         Song songObj = new Song(song.songId, song.uri, song.name, song.artist, song.imageUri, song.duration, serviceObj);
//         queue.add(songObj);
//       }
//     }
//     catch (e) {
//       print('Error: $e');
//     }
//     return queue;
//   }

//   Future<void> AddSong(Song song) async{
//     final songObj = SongMsg()
//       ..songId = song.id
//       ..uri = song.uri
//       ..name = song.trackName
//       ..artist = song.artists
//       ..imageUri = song.imageUri
//       ..duration = song.duration
//       ..service = song.service.name;
    
//     final msg = SongRequest()
//       ..song = songObj
//       ..roomKey = key;
//     final reply  = await stub.addSong(msg);
//     if(reply.status != 0) {
//       print('Error: AddSong Failed.');
//     }
//   }

//   Future<void> DeleteSong(Song song) async{
//     final songObj = SongMsg()
//       ..songId = song.id
//       ..uri = song.uri
//       ..name = song.trackName
//       ..artist = song.artists
//       ..imageUri = song.imageUri
//       ..duration = song.duration
//       ..service = song.service.name;
    
//     final msg = SongRequest()
//       ..song = songObj
//       ..roomKey = key;
//     final reply = await stub.deleteSong(msg);
//     if(reply.status != 0) {
//       print('Error: DeleteSong Failed.');
//     }
//   }
// }

// grpcClient.Client getClient() => WebClient();
