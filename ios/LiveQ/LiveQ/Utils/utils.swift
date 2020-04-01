//
//  utils.swift
//  LiveQ
//
//  Created by Shaheer Mirza on 3/21/20.
//  Copyright © 2020 Shaheer Mirza. All rights reserved.
//

import Foundation
import SwiftUI

//let songs: [Song] = [
//    Song(id: 0, "Divinity", "Porter Robinson", .Spotify),
//    Song(id: 1, "Sound of Walking Away", "Illenium", .Spotify),
//    Song(id: 2, "44 Bars", "Logic", .SoundCloud),
//    Song(id: 3, "FEFE", "6ix9ine", .SoundCloud),
//]

extension Color {
    init(hex: Int, alpha: Double = 1) {
        let components = (
            R: Double((hex >> 16) & 0xff) / 255,
            G: Double((hex >> 08) & 0xff) / 255,
            B: Double((hex >> 00) & 0xff) / 255
        )
        
        self.init(
            .sRGB,
            red: components.R,
            green: components.G,
            blue: components.B,
            opacity: alpha)
    }
}

enum Page {
    case Home, Room, Service, Search
}

enum Service: String {
    case Spotify, SoundCloud
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{ $0.isKeyWindow }
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{ _ in
        UIApplication.shared.endEditing(true)
    }
    
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}

protocol PlayerStateDelegate {
    func next(state: SPTAppRemotePlayerState)
}
