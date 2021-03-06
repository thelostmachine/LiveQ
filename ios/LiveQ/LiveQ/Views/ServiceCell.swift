//
//  ServiceCell.swift
//  LiveQ
//
//  Created by Shaheer Mirza on 4/20/20.
//  Copyright © 2020 Shaheer Mirza. All rights reserved.
//

import SwiftUI

struct ServiceCell: View {
    @State var service: Service
    var player: Player = Player.instance
    @State var isSelected: Bool = false
    let api = Api.instance
    // TODO persist the 
    
    var body: some View {
        HStack {
            Image(uiImage: self.service.image)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            
            Text(self.service.name)
            
            Spacer()
            
            Image(systemName: (self.isSelected ? "checkmark.square" : "square")).onTapGesture {
                self.isSelected = !self.isSelected
                print(self.isSelected)
                if self.isSelected {
                    self.service.isSelected = true
                    self.service.connect()
//                    client.addService(self.service) // TODO
//                    self.player.connectedServices.append(self.service)
//                    self.player.allowedServices.append(self.service)
                } else {
                    self.service.isSelected = false
                }
            }
        }
        .padding()
        .onAppear {
            self.isSelected = self.service.isSelected
        }
    }
}


struct ServiceCell_Previews: PreviewProvider {
    static var previews: some View {
        ServiceCell(service: SoundCloud.instance)
    }
}
