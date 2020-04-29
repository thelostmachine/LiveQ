//
//  Services.swift
//  LiveQ
//
//  Created by Shaheer Mirza on 4/19/20.
//  Copyright © 2020 Shaheer Mirza. All rights reserved.
//

import Foundation
import AVKit
import Alamofire

enum ServiceType: String {
    case Spotify, SoundCloud, Apple
}

protocol Service {
    
    static var instance: Service { get }
    var name: String { get }
    var isSelected: Bool { get set }
    var isConnected: Bool { get set }
    var isAllowed: Bool { get set }
    var image: UIImage { get }
    
    func connect()
    func play(_ uri: String)
    func resume()
    func pause()
    func stop()
    func search(query: String, finished: @escaping (_ songs: [Song]) -> Void)
}

extension Service {
    func formatSearch(query: String) -> String {
        var s: String = query.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        s = s.replacingOccurrences(of: "(", with: "%28", options: .literal, range: nil)
        return s.replacingOccurrences(of: ")", with: "%29", options: .literal, range: nil)
    }
}

class SoundCloud: Service {
    static let instance: Service = SoundCloud()
    private init() {}
    
    var isConnected: Bool = true
    var isAllowed: Bool = true
    
    var name: String = "SoundCloud"
    var isSelected: Bool = true
    var image: UIImage = UIImage(named: "soundcloud.png")!
    
    final var clientId: String = "e38841b15b2059a39f261df195dfb430";
    final var playId: String = "e38841b15b2059a39f261df195dfb430";
    final var userId: String = "857371-474509-874152-946359";
    
    var player: AVPlayer?
    
    func connect() {
        // do nothing
        self.isConnected = true
    }
    
    func play(_ id: String) {
        let playUri: String = "https://api.soundcloud.com/tracks/\(id)/stream?client_id=\(clientId)"
        print("wanting to play \(playUri)")
        player = AVPlayer(url: URL(string: playUri)!)
        player?.play()
        NotificationCenter.default.addObserver(Player.instance, selector: #selector(Player.instance.next), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    func resume() {
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    func stop() {
        print("SC stopping")
        player?.replaceCurrentItem(with: nil)
        player = nil
    }
    
    func search(query: String, finished: @escaping (_ songs: [Song]) -> Void) {
        
        let search = "https://api.soundcloud.com/tracks?q=\(formatSearch(query: query))&limit=100&format=json&client_id=\(clientId)"
        
        var request: URLRequest = URLRequest(url: URL(string: search)!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            
            var searchResults = [Song]()
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? [AnyObject] else {
                print("ERROR: conversion from JSON failed")
                return
            }
            
            for item in json {
                guard let track = item as? [String: Any] else { return }
                let artworkUrl: String = track["artwork_url"] as? String ?? ""
                let kind: String = track["kind"] as? String ?? ""

                if !kind.isEmpty && !artworkUrl.isEmpty {
                    let artistJson = track["user"]
                    let artistConvert = artistJson as! [String: Any]
                    let artistObject = Artist.init(name: artistConvert["username"] as! String)
                    
                    let id = "\(track["id"] ?? 0)"
                    let uri = track["uri"] as! String
                    let trackName = track["title"] as! String
                    let artist = artistObject
                    let imageUri = artworkUrl
                    let duration = track["duration"] as! Int
                    let service = self
                    
                    let song = Song(
                        id: Int(id) ?? Int.random(in: 1..<1500),
                        trackId: id,
                        uri: uri,
                        name: trackName,
                        artists: [artist],
                        imageUri: imageUri,
                        duration: duration,
                        service: service
                    )
                    
                    searchResults.append(song)
                }
            }
            finished(searchResults)
        }
        task.resume()
    }
    
    func testTrack(id: String, finished: @escaping ((_ isSuccess: Bool) -> Void)) {
        let testUrl = "https://api.soundcloud.com/tracks/\(id)?client_id=\(playId)"
        var request: URLRequest = URLRequest(url: URL(string: testUrl)!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response {
                let httpResponse = response as! HTTPURLResponse
                
                if httpResponse.statusCode == 200 {
                    finished(true)
                } else {
                    finished(false)
                }
            }
        }
        task.resume()
    }
}

class Spotify: NSObject, Service, SPTAppRemoteDelegate {
    
    var isSelected: Bool = false
    var isConnected: Bool = false
    var isAllowed: Bool = false
    
    var image: UIImage = UIImage(named: "spotify")!
    
    static let instance: Service = Spotify()
    
    private override init() {}
    
    var name: String = "Spotify"
    
    var playerState: SPTAppRemotePlayerState?
    var playerStateDelegate: PlayerStateDelegate?
    
    static private let kAccessTokenKey = "access-token-key"
    private let redirectUri = URL(string: "spotify-ios-quick-start://spotify-login-callback")!
    private let clientIdentifier = "03237b2409b24752a3f0c33262ad2d02"
    private let clientSecret = "52560cee72394fc5a049731f2d8f001e"
    private var trackIdentifier = "spotify:track:7p5bQJB4XsZJEEn6Tb7EaL"
    
    private var webToken: String?
    
    lazy var configuration: SPTConfiguration = {
        let configuration = SPTConfiguration(clientID: clientIdentifier, redirectURL: redirectUri)
        configuration.playURI = self.trackIdentifier
        configuration.tokenSwapURL = URL(string: "http://localhost:1234/swap")
        configuration.tokenRefreshURL = URL(string: "http://localhost:1234/refresh")
        return configuration
    }()
    
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: self.configuration, logLevel: .debug)
        appRemote.connectionParameters.accessToken = self.accessToken
        appRemote.delegate = self
        return appRemote
    }()
    
