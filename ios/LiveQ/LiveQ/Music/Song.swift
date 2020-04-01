//
//  Song.swift
//  LiveQ
//
//  Created by Shaheer Mirza on 3/21/20.
//  Copyright © 2020 Shaheer Mirza. All rights reserved.
//

import Foundation

struct Song: Identifiable {
    
    var id: String
    var uri: String
    
    var service: Service
    
    var name: String
    var artist: String
    
    init(id: String, uri: String, _ name: String, _ artist: String, _ service: Service) {
        self.id = id
        self.uri = uri
        self.name = name
        self.artist = artist
        self.service = service
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
