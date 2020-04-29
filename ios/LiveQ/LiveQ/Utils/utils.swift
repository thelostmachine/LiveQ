//
//  utils.swift
//  LiveQ
//
//  Created by Shaheer Mirza on 3/21/20.
//  Copyright © 2020 Shaheer Mirza. All rights reserved.
//

import Foundation
import SwiftUI

//let songs: [Song] = [
//    Song(id: 0, "Divinity", "Porter Robinson", .Spotify),
//    Song(id: 1, "Sound of Walking Away", "Illenium", .Spotify),
//    Song(id: 2, "44 Bars", "Logic", .SoundCloud),
//    Song(id: 3, "FEFE", "6ix9ine", .SoundCloud),
//]

//let client = Client()

//var authorizationToken: String?

struct SCSearch: Decodable {
    let tracks: SCTrack
}

struct SCTrack: Decodable {
    let collection: [String]
}

//struct SCItems: Decodable {
//    let title: String
//}

struct SearchResult: Decodable {
    let tracks: Track
    
    func getSongs() -> [Song] {
        var songs = [Song]()
        
        for item in tracks.items {
            let song = Song(
                id: Int.random(in: 1..<1500),
                trackId: item.id,
                uri: item.uri,
                name: item.name,
                artists: item.artists,
                imageUri: item.album.images[1].url,
                duration: item.duration,
                service: Spotify.instance)
            songs.append(song)
        }
        
        return songs
    }
}

struct Track: Decodable {
    let items: [Items]
}

struct Items: Decodable {
    let album: Album
    let artists: [Artist]
    let duration: Int
    let uri: String
    let name: String
    let id: String
    
    private enum CodingKeys: String, CodingKey {
        case album = "album"
        case artists = "artists"
        case duration = "duration_ms"
        case uri = "uri"
        case name = "name"
        case id = "id"
    }
}

struct Album: Decodable {
    let images: [ImageJSON]
}

struct ImageJSON: Decodable {
    let url: String
    let height: Int
    let width: Int
}

struct Artist: Decodable {
    let name: String
}


extension Color {
    init(hex: Int, alpha: Double = 1) {
        let components = (
            R: Double((hex >> 16) & 0xff) / 255,
            G: Double((hex >> 08) & 0xff) / 255,
            B: Double((hex >> 00) & 0xff) / 255
        )
        
        self.init(
            .sRGB,
            red: components.R,
            green: components.G,
            blue: components.B,
            opacity: alpha)
    }
}

enum Page {
    case Home, Room, Service, Search
}

//enum Service: String {
//    case Spotify, SoundCloud
//}

func fromString(_ service: String) -> Service {
    switch service {
    case "SoundCloud":
        return SoundCloud.instance
    case "Spotify":
        return Spotify.instance
    default:
        return SoundCloud.instance
    }
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{ $0.isKeyWindow }
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{ _ in
        UIApplication.shared.endEditing(true)
    }
    
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}

protocol PlayerStateDelegate {
    func next(state: SPTAppRemotePlayerState)
}
