//
//  Song.swift
//  LiveQ
//
//  Created by Shaheer Mirza on 3/21/20.
//  Copyright © 2020 Shaheer Mirza. All rights reserved.
//

import Foundation

struct Song: Identifiable, Equatable {
//    var ID = UUID()
    var id: String
    var uri: String
    
    var service: Service
    
    var name: String
    var artists: [Artist]
    
    var imageUri: String
    var duration: Int
    
    init(id: String, uri: String, _ name: String, _ artists: [Artist], imageUri: String = "", duration: Int = 0, _ service: Service) {
        self.id = id
        self.uri = uri
        self.name = name
        self.artists = artists
        self.imageUri = imageUri
        self.duration = duration
        self.service = service
    }
    
    init(song: Song) {
        self.id = song.id
        self.uri = song.uri
        self.name = song.name
        self.artists = song.artists
        self.imageUri = song.imageUri
        self.duration = song.duration
        self.service = song.service
    }
    
    static func getArtistString(song: Song) -> String {
        return song.artists.map { $0.name }.joined(separator: ", ")
    }
    
    func getDurationString() -> String {
        func twoDigits(_ n: Int) -> String {
            if (n >= 10) {
                return "\(n)"
            }
            return "0\(n)"
        }
        
        let (m, s) = secondsToMinutesSeconds()
        return "\(m):\(twoDigits(s))"
    }
    
    func secondsToMinutesSeconds() -> (Int, Int) {
        return ((duration % 3600) / 60, (duration % 3600) % 60)
    }
    
    public var description: String {
        return """
        id: \(id)
        uri: \(uri)
        name: \(name)
        artists: \(artists[0].name)
        imageUri: \(imageUri)
        duration: \(duration)
        service: \(service.name)
        """
    }
    
    static func == (lhs: Song, rhs: Song) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.uri == rhs.uri &&
            lhs.name == rhs.name &&
            lhs.imageUri == rhs.imageUri &&
            lhs.duration == rhs.duration &&
            lhs.service.name == rhs.service.name
        
    }
}

//func getId(_ name: String, _ artist: String, _ service: Service) -> Int {
//    for (index, song) in songs.enumerated() {
//        if song.name == name && song.artist == artist && song.service == service {
//            return index
//        }
//    }
//
//    return 0
//}
