//
//  SearchView.swift
//  LiveQ
//
//  Created by Shaheer Mirza on 3/23/20.
//  Copyright © 2020 Shaheer Mirza. All rights reserved.
//

import SwiftUI
//import Spartan

struct SearchView: View {
    
    @Environment(\.presentationMode) private var presentation
    @EnvironmentObject var viewRouter: ViewRouter
//    @ObservedObject var queue: QueueViewModel
    
//    @State private var searchText = "21 freestyle GXXD"
    @State private var searchText = "I still love you feels mix"
    @State private var showCancelButton: Bool = false
    @State var tracks: [Song] = []
    @State var searching: Bool = false
//    @State var searchService: Service = SoundCloud()
//    let service = SoundCloud.instance
    @ObservedObject var player: Player = Player.instance
//    @State private var tracks: [SpotifyTrack] = []
    
    var body: some View {
//        NavigationView {
        LoadingView(isShowing: $searching) {
            VStack {
                // Search View
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        
                        TextField("Search for Songs", text: self.$searchText, onEditingChanged: { _ in
                            self.showCancelButton = true
                        }, onCommit: {
                            print("onCommit")
                            
                            guard self.player.searchService != nil else { return }
                            
                            self.searching = true
                            self.player.search(query: self.searchText) { songs in
                                print("setting \(songs.count) tracks")
                                for song in self.tracks {
                                    print(song)
                                }
                                DispatchQueue.main.async {
                                    self.tracks = songs
                                }
    //                            self.tracks = songs
                                self.searching = false
                                print("after")
                                for song in self.tracks {
                                    print(song)
                                }
                            }
                        }).foregroundColor(.primary)
                        
                        Button(action: {
                            self.searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill").opacity(self.searchText == "" ? 0 : 1)
                        }
                    }
                    .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                    .foregroundColor(.secondary)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10.0)
                    
                    Image(uiImage: Spotify.instance.image)
                        .resizable()
                        .frame(width: 30, height: 30)
                        .saturation(self.player.searchService is Spotify ? 1 : 0)
                        .onTapGesture {
                            self.player.searchService = Spotify.instance
                        }
                    
                    Image(uiImage: SoundCloud.instance.image)
                        .resizable()
                        .frame(width: 30, height: 30)
                        .saturation(self.player.searchService is SoundCloud ? 1 : 0)
                        .onTapGesture {
                            self.player.searchService = SoundCloud.instance
                        }
                    
                    if self.showCancelButton {
                        Button("Cancel") {
                            UIApplication.shared.endEditing(true)
                            self.searchText = ""
                            self.showCancelButton = false
                        }
                        .foregroundColor(Color(.systemBlue))
                    }
                }
                .padding(.horizontal)
                .navigationBarHidden(self.showCancelButton)
                
                List(self.tracks) { song in
                    Button(action: {
                        self.player.queueSong(song)
//                        self.queue.objectWillChange.send()
//                        self.queue.queue(song)
                        print(song.id)
                        print(song.uri)
                        self.presentation.wrappedValue.dismiss()
                    }) {
                        SongRow(song: song)
                    }
                }
                .navigationBarTitle(Text("Search"))
                .resignKeyboardOnDragGesture()
            }
        }
    }
//    }
    
//    func search(query: String) {
//        var search = "https://api.spotify.com/v1/search/?type=track&market=US&q="
//        search += formatQuery(query: query)
//
//        var request: URLRequest = URLRequest(url: URL(string: search)!)
//        request.httpMethod = "GET"
//        request.setValue("Bearer \(authorizationToken!)", forHTTPHeaderField: "Authorization")
//
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if let error = error {
//                print("Error while searching: \(error)")
//                return
//            }
//
//            let parsedResult = try? JSONDecoder().decode(SearchResult.self, from: data!)
//            if let results = parsedResult {
//                self.tracks = results.getSongs()
//            }
//        }
//        task.resume()
//
//    }
}
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView().environmentObject(ViewRouter())
    }
}
