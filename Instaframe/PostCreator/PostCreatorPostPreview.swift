//
//  PostCreatorPostPreview.swift
//  Instaframe
//
//  Created by Jean-Baptiste Waring on 2021-02-14.
//

import SwiftUI

struct PostCreatorPostPreview: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Binding var currentUser:InstaUser
    @Binding var selectedImage:UIImage?
    @StateObject var newPost:InstaframePost = InstaframePost()
    @State var goBackHome:Bool = false
    
    var body: some View {
        
        
        VStack {
            Image(uiImage: selectedImage ?? UIImage(named: "preview_gradient")!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 312, height: 403, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: .continuous))
                .shadow(color: Color(.black).opacity(0.2), radius: 20, x: 0, y: 10)
            Button(action: createPost) {
                Text("Create Post")
                    .font(.system(size: 25, weight: .medium, design: .rounded))
                    .foregroundColor(checkPicture() ? .white : .gray)
                    .frame(width: 300, height: 50)
                    .background(checkPicture() ? Color.blue : Color.gray)
                    
                    .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous ))
                    
                    .shadow(color: Color(.black).opacity(0.2), radius: 20, x: 0, y: 10)
                
            }.padding(.top, 50)
            Text(checkPicture() ? "Swipe left to take another picture." : "Please take a picture.")
                .offset(x: 0, y: 40)
                
        }
        .fullScreenCover(isPresented: $goBackHome, content: {
            Home(currentUser: $currentUser).environment(\.managedObjectContext, managedObjectContext)
        })
        
        
    }
}

struct PostCreatorPostPreview_Previews: PreviewProvider {
    static var previews: some View {
        PostCreatorPostPreview(currentUser: .constant(sampleUser), selectedImage: .constant(UIImage(named: "sampleimage")))
    }
}

extension PostCreatorPostPreview {
    func checkPicture() -> Bool {
        
        if(selectedImage == nil){
            return false
        }
        return true
    }
    func createPost() {
        if(checkPicture()){
        let newItem = InstaframePost(context: managedObjectContext)
        newItem.userID = currentUser.userName
        newItem.image = selectedImage!.pngData()

        
        saveItems()
        }
    }
    func saveItems() {
        do {
            try managedObjectContext.save()
            print("saved Item")
            self.goBackHome.toggle()
        } catch {
            print(error)
        }
    }
}

