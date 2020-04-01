//
//  SearchView.swift
//  LiveQ
//
//  Created by Shaheer Mirza on 3/23/20.
//  Copyright © 2020 Shaheer Mirza. All rights reserved.
//

import SwiftUI
import SpotifyKit

struct SearchView: View {
    
    @Environment(\.presentationMode) private var presentation
    @EnvironmentObject var viewRouter: ViewRouter
    @ObservedObject var queue: QueueViewModel
    
    @State private var searchText = ""
    @State private var showCancelButton: Bool = false
    @State private var tracks: [SpotifyTrack] = []
    
    var body: some View {
        VStack {
            // Search View
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    
                    TextField("Search for Songs", text: $searchText, onEditingChanged: { _ in
                        self.showCancelButton = true
                        
                    }, onCommit: {
                        print("onCommit")
                        
                        spotifyManager.find(SpotifyTrack.self, self.searchText) { tracks in
                            self.tracks = tracks
                            
//                            for track in tracks {
//                                print("URI:    \(track.uri), " +
//                                    "Name:   \(track.name), " +
//                                    "Artist: \(track.artist.name), " +
//                                    "Album:  \(track.album?.name ?? "none")")
//                            }
                        }
                    }).foregroundColor(.primary)
                    
                    Button(action: {
                        self.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                    }
                }
                .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                .foregroundColor(.secondary)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10.0)
                
                if showCancelButton {
                    Button("Cancel") {
                        UIApplication.shared.endEditing(true)
                        self.searchText = ""
                        self.showCancelButton = false
                    }
                    .foregroundColor(Color(.systemBlue))
                }
            }
            .padding(.horizontal)
            .navigationBarHidden(showCancelButton)
            
            //                List(songs.filter{ $0.name.hasPrefix(searchText) || searchText == "" }) { song in
            //                    SongRow(song: song)
            //                }
            List {
                ForEach(getSongs()) { song in
                    Button(action: {
                        self.queue.objectWillChange.send()
                        self.queue.queue(song)
                        print(song.id)
                        print(song.uri)
                        self.presentation.wrappedValue.dismiss()
                    }) {
                        SongRow(song: song)
                    }
//                    SongRow(song: song)
                    
//                    NavigationLink(destination: RoomView()) {
//                        SongRow(song: song)
//                    }
                }
            }
//            List(getSongs()) { song in
////                queue.queue(song)
//                NavigationLink(destination: RoomView()) {
////                    songs.append(song)
//                    queue.queue(song)
//                    SongRow(song: song)
//                }
////                ForEach(tracks) {track in
////                    //                song = Song(id: 0, track.name, track.artist.name, .Spotify)
////                    SongRow(song: Song(id: 0, track.name, track.artist.name, .Spotify))
////                }
//            }
        }
        .navigationBarTitle("Search")
        .resignKeyboardOnDragGesture()
    }
    
    func getSongs() -> [Song] {
        var songs: [Song] = []
        
        for track in self.tracks {
            songs.append(Song(id: track.id, uri: track.uri, track.name, track.artist.name, .Spotify))
        }
        
        return songs
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(queue: QueueViewModel()).environmentObject(ViewRouter())
    }
}
