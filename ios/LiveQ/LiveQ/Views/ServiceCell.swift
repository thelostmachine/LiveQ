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
    
    var body: some View {
        HStack {
            Image(uiImage: self.service.image)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            
            Text(self.service.name)
            
            Spacer()
            
            Image(systemName: (service.isSelected ? "checkmark.square" : "square")).onTapGesture {
                self.service.isSelected = !self.service.isSelected
                if self.service.isSelected {
                    print("calling connect")
                    self.service.connect()
                }
            }
            
        }
        .padding()
    }
}


struct ServiceCell_Previews: PreviewProvider {
    static var previews: some View {
        ServiceCell(service: SoundCloud.instance)
    }
}
