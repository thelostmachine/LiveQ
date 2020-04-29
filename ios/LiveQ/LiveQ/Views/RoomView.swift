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
    @State var playerPaused = true
    
    let api = Api.instance
    
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
                        Button(action: {
                            print("play")
                            if self.playerPaused {
                                if self.player.currentState == .Stopped {
                                    self.player.next()
                                } else {
                                    self.player.resume()
                                }
                            } else {
                                self.player.pause()
                            }
                            self.playerPaused.toggle()
                        }) {
                            Image(systemName: self.playerPaused ? "play.circle" : "pause.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                        }
                        
                        
                        if self.player.currentSong != nil{
                            Spacer()
                            
//                            ImageView(withURL: self.player.currentSong!.imageUri)
//                            Spacer()
//                                .frame(width: 10)
                            VStack {
                                Text(self.player.currentSong!.name)
                                Text(self.player.currentSong!.getArtistString())
                            }
                            Spacer()
                        } else {
                            Spacer()
                        }
                        
                        
                        Button(action: {
                            print("next")
                            self.player.next()
                        }) {
                            Image(systemName: "forward.end")
                            .resizable()
                            .frame(width: 40, height: 40)
                        }
                    }
                    .padding()
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
                            
                            if self.viewRouter.isHost {
                                self.api.deleteRoom()
                            } else {
                                self.api.leaveRoom()
                            }
                        }))
                    },
                trailing:
                HStack {
                    
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
                        Alert(title: Text("Room Code"), message: Text(self.viewRouter.roomKey), primaryButton: .default(Text("Copy"), action: {
                            UIPasteboard.general.string = self.viewRouter.roomKey
                        }), secondaryButton: .default(Text("OK")))
                    }
                }
            )
            .resignKeyboardOnDragGesture()
        }
        .foregroundColor(Color(hex: 0xffed6c6c))
        .onAppear {
            print("howdy")
            if !self.authorized {
//                spotifyManager.authorize()
                self.authorized = true
            }
            
            if !self.viewRouter.isHost {
//                self.player.allowedServices = client.getServices() // TODO
                self.api.getServices() { services in
                    self.player.allowedServices = services
                }
                self.player.isHost = false
                print("got services")
            } else {
                self.player.allowedServices = self.player.allowedServices
                self.player.isHost = true
                print("set services")
            }
            
            for service in self.player.allowedServices {
                print("\(service.name)")
                service.connect()
                self.api.addService(service: service.name)
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
