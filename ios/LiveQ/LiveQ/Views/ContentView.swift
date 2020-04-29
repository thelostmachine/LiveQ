//
//  ContentView.swift
//  LiveQ
//
//  Created by Shaheer Mirza on 3/21/20.
//  Copyright © 2020 Shaheer Mirza. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        VStack {
            if viewRouter.currentPage == .Home {
                HomeView()
            }
            else if viewRouter.currentPage == .Room {
                RoomView().transition(.move(edge: .trailing))
            }
            else if viewRouter.currentPage == .Service {
                ServicesView().transition(.move(edge: .bottom))
            }
//            else if viewRouter.currentPage == .Search {
//                SearchView().transition(.move(edge: .trailing))
//            }
        }
        .onAppear {
            Api.instance.viewRouter = self.viewRouter
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ViewRouter())
    }
}
