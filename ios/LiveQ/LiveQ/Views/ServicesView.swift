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
    
    let api = Api.instance
    
    var body: some View {
        List(self.services, id: \.name.hashValue) { service in
            ServiceCell(service: service)
        }
        .onDisappear {
            for var service in self.services {
//                service.connect()
                service.isAllowed = true
                self.api.addService(service: service.name)
                Player.instance.allowedServices.append(service)
            }
        }
    }
}

struct ServicesView_Previews: PreviewProvider {
    static var previews: some View {
        ServicesView().environmentObject(ViewRouter())
    }
}
