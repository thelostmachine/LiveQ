//
//  RoomView.swift
//  LiveQ
//
//  Created by Shaheer Mirza on 3/21/20.
//  Copyright © 2020 Shaheer Mirza. All rights reserved.
//

import SwiftUI
import MediaPlayer

struct RoomView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
//    @ObservedObject var queue = QueueViewModel()
//    @Published var songs: [Song] = [Song]()
    @ObservedObject var player: Player = Player.instance
    
    @State private var authorized = false
    
//    let player: Player = Player()
    
//    private var appRemote: SPTAppRemote? {
//        get {
//            return (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.appRemote
//        }
//    }
//
//    private var playerState: SPTAppRemotePlayerState {
//        get {
//            return (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)!.playerState
//        }
//    }
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "Georgia", size: 20)!]
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(self.player.queue) { song in
                        SongRow(song: song)
                    }
                }
                
                HStack {
                    Button("Play") {
                        print("play")
                        if self.player.currentState == .Stopped {
                            self.player.next()
//                            self.player.play(song: self.getNextSong())
                        } else {
                            self.player.resume()
                        }
//                        self.appRemote?.playerAPI?.resume(nil)
                    }
                    Button("Pause") {
                        print("pause")
                        self.player.pause()
//                        self.appRemote?.playerAPI?.pause(nil)
                    }
                    Button("Next") {
                        print("next")
//                        self.nextManual(song: self.getNextSong())
//                        self.player.play(song: self.getNextSong())
                        self.player.next()
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
                HStack {
                    NavigationLink(destination: ServicesView()) {
                        Text("Connect")
                    }
                    Spacer(minLength: 30)
                    NavigationLink(destination: SearchView()) {
                        Image(systemName: "magnifyingglass")
                    }
//                        Text("Search")}
                }
                
                    
//                    Button("Search") {
//                        NavigationLink(destination: SearchView()) {
//                            print("search")
//                        }
//                        self.viewRouter.currentPage = .Search
                )
            .resignKeyboardOnDragGesture()
        }
//        .onReceive(queue.didChange) { songs in
//            self.songs = songs
//        }
        .onAppear {
//            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.playerStateDelegate = self
            print("howdy")
            if !self.authorized {
//                spotifyManager.authorize()
                self.authorized = true
            }
            
            DispatchQueue.global(qos: .background).async {
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                    self.player.loadQueue()
                }
                RunLoop.current.run()
            }
            
            do {
                try AVAudioSession.sharedInstance()
                                      .setCategory(AVAudioSession.Category.playback)
                print("AVAudioSession Category Playback OK")
                do {
                    try AVAudioSession.sharedInstance().setActive(true)
                    print("AVAudioSession is Active")
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
            let commandCenter = MPRemoteCommandCenter.shared()
            commandCenter.nextTrackCommand.isEnabled = true
            commandCenter.nextTrackCommand.addTarget(handler: {_ in
                self.player.next()
                return .success
            })
            
            commandCenter.playCommand.isEnabled = true
            commandCenter.playCommand.addTarget(handler: { _ in
                self.player.resume()
                return .success
            })
            
            commandCenter.pauseCommand.isEnabled = true
            commandCenter.pauseCommand.addTarget(handler: { _ in
                self.player.pause()
                return .success
            })
            
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
    
//    func next(state: SPTAppRemotePlayerState) {
//        print("DELEGATION")
//        print(queue.songs.count)
//        if queue.songs.count > 0 {
//            print(state.isPaused)
//            print(state.playbackPosition)
//            if state.isPaused && state.playbackPosition == 0 {
//                let song = queue.songs.remove(at: 0)
//                appRemote?.playerAPI?.play(song.uri, callback: nil)
//            }
//        }
//    }
    
//    func nextManual(song: Song?) {
//        guard let song = song else { return }
//
//        appRemote?.playerAPI?.play(song.uri, callback: nil)
//    }
    
//    func getNextSong() -> Song? {
//        if queue.songs.count > 0 {
//            let nextSong = queue.songs[0]
//            client.deleteSong(song: nextSong)
//            return nextSong
//        }
//
//        return nil
//    }
}

struct RoomView_Previews: PreviewProvider {
    static var previews: some View {
        RoomView().environmentObject(ViewRouter())
    }
}
