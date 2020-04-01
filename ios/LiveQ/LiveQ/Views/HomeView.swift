//
//  ContentView.swift
//  LiveQ
//
//  Created by Shaheer Mirza on 3/21/20.
//  Copyright © 2020 Shaheer Mirza. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        VStack {
            Spacer()
            
            Button(action: {
                print("creating room")
                self.viewRouter.currentPage = .Room
                // TODO: start new queue with empty list of songs
                
            }) {
                Text("Create a Room")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: 0xffed6c6c))
                    .foregroundColor(Color.white)
                    .font(.title)
            }
            .padding()
            
            Button(action: {
                print("joining a party")
                self.viewRouter.currentPage = .Room
                // TODO: get queue and init Room with list of songs
            }) {
                Text("Join a Party")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: 0xffed6c6c))
                    .foregroundColor(Color.white)
                    .font(.title)
            }
            .padding()
            
            Spacer()
                .frame(height: 40)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(ViewRouter())
    }
}
