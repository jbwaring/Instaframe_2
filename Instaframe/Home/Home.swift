//
//  Home.swift
//  Instaframe
//
//  Created by Jean-Baptiste Waring on 2021-02-07.
//

import SwiftUI

struct Home: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var showSettings = false
    @Binding var currentUser:InstaUser
    var body: some View {
        TabView {
            ContentView(showSettings: $showSettings, currentUser: $currentUser).environment(\.managedObjectContext, managedObjectContext)
                .tabItem {
                    Image(systemName: "newspaper")
                    Text("Home")
                    
                }
            
            PostCreatorView(currentUser: $currentUser).environment(\.managedObjectContext, managedObjectContext)
                .tabItem {
                    Image(systemName: "plus.rectangle.portrait")
                    Text("New Post")

                }
            HomeFeedView(username: "jbwaring", currentuser: currentUser)
                .tabItem {
                    Image(systemName: "person")
                    Text("Me")
                }
            
        }.sheet(isPresented: $showSettings, onDismiss: {updateUser()}, content: {
            SettingsView( currentUser: $currentUser).environment(\.managedObjectContext, managedObjectContext)
        })
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(currentUser: .constant(sampleUser))
    }
}

extension Home {
    func updateUser() {
        
    }
}
