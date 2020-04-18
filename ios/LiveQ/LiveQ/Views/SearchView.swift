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
    @ObservedObject var queue: QueueViewModel
    
    @State private var searchText = ""
    @State private var showCancelButton: Bool = false
    @State private var tracks: [Song] = []
//    @State private var tracks: [SpotifyTrack] = []
    
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
                        
                        self.search(query: self.searchText)
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
            List {
                ForEach(self.tracks) { song in
                    Button(action: {
                        self.queue.objectWillChange.send()
                        self.queue.queue(song)
                        print(song.id)
                        print(song.uri)
                        self.presentation.wrappedValue.dismiss()
                    }) {
                        SongRow(song: song)
                    }
                }
            }
        }
        .navigationBarTitle("Search")
        .resignKeyboardOnDragGesture()
    }
    
    func search(query: String) {
        var search = "https://api.spotify.com/v1/search/?type=track&market=US&q="
        search += formatQuery(query: query)
        
        var request: URLRequest = URLRequest(url: URL(string: search)!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(authorizationToken!)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error while searching: \(error)")
                return
            }
            
            let parsedResult = try? JSONDecoder().decode(SearchResult.self, from: data!)
            if let results = parsedResult {
                self.tracks = results.getSongs()
            }
        }
        task.resume()
        
    }
    
    func formatQuery(query: String) -> String {
        return query.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(queue: QueueViewModel()).environmentObject(ViewRouter())
    }
}
