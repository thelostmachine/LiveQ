//
//  ViewRouter.swift
//  LiveQ
//
//  Created by Shaheer Mirza on 3/21/20.
//  Copyright © 2020 Shaheer Mirza. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class ViewRouter: ObservableObject {
    
    let objectWillChange = PassthroughSubject<ViewRouter, Never>()
    
    var currentPage: Page = .Home {
        didSet {
            withAnimation() {
                objectWillChange.send(self)
            }
        }
    }
    
    var roomName: String = ""
    var roomKey: String = ""
    var isHost: Bool = false
}
