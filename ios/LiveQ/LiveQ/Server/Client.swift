//
//  Client.swift
//  LiveQ
//
//  Created by Shaheer Mirza on 4/13/20.
//  Copyright © 2020 Shaheer Mirza. All rights reserved.
//

import Foundation

import SwiftProtobuf
import GRPC
import NIO
//import SwiftGRPC

class Client: NSObject {
//    var stub: Liveq_LiveQService?
    
    let host = "34.71.85.54"
    let port = 80
    let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
    let options = CallOptions(timeout: .seconds(rounding: 30))
    
    var stub: Liveq_LiveQClient!
    var channel: ClientConnection!
    var key: String!
    var id: String!
    

    public override init() {
        super.init()
        
        channel = ClientConnection.insecure(group: group).connect(host: host, port: port)
        stub = Liveq_LiveQClient(channel: channel!, defaultCallOptions: options)
    }
    
    func createRoom(name: String) -> String {
        let room = Liveq_CreateRequest.with {
            $0.roomName = name
        }
        
        let reply = stub.createRoom(room)
        
        do {
            let response = try reply.response.wait()
            print("SUCCESS \(response.roomKey)")
            
            self.key = response.roomKey
            self.id = response.hostID
            
            return response.roomKey
        } catch {
            print("FAILURE \(error)")
        }
        
        return ""
    }
    
    func joinRoom(key: String) -> String {
        let msg = Liveq_KeyRequest.with {
            $0.roomKey = key
        }
        let reply = stub.joinRoom(msg)
        
        do {
            let response = try reply.response.wait()
            self.key = key
            self.id = response.guestID
            
            return response.roomName
        } catch {
            print("JOIN FAILURE")
        }
        
        return ""
    }
    
    func addSong(song: Song) {
        let songMsg = Liveq_SongMsg.with {
            $0.songID = String(song.id)
            $0.uri = song.uri
            $0.name = song.name
            $0.artist = song.artists[0].name
            $0.imageUri = song.imageUri
            $0.duration = Int32(song.duration)
            $0.service = song.service.name
        }
        
        let addReq = Liveq_SongRequest.with {
            $0.song = songMsg
            $0.roomKey = self.key
        }
        
        let reply = stub.addSong(addReq)
        
        do {
            let _ = try reply.response.wait()
        } catch {
            print("failed to add song \(song.name)")
        }
    }
    
    func deleteSong(song: Song) {
        let songMsg = Liveq_SongMsg.with {
            $0.songID = String(song.id)
            $0.uri = song.uri
            $0.name = song.name
            $0.artist = song.artists[0].name
            $0.imageUri = song.imageUri
            $0.duration = Int32(song.duration)
            $0.service = song.service.name
        }
        
        let delReq = Liveq_SongRequest.with {
            $0.song = songMsg
            $0.roomKey = self.key
        }
        
        let reply = stub.deleteSong(delReq)
        
        do {
            _ = try reply.response.wait()
        } catch {
            print("failed to delete song \(song.name): \(error)")
        }
    }
    
//    func getQueue() -> [Song] {
//        var queue = [Song]()
//        let request = Liveq_KeyRequest.with {
//            $0.roomKey = self.key
//        }
//        
//        let reply = stub.getQueue(request) { song in
////            print("received \(song.name)")
//            let qSong: Song = Song(
//                id: song.songID,
//                uri: song.uri,
//                name: song.name,
//                artists: [Artist.init(name: song.artist)],
//                imageUri: song.imageUri,
//                duration: Int(song.duration),
//                service: fromString(song.service))
////                                   Service.fromString(song.service.name))
//                //Service.init(rawValue: song.service)!)
//            queue.append(qSong)
//        }
//        
//        do {
//            _ = try reply.status.recover { _ in .processingError }.wait()
//        } catch {
//            print("failed to get queue")
//        }
//        
//        return queue
//    }
    
    func addService(_ service: Service) {
        let serviceMsg = Liveq_ServiceMsg.with {
            $0.name = service.name
        }
        let msg = Liveq_ServiceRequest.with {
            $0.service = serviceMsg
            $0.roomKey = self.key
        }
        
        let reply = stub.addService(msg)
        
        do {
            let _ = try reply.response.wait()
            print("added \(service.name)")
        } catch {
            print("failed to add service \(service.name): \(error)")
        }
    }
    
    func getServices() -> [Service] {
        var services = [Service]()
        let request = Liveq_KeyRequest.with {
            $0.roomKey = self.key
        }
        
        let reply = stub.getServices(request) { service in
            services.append(fromString(service.name))
            print("found \(service.name)")
        }
        
        do {
            let _ = try reply.status.recover { _ in .processingError }.wait()
            print("done") //G9Fwf4qo
        } catch {
            print("Failed to get queue")
        }
        
        return services
    }
    
    func leaveRoom() {
        let msg = Liveq_LeaveRequest.with {
            $0.roomKey = self.key
            $0.id = self.id
        }
        let reply = stub.leaveRoom(msg)
        
        do {
            _ = try reply.response.wait()
        } catch {
            print("failed to leave room: \(error)")
        }
    }
    
    func deleteRoom() {
        let msg = Liveq_KeyRequest.with {
            $0.roomKey = self.key
        }
        let reply = stub.deleteRoom(msg)
        
        do {
            _ = try reply.response.wait()
        } catch {
            print("failed to delete room: \(error)")
        }
    }
}
