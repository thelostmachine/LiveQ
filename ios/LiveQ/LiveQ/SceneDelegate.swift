//
//  SceneDelegate.swift
//  LiveQ
//
//  Created by Shaheer Mirza on 3/21/20.
//  Copyright © 2020 Shaheer Mirza. All rights reserved.
//

import UIKit
import SwiftUI

//fileprivate let application = SpotifyManager.SpotifyDeveloperApplication(
//    clientId: "03237b2409b24752a3f0c33262ad2d02",
//    clientSecret: "52560cee72394fc5a049731f2d8f001e",
//    redirectUri: "spotify-ios-quick-start://spotify-login-callback"
//)

//let spotifyManager = SpotifyManager(with: application)

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var alreadyConnected: Bool = false
    
    private(set) static var shared: SceneDelegate?
    
//    var playerState: SPTAppRemotePlayerState!
//
//    var playerStateDelegate: PlayerStateDelegate?
//
//    static private let kAccessTokenKey = "access-token-key"
//    private let redirectUri = URL(string: "spotify-ios-quick-start://spotify-login-callback")!
//    private let clientIdentifier = "03237b2409b24752a3f0c33262ad2d02"
//    let trackIdentifier = "spotify:track:58kNJana4w5BIjlZE2wq5m"
//
//
//    lazy var configuration: SPTConfiguration = {
//        let configuration = SPTConfiguration(clientID: clientIdentifier, redirectURL: redirectUri)
//        configuration.playURI = self.trackIdentifier
//        configuration.tokenSwapURL = URL(string: "http://localhost:1234/swap")
//        configuration.tokenRefreshURL = URL(string: "http://localhost:1234/refresh")
//        return configuration
//    }()
//
//    lazy var appRemote: SPTAppRemote = {
//        let appRemote = SPTAppRemote(configuration: self.configuration, logLevel: .debug)
//        appRemote.connectionParameters.accessToken = self.accessToken
//        appRemote.delegate = self
//        return appRemote
//    }()
//
//    var accessToken = UserDefaults.standard.string(forKey: kAccessTokenKey) {
//        didSet {
//            let defaults = UserDefaults.standard
//            defaults.set(accessToken, forKey: SceneDelegate.kAccessTokenKey)
//        }
//    }
    
    var window: UIWindow?
    
    let spotify = Spotify.instance as! Spotify
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        spotify.setToken(openURLContexts: URLContexts)
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let _ = (scene as? UIWindowScene) else { return }
        Self.shared = self
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        // Get the managed object context from the shared persistent container.
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Create the SwiftUI view and set the context as the value for the managedObjectContext environment keyPath.
        // Add `@Environment(\.managedObjectContext)` in the views that will need the context.
        let contentView = ContentView().environment(\.managedObjectContext, context).environmentObject(ViewRouter())
        
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        if let currentService = Player.instance.currentService as? Spotify,
            !currentService.appRemote.isConnected {
            print("CONNECTING ACTIVE")
            spotify.connect()
        }
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
//        spotify.disconnect()
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}


struct SceneDelegate_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
