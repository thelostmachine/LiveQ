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
    @State private var showingAlert = false
    @State private var exiting = false
    
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
                
                if self.viewRouter.isHost {
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
                
            }
            .navigationBarTitle("\(self.viewRouter.roomName)")
            .navigationBarItems(
                leading:
                    Button(action: {
                        self.exiting = true
                    }) {
                        Text("Exit")
                    }
                    .alert(isPresented: $exiting) {
                        Alert(title: Text("Are you sure?"), message: Text(self.viewRouter.isHost ? "The room will be deleted if you leave" : "Do you want to exit"), primaryButton: .default(Text("No")), secondaryButton: .default(Text("Yes"), action: {
                            client.leaveRoom()
                            if self.viewRouter.isHost {
                                client.deleteRoom()
                            }
                            
                            self.viewRouter.roomName = ""
                            self.viewRouter.roomID = ""
                            self.viewRouter.currentPage = .Home
                        }))
                    },
//                    Button("Exit") {
//                        self.viewRouter.currentPage = .Home
//                    },
                trailing:
                HStack {
                    if self.viewRouter.isHost {
                        NavigationLink(destination: ServicesView()) {
                            Text("Connect")
                        }
                        Spacer(minLength: 30)
                    }
                    NavigationLink(destination: SearchView()) {
                        Image(systemName: "magnifyingglass")
                    }
                    
                    Spacer(minLength: 30)
                    
                    Button(action: {
                        self.showingAlert = true
                    }) {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Room Code"), message: Text(self.viewRouter.roomID), primaryButton: .default(Text("Copy"), action: {
                            UIPasteboard.general.string = self.viewRouter.roomID
                        }), secondaryButton: .default(Text("OK")))
                    }
                }
            )
            .resignKeyboardOnDragGesture()
        }
        .foregroundColor(Color(hex: 0xffed6c6c))
        .onAppear {
//            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.playerStateDelegate = self
            print("howdy")
            if !self.authorized {
//                spotifyManager.authorize()
                self.authorized = true
            }
            
            if !self.viewRouter.isHost {
                self.player.allowedServices = client.getServices()
                self.player.isHost = false
                print("got services")
            } else {
                self.player.allowedServices = self.player.connectedServices
                self.player.isHost = true
                print("set services")
            }
            
            for service in self.player.allowedServices {
                print("\(service.name)")
                service.connect()
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
}

struct RoomView_Previews: PreviewProvider {
    static var previews: some View {
        RoomView().environmentObject(ViewRouter())
    }
}
