//
//  Song.swift
//  LiveQ
//
//  Created by Shaheer Mirza on 3/21/20.
//  Copyright © 2020 Shaheer Mirza. All rights reserved.
//

import Foundation

struct Song: Identifiable, Equatable {
    var id: Int
    var trackId: String
    var uri: String
    
    var service: Service
    
    var name: String
    var artists: [Artist]
    
    var imageUri: String
    var duration: Int
    
    init(id: Int, trackId: String, uri: String, name: String, artists: [Artist], imageUri: String = "", duration: Int = 0, service: Service) {
        self.id = id
        self.trackId = trackId
        self.uri = uri
        self.name = name
        self.artists = artists
        self.imageUri = imageUri
        self.duration = duration
        self.service = service
    }
    
    init(song: Song) {
        self.id = song.id
        self.trackId = song.trackId
        self.uri = song.uri
        self.name = song.name
        self.artists = song.artists
        self.imageUri = song.imageUri
        self.duration = song.duration
        self.service = song.service
    }
    
    func getArtistString() -> String {
        return self.artists.map { $0.name }.joined(separator: ", ")
    }
    
    func getDurationString() -> String {
        func twoDigits(_ n: Int) -> String {
            if (n >= 10) {
                return "\(n)"
            }
            return "0\(n)"
        }
        
        let date = Date(timeIntervalSince1970: Double(duration) / 1000)
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        
        var format = ""
        if duration >= (3600000 * 10) {
            format = "HH:mm:ss"
        }
        else if duration > 3600000 {
            format = "H:mm:ss"
        }
        else if duration >= 600000 {
            format = "mm:ss"
        }
        else {
            format = "m:ss"
        }
        
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    public var description: String {
        return """
        id: \(trackId)
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
