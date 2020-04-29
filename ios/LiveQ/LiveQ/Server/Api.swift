//
//  Api.swift
//  LiveQ
//
//  Created by Shaheer Mirza on 4/28/20.
//  Copyright © 2020 Shaheer Mirza. All rights reserved.
//

import Foundation
import SwiftyJSON

enum Endpoint: String {
    case guests = "guests/"
    case rooms = "rooms/"
    case songs = "songs/"
    case services = "services/"
}

class Api {
    
    static let instance: Api = Api()
    
    private init() {}
    
    let baseUri = "https://api.shaheermirza.dev/";
    
    var roomKey: String!
    var roomName: String!
    
    var viewRouter: ViewRouter!
    
    func createRoom(roomName: String, _ onError: @escaping (Bool) -> Void) {
        postRequest(endpoint: .rooms, json: JSON(["room_name" : roomName])) { json in
            if let roomKey = json["room_key"].string {
                self.viewRouter.roomName = roomName
                self.viewRouter.roomKey = roomKey
                self.viewRouter.isHost = true
                self.viewRouter.currentPage = .Room
            } else {
                DispatchQueue.main.async {
                    onError(true)
                }
            }
        }
    }
    
    func joinRoom(roomKey: String, _ onError: @escaping (Bool) -> Void) {
        getRequest(endpoint: .rooms, query: roomKey) { json in
            if let roomName = json[0]["room_name"].string {
                self.viewRouter.roomName = roomName
                self.viewRouter.roomKey = roomKey
                self.viewRouter.isHost = false
                self.viewRouter.currentPage = .Room
            } else {
                DispatchQueue.main.async {
                    onError(false)
                }
            }
        }
    }
    
    func leaveRoom() {
        self.viewRouter.roomName = ""
        self.viewRouter.roomKey = ""
        self.viewRouter.currentPage = .Home
        self.viewRouter.isHost = false
    }
    
    func deleteRoom() {
        deleteRequest(endpoint: .rooms, pk: self.viewRouter.roomKey)
        self.viewRouter.roomName = ""
        self.viewRouter.roomKey = ""
        self.viewRouter.currentPage = .Home
        self.viewRouter.isHost = false
    }
    
    func addSong(song: Song) {
        let json = JSON([
            "room" : self.viewRouter.roomKey,
            "track_id" : song.trackId,
            "uri" : song.uri,
            "track_name" : song.name,
            "artists" : song.getArtistString(),
            "duration" : song.duration,
            "image_uri" : song.imageUri,
            "service" : song.service.name
        ])
        postRequest(endpoint: .songs, json: json)
    }
    
    func deleteSong(song: Song) {
        deleteRequest(endpoint: .songs, pk: String(song.id))
    }
    
    func getQueue(_ handler: @escaping (_ songs: [Song]) -> Void) {
        getRequest(endpoint: .songs, query: self.viewRouter.roomKey) { json in
            var songs = [Song]()
            for (_, item):(String, JSON) in json {
                if let id = item["id"].int,
                    let trackId = item["track_id"].string,
                    let uri = item["uri"].string,
                    let name = item["track_name"].string,
                    let artists = item["artists"].string,
                    let imageUri = item["image_uri"].string,
                    let duration = item["duration"].int,
                    let service = item["service"].string {
                    
                    songs.append(Song(
                        id: id,
                        trackId: trackId,
                        uri: uri,
                        name: name,
                        artists: [Artist.init(name: artists)],
                        imageUri: imageUri,
                        duration: duration,
                        service: fromString(service))
                    )
                }
            }
            
            handler(songs)
        }
    }
    
    func addService(service: String) {
        postRequest(endpoint: .services, json: JSON([
            "room" : self.viewRouter.roomKey,
            "service_type" : service
        ]))
    }
    
    func getServices(_ handler: @escaping (_ services: [Service]) -> Void) {
        getRequest(endpoint: .services, query: self.viewRouter.roomKey, { json in
            var services = [Service]()
            for (_, item):(String, JSON) in json {
                if let serviceString = item["service_type"].string {
                    services.append(fromString(serviceString))
                }
            }
            
            handler(services)
        })
    }
    
    
    func getRequest(endpoint: Endpoint, query: String, _ finished: @escaping (_ json: JSON) -> Void) {
        let urlString = baseUri + endpoint.rawValue + "?search=\(query)"
        guard let url = URL(string: urlString) else { return }
//        print(urlString)
//        print(url)
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else { return }
//            print("GET RETURNED")
            do {
                let json = try JSON(data: data)
//                print(json)
                finished(json)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func postRequest(endpoint: Endpoint, json: JSON, _ finished: @escaping (_ json: JSON) -> Void = { _ in }) {
        
        let urlString = baseUri + endpoint.rawValue
        guard let url = URL(string: urlString) else { return }
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? json.rawData()
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else { return }
//            print("POST RETURNED")
            do {
                let json = try JSON(data: data)
//                print(json)
                finished(json)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func deleteRequest(endpoint: Endpoint, pk: String) {
        
        let urlString = baseUri + endpoint.rawValue + pk + "/"
        guard let url = URL(string: urlString) else { return }
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse, error == nil else { return }
            print("DELETED - \(httpResponse.statusCode)")
        }
        task.resume()
    }
}
