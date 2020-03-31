//
//  QueueViewModel.swift
//  LiveQ
//
//  Created by Shaheer Mirza on 3/23/20.
//  Copyright © 2020 Shaheer Mirza. All rights reserved.
//

import Foundation

class QueueViewModel: ObservableObject {
    
    @Published var songs: [Song] = []
//    @Published var playerState: SPTAppRemotePlayerState?
//    
//    func setPlayerState(_ state: SPTAppRemotePlayerState) {
//        self.playerState = state
//    }
    
    func queue(_ song: Song) {
        songs.append(song)
    }
}
