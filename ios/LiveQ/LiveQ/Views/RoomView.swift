//
//  RoomView.swift
//  LiveQ
//
//  Created by Shaheer Mirza on 3/21/20.
//  Copyright © 2020 Shaheer Mirza. All rights reserved.
//

import SwiftUI
import MediaPlayer

struct RoomView: View, PlayerStateDelegate {
    
    @EnvironmentObject var viewRouter: ViewRouter
    @ObservedObject var queue = QueueViewModel()
//    @Published var songs: [Song] = [Song]()
    
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
                        self.nextManual(song: self.getNextSong())
//                        self.appRemote?.playerAPI?.play(self.queue.songs(at: 0).uri, callback: nil)
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
//        .onReceive(queue.didChange) { songs in
//            self.songs = songs
//        }
        .onAppear {
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.playerStateDelegate = self
            print("howdy")
            if !self.authorized {
//                spotifyManager.authorize()
                self.authorized = true
            }
            
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                self.queue.setQueue()
            }
            
//            let urlstring = "https://api.soundcloud.com/tracks/568524525"
//            let urlstring = "https://cf-hls-media.sndcdn.com/media/1117203/1276863/Y9iSpv51sEqp.128.mp3"
//            let url = URL(string: urlstring)
//            self.downloadFile(url: url!)
            
        }
    }
    
//    func downloadFile(url: URL) {
//        var downloadTask: URLSessionDownloadTask
//        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { (URL, response, error) in
//            self.play(url: url)
//        })
//
//        downloadTask.resume()
//    }
//
//    func play(url: URL) {
//        print("playing \(url)")
//
//        do {
//            let player = try AVAudioPlayer(contentsOf: url)
//            player.prepareToPlay()
//            player.volume = 1.0
//            player.play()
//        } catch let error as NSError {
//            //self.player = nil
//            print(error.localizedDescription)
//        } catch {
//            print("AVAudioPlayer init failed")
//        }
//
//    }
    
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
    
    func nextManual(song: Song?) {
        guard let song = song else { return }
        
        appRemote?.playerAPI?.play(song.uri, callback: nil)
    }
    
    func getNextSong() -> Song? {
        if queue.songs.count > 0 {
            let nextSong = queue.songs[0]
            client.deleteSong(song: nextSong)
            return nextSong
        }
        
        return nil
    }
}

struct RoomView_Previews: PreviewProvider {
    static var previews: some View {
        RoomView().environmentObject(ViewRouter())
    }
}
