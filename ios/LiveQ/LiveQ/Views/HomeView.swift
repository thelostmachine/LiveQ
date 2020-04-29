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
    @State var showingDetail = false
    
    let api = Api.instance
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button(action: {
                    self.showingDetail.toggle()
                }) {
                    Image(systemName: "gear")
                        .renderingMode(Image.TemplateRenderingMode?.init(Image.TemplateRenderingMode.original))
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding()
                    
                }.sheet(isPresented: $showingDetail) {
                    ServicesView()
                }
            }
            
            Spacer()
            
            Text("LiveQ")
                .font(.system(size: 60))
                .foregroundColor(.gray)
                .fontWeight(.bold)
            
            Spacer()
            
            Button(action: {
                print("creating room")
                self.alert(creating: true)
//                self.viewRouter.currentPage = .Room
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
                self.alert(creating: false)
//                self.viewRouter.currentPage = .Room
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
    
    private func alert(creating: Bool) {
        let title: String = creating ? "Creating Room" : "Joining Room"
        let message: String = creating ? "Enter Room Name" : "Enter Room ID"
        let placeholder = creating ? "Room Name" : "Room ID"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField() { textField in
            if !creating {
                textField.text = self.viewRouter.roomKey
            } else {
                textField.placeholder = placeholder
            }
        }
        // TODO: add loading screen when communicating with server
        alert.addAction(UIAlertAction(title: "Confirm", style: .default) { _ in
                
            if creating {
                
                let roomName = alert.textFields?.first?.text ?? "Party"
                self.api.createRoom(roomName: roomName, self.incorrectAlert)
                
            } else {
                
                let roomKey = alert.textFields?.first?.text ?? ""
                if roomKey.isEmpty {
                    self.incorrectAlert(wrongName: false)
                } else {
                    self.api.joinRoom(roomKey: roomKey, self.incorrectAlert)
                }
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in })
        
        showAlert(alert: alert)
    }
    
    private func incorrectAlert(wrongName: Bool) {
        let title: String = wrongName ? "Invalid Room Name" : "Incorrect Room ID"
        let message: String = wrongName ? "Please enter a Room Name" : "Please enter the correct ID"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        
        showAlert(alert: alert)
    }
    
    private func showAlert(alert: UIAlertController) {
        if let controller = topMostViewController() {
            controller.present(alert, animated: true)
        }
    }
    
    private func keyWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.filter { $0.isKeyWindow }.first
    }
    
    private func topMostViewController() -> UIViewController? {
        guard let rootController = keyWindow()?.rootViewController else {
            return nil
        }
        return topMostViewController(for: rootController)
    }
    
    private func topMostViewController(for controller: UIViewController) -> UIViewController {
        if let presentedController = controller.presentedViewController {
            return topMostViewController(for: presentedController)
        }
        else if let navigationController = controller as? UINavigationController {
            guard let topController = navigationController.topViewController else {
                return navigationController
            }
            
            return topMostViewController(for: topController)
        }
        else if let tabController = controller as? UITabBarController {
            guard let topController = tabController.selectedViewController else {
                return tabController
            }
            
            return topMostViewController(for: topController)
        }
        
        return controller
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(ViewRouter())
    }
}
