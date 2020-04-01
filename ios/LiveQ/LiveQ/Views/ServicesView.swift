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
    
    var body: some View {
        Text("Hello, Services!")
    }
}

struct ServicesView_Previews: PreviewProvider {
    static var previews: some View {
        ServicesView().environmentObject(ViewRouter())
    }
}
