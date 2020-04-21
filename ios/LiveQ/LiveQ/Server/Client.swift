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
    let port = 9090
    let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
    let options = CallOptions(timeout: .seconds(rounding: 30))
    
    var stub: Liveq_LiveQClient!
    var channel: ClientConnection!
    var key: String!
    

    public override init() {
        super.init()
        
        channel = ClientConnection.insecure(group: group).connect(host: host, port: port)
        stub = Liveq_LiveQClient(channel: channel as! GRPCChannel, defaultCallOptions: options)
    }
    
    func createRoom(name: String) -> String {
        let room = Liveq_CreateRequest.with {
            $0.roomName = name
        }
        
        let reply = stub.createRoom(room)
        
        do {
            let response = try reply.response.wait()
            print("SUCCESS \(response.roomKey)")
            key = response.roomKey
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
            let response = try reply.response.wait()
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
            let response = try reply.response.wait()
        } catch {
            print("failed to delete song \(song.name): \(error)")
        }
    }
    
    func getQueue() -> [Song] {
        var queue = [Song]()
        let request = Liveq_KeyRequest.with {
            $0.roomKey = self.key
        }
        
        let reply = stub.getQueue(request) { song in
//            print("received \(song.name)")
            let qSong: Song = Song(id: song.songID, uri: song.uri, song.name, [Artist.init(name: song.artist)], imageUri: song.imageUri, duration: Int(song.duration), fromString(song.service))
//                                   Service.fromString(song.service.name))
                //Service.init(rawValue: song.service)!)
            queue.append(qSong)
        }
        
        do {
            let status = try! reply.status.recover { _ in .processingError }.wait()
        } catch {
            print("failed to get queue")
        }
        
        return queue
    }
}
