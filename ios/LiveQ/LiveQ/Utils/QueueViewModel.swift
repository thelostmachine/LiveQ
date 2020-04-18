//
//  QueueViewModel.swift
//  LiveQ
//
//  Created by Shaheer Mirza on 3/23/20.
//  Copyright © 2020 Shaheer Mirza. All rights reserved.
//

import Combine
import Foundation

class QueueViewModel: ObservableObject {
    var didChange = PassthroughSubject<[Song], Never>()
    @Published var songs = [Song]() {
        didSet {
            didChange.send(songs)
        }
    }
    
//    @Published var songs: [Song] = []
//    @Published var playerState: SPTAppRemotePlayerState?
//    
//    func setPlayerState(_ state: SPTAppRemotePlayerState) {
//        self.playerState = state
//    }
    
    func queue(_ song: Song) {
        client.addSong(song: song)
//        songs.append(song)
    }
    
    func setQueue() {
        self.songs = client.getQueue()
//        print("returning \(song.count) from model")
//        print(self.songs.count)
    }
}
