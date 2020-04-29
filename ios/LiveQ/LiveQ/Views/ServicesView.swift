//
//  ServicesView.swift
//  LiveQ
//
//  Created by Shaheer Mirza on 3/21/20.
//  Copyright © 2020 Shaheer Mirza. All rights reserved.
//

import SwiftUI

struct ServicesView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State var services: [Service] = [Spotify.instance, SoundCloud.instance]
    @ObservedObject var player: Player = Player.instance
    
    let api = Api.instance
    
    var body: some View {
        List(self.services, id: \.name.hashValue) { service in
            ServiceCell(service: service)
        }
        .onDisappear {
            var allowedServices: [Service] = [Service]()
            for var service in self.services {
//                service.connect()
                if service.isSelected {
                    service.isAllowed = true
                    allowedServices.append(service)
                    print("set \(service.name)")
                }
            }
            self.player.setAllowedServices(services: allowedServices)
        }
    }
}

struct ServicesView_Previews: PreviewProvider {
    static var previews: some View {
        ServicesView().environmentObject(ViewRouter())
    }
}