    var accessToken = UserDefaults.standard.string(forKey: kAccessTokenKey) {
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(accessToken, forKey: Spotify.kAccessTokenKey)
        }
    }
    
    func connect() {
        
//        let parameters = ["client_id": self.clientIdentifier,
//                          "client_secret": self.clientSecret,
//                          "grant_type": "client_credentials"]
//
//        AF.request("https://accounts.spotify.com/api/token", method: .post, parameters: parameters).responseJSON(completionHandler: { response in
//
//            print(response)
//            print(response.result)
//            let jsonData = response.value as! NSDictionary
//            let token = jsonData.value(forKey: "access_token") as? String
//            self.accessToken = token!
//        })
        
        if Player.instance.isHost {
            print("authorize and play")
//            self.appRemote.authorizeAndPlayURI(trackIdentifier)
//            self.isConnected = self.accessToken != nil
            print("here")
//            DispatchQueue.main.async {
            self.appRemote.authorizeAndPlayURI(self.trackIdentifier)
            print("connecting on \(Thread.current)")
            print(self.appRemote.connectionParameters.accessToken)
            self.appRemote.connect()
//            }
//            DispatchQueue.main.schedule(after: ) {
//                self.appRemote.connect()
//            }
//            if let _ = self.appRemote.connectionParameters.accessToken {
//                print("reconnecting")
//                self.appRemote.connect()
//                self.isConnected = self.accessToken != nil
//            } else {
//                print("authorize and play")
//                self.appRemote.authorizeAndPlayURI(trackIdentifier)
//                self.isConnected = self.accessToken != nil
//            }
            
            print("pausing")
            print(self.appRemote.playerAPI == nil)
            self.appRemote.playerAPI?.pause()
        }
    }
    
    func play(_ uri: String) {
        print("spotify playing \(uri)")
        print("connected: \(self.appRemote.isConnected)")
        self.trackIdentifier = uri
        if !self.appRemote.isConnected {
            self.appRemote.authorizeAndPlayURI(uri)
        } else {
            self.appRemote.playerAPI?.play(uri)
        }
        
        SceneDelegate.shared?.alreadyConnected = true
        
        
    }
    
    func resume() {
        self.appRemote.playerAPI?.resume()
    }
    
    func pause() {
        self.appRemote.playerAPI?.pause()
    }
    
    func stop() {
        
    }
    
    func search(query: String, finished: @escaping (_ songs: [Song]) -> Void) {
        var searchResults = [Song]()
        
        var search = "https://api.spotify.com/v1/search/?type=track&market=US&q="
        search += formatSearch(query: query)
        
        var request: URLRequest = URLRequest(url: URL(string: search)!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(self.accessToken!)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error while searching: \(error)")
                return
            }

            let parsedResult = try? JSONDecoder().decode(SearchResult.self, from: data!)
            if let results = parsedResult {
                searchResults = results.getSongs()
                print("found \(searchResults.count) results")
                finished(searchResults)
            }
        }
        task.resume()
    }
    
    func setToken(openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        guard let url = URLContexts.first?.url else { return }
        
        let parameters = appRemote.authorizationParameters(from: url)
        
        if let access_token = parameters?[SPTAppRemoteAccessTokenKey] {
            appRemote.connectionParameters.accessToken = access_token
            self.accessToken = access_token
        } else if let error_description = parameters?[SPTAppRemoteErrorDescriptionKey] {
            print(error_description)
        }
    }
    
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        self.appRemote.playerAPI?.delegate = Player.instance
        self.appRemote.playerAPI?.subscribe(toPlayerState: { (result, error) in
            if let error = error {
                print(error.localizedDescription)
            }
        })
        self.appRemote.playerAPI?.setRepeatMode(.off)
        print("established connection \(Thread.current)")
        
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        self.appRemote.authorizeAndPlayURI(trackIdentifier)
        self.appRemote.connect()
        print("failed connected \(error)")
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        
        print("disconnectedWithError: \(error)")
    }
    
    func disconnect() {
        if self.appRemote.isConnected {
            self.appRemote.disconnect()
            self.isConnected = false
        }
    }
    
}
