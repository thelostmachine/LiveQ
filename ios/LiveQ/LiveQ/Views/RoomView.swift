//
//  RoomView.swift
//  LiveQ
//
//  Created by Shaheer Mirza on 3/21/20.
//  Copyright © 2020 Shaheer Mirza. All rights reserved.
//

import SwiftUI
import SpotifyKit
import MediaPlayer

struct RoomView: View, PlayerStateDelegate {
    
    @EnvironmentObject var viewRouter: ViewRouter
    @ObservedObject var queue = QueueViewModel()
    
    @State private var authorized = false
    
    private var appRemote: SPTAppRemote? {
        get {
            return (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.appRemote
        }
    }
    
    private var playerState: SPTAppRemotePlayerState {
        get {
            return (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)!.playerState
        }
    }
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "Georgia", size: 20)!]
    }
    
    var body: some View {
        NavigationView {
            VStack {
//                List(songs) { song in
//                    SongRow(song: song)
//                }
                List {
                    ForEach(self.queue.songs) { song in
                        SongRow(song: song)
                    }
                }
                
                HStack {
                    Button("Play") {
                        print("play")
                        for song in self.queue.songs {
                            print(song.name)
                        }
                        self.appRemote?.playerAPI?.resume(nil)
                    }
                    Button("Pause") {
                        print("pause")
                        self.appRemote?.playerAPI?.pause(nil)
                    }
                    Button("Next") {
                        print("next")
                        self.appRemote?.playerAPI?.play(self.queue.songs.remove(at: 0).uri, callback: nil)
                    }
                }
            }
            .navigationBarTitle("\(self.viewRouter.roomName) - Room ID: \(self.viewRouter.roomID)")
            .navigationBarItems(
                leading:
                    Button("Exit") {
                        self.viewRouter.currentPage = .Home
                },
                trailing:
                NavigationLink(destination: SearchView(queue: self.queue)) {
                        Text("Search")
                    
//                    Button("Search") {
//                        NavigationLink(destination: SearchView()) {
//                            print("search")
//                        }
//                        self.viewRouter.currentPage = .Search
                })
            .resignKeyboardOnDragGesture()
        }
        .onAppear {
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.playerStateDelegate = self
            print("howdy")
            if !self.authorized {
                spotifyManager.authorize()
                self.authorized = true
            }
            
            
            
//            DispatchQueue.global(qos: .utility).async {
//                while true {
//                    if self.queue.songs.count > 0 {
//                        var songsCopy = self.queue.songs
////                        print("check")
//                        if self.playerState.isPaused && self.playerState.playbackPosition == 0 {
//                            let song = songsCopy.remove(at: 0)
//                            self.appRemote?.playerAPI?.play(song.uri, callback: nil)
//                        }
//                    }
//                }
//            }
        }
    }
    
    func next(state: SPTAppRemotePlayerState) {
        print("DELEGATION")
        print(queue.songs.count)
        if queue.songs.count > 0 {
            print(state.isPaused)
            print(state.playbackPosition)
            if state.isPaused && state.playbackPosition == 0 {
                let song = queue.songs.remove(at: 0)
                appRemote?.playerAPI?.play(song.uri, callback: nil)
            }
        }
    }
}

struct RoomView_Previews: PreviewProvider {
    static var previews: some View {
        RoomView().environmentObject(ViewRouter())
    }
}
