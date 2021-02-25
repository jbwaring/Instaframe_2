//
//  ContentView.swift
//  Instaframe
//
//  Created by Jean-Baptiste Waring on 2021-02-06.
//

import SwiftUI
import CoreData
import CloudKit


struct ContentView: View {
   // @State var userUUID:String
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: InstaframePost.getPostFetchRequest())  var postList: FetchedResults<InstaframePost>
    @Binding var showSettings:Bool
    @Binding var currentUser:InstaUser
    
    var body: some View {
        VStack {
            
            HStack {
                Text("Instaframe")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                Spacer()
                    //Image("sampleimage")
                //Image(uiImage: UIImage(data: currentUser.avatar ?? Data()) ?? UIImage(imageLiteralResourceName: "sampleimage"))
                Image(uiImage: UIImage(data: currentUser.avatar!)!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .background(Color.white)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                
                Button(action: {self.showSettings.toggle()}) {
                    Image(systemName: "gearshape")
                        .renderingMode(.original)
                        .font(.system(size: 16, weight: .medium))
                        .frame(width: 36, height: 36)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                }
            }
            .padding(.horizontal)
            .padding(.leading, 14)
            .padding(.top, 30)

            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 250) {
                    ForEach(postList) { item in
                       GeometryReader { geometry in
                            CardView(post: item)
                                .padding(.horizontal, 30)
                                .padding(.top, 30)
                                
                       }
                    }
                }
            }
            
        }.onAppear(perform: {

        })
        

    }
    
    
    
    func deleteItem(indexSet: IndexSet) {
        let source = indexSet.first!
        let listItem = postList[source]
        managedObjectContext.delete(listItem)
        saveItems()
    }
    
    func addItem() {
        let newItem = InstaframePost(context: managedObjectContext)
        newItem.userID = "New Item \(postList.count+1)"
      //  print("There are \(postList[0].likeCount) records")
        
        saveItems()
       
    }
    
    func saveItems() {
        do {
            try managedObjectContext.save()
            print("saved Item")
        } catch {
            print(error)
        }
    }
    
//
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView( showSettings: .constant(false), currentUser: .constant(InstaUser()))
    }
}

let sampleUser = InstaUser()

