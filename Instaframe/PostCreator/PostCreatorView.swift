//
//  PostCreatorView.swift
//  Instaframe
//
//  Created by Jean-Baptiste Waring on 2021-02-14.
//

import SwiftUI

struct PostCreatorView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Binding var currentUser:InstaUser
    @State var selectedPostImage:UIImage?
    
    var body: some View {
        ZStack {
            TabView() {
                
                PostCreatorCamera(selectedImage: $selectedPostImage).environment(\.managedObjectContext, managedObjectContext)
                    .tabItem { Text("Select or Take a Picture") }
                    .tag(0)
                PostCreatorPostPreview(currentUser: $currentUser, selectedImage: $selectedPostImage).environment(\.managedObjectContext, managedObjectContext)
                    .tabItem { Text("Review Post") }
                tag(1)
            }
        }
    }
}

struct PostCreatorView_Previews: PreviewProvider {
    static var previews: some View {
        PostCreatorView(currentUser: .constant(sampleUser))
    }
}
