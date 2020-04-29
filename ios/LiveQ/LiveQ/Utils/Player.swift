//
//  Player.swift
//  LiveQ
//
//  Created by Shaheer Mirza on 4/20/20.
//  Copyright © 2020 Shaheer Mirza. All rights reserved.
//

import Foundation
import Combine
import MediaPlayer

enum PlayerState {
    case Playing, Paused, Stopped
}

class Player: NSObject, ObservableObject, SPTAppRemotePlayerStateDelegate {
    
    static var instance: Player = Player()
    
    private override init() {}
    
    var currentSong: Song?
    var currentService: Service?
    @Published var searchService: Service?
    @Published var allowedServices = [Service]()
    @Published var connectedServices = [Service]()
    @Published var queue = [Song]()
    @Published var isHost: Bool = false
    var currentState: PlayerState = .Stopped
    
    let api = Api.instance
    
    func play(song: Song?) {
        if let song = song {
            print("playing")
            currentSong = song
            currentService = song.service
            
            var uri: String = song.uri
            if (currentService is SoundCloud) {
                print("soundcloud")
                uri = String(song.trackId)
            }
            
            currentService?.play(uri)
            currentState = .Playing
        }
    }
    
    @objc func next() {
        print("HERE")
        if !queue.isEmpty {
            if let nextSong = getNextSong() {
                if currentService != nil && (type(of: currentService) != type(of: nextSong.service)) {
                    print("new service. pausing")
                    pause()
                    currentService?.stop()
                }
                print("player playing")
                
                play(song: nextSong)
            }
        }
    }
    
    func getNextSong() -> Song? {
        if queue.count > 0 {
            let nextSong = queue[0]
            api.deleteSong(song: nextSong)
//            client.deleteSong(song: nextSong) // TODO
            return nextSong
        }
        
        return nil
    }
    
    func loadQueue() {
        api.getQueue() { songs in
            if songs != self.queue {
                DispatchQueue.main.async {
                    self.queue = songs
                }
            }
        }
    }
    
    func queueSong(_ song: Song) {
        api.addSong(song: song)
//        client.addSong(song: song) // TODO
    }
    
    
    func resume() {
        currentService?.resume()
        currentState = .Playing
    }
    
    func pause() {
        currentService?.pause()
        currentState = .Paused
    }
    
    func search(query: String, finished: @escaping (_ songs: [Song]) -> Void) {
        print("searching with \(searchService?.name)")
        searchService?.search(query: query, finished: finished)
        print("done")
    }
    
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        print("context: \(playerState.contextURI)")
        print("state: \(playerState.isPaused)")
        if playerState.isPaused && playerState.playbackPosition == 0 && currentSong?.uri == playerState.track.uri {
            print("PLAYING NEXT CALLBACK")
            next()
        }
//        print("spotify state changed bb")
//        print(playerState.track.name)
    }
    
    func setAllowedServices(services: [Service]) {
        self.allowedServices = services
    }
}
